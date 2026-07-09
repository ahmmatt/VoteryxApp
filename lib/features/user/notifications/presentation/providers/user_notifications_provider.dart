// lib/features/user/notifications/presentation/providers/user_notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'election', 'vote', 'delegation', 'proposal_approved', 'proposal_rejected', 'proposal_pending'
  final bool isRead;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

final userNotificationsProvider = FutureProvider.autoDispose<List<AppNotificationItem>>((ref) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return [];

  final client = SupabaseConfig.client;
  final List<AppNotificationItem> items = [];

  try {
    // 1. Ambil pemilihan aktif terbaru dari database
    final electionsRes = await client
        .from('elections')
        .select('id, title, status, start_date, created_at')
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(4);

    for (final e in (electionsRes as List)) {
      final createdAt = DateTime.tryParse(e['created_at']?.toString() ?? '') ?? DateTime.now();
      items.add(
        AppNotificationItem(
          id: 'election_${e['id']}',
          title: 'Pemilihan Aktif: ${e['title']}',
          message: 'Pemilihan ini sedang berlangsung. Gunakan hak suaramu sekarang juga!',
          timestamp: createdAt,
          type: 'election',
        ),
      );
    }
  } catch (_) {
    // Abaikan jika error / tabel belum ada data
  }

  try {
    // 2. Ambil riwayat suara (votes) user
    final votesRes = await client
        .from('votes')
        .select('id, created_at, election_id, elections(title)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(4);

    for (final v in (votesRes as List)) {
      final createdAt = DateTime.tryParse(v['created_at']?.toString() ?? '') ?? DateTime.now();
      final electionData = v['elections'] as Map<String, dynamic>?;
      final electionTitle = electionData?['title'] ?? 'Pemilihan';
      items.add(
        AppNotificationItem(
          id: 'vote_${v['id']}',
          title: 'Suara Berhasil Diberikan',
          message: 'Suaramu pada "$electionTitle" telah berhasil direkam secara terenkripsi di database.',
          timestamp: createdAt,
          type: 'vote',
        ),
      );
    }
  } catch (_) {}

  try {
    // 3. Ambil riwayat delegasi suara user
    final delRes = await client
        .from('delegations')
        .select('id, created_at, election_id, elections(title)')
        .eq('delegator_id', userId)
        .order('created_at', ascending: false)
        .limit(4);

    for (final d in (delRes as List)) {
      final createdAt = DateTime.tryParse(d['created_at']?.toString() ?? '') ?? DateTime.now();
      final electionData = d['elections'] as Map<String, dynamic>?;
      final electionTitle = electionData?['title'] ?? 'Pemilihan';
      items.add(
        AppNotificationItem(
          id: 'del_${d['id']}',
          title: 'Delegasi Suara Berhasil',
          message: 'Hak suaramu untuk "$electionTitle" telah resmi didelegasikan kepada delegator pilihanmu.',
          timestamp: createdAt,
          type: 'delegation',
        ),
      );
    }
  } catch (_) {}

  try {
    // 4. Ambil status usulan pemilihan dari user
    final propRes = await client
        .from('election_proposals')
        .select('id, title, status, admin_note, created_at')
        .eq('proposer_id', userId)
        .order('created_at', ascending: false)
        .limit(5);

    for (final p in (propRes as List)) {
      final createdAt = DateTime.tryParse(p['created_at']?.toString() ?? '') ?? DateTime.now();
      final status = p['status']?.toString() ?? 'pending';
      final title = p['title']?.toString() ?? 'Usulan Pemilihan';
      final note = p['admin_note']?.toString() ?? '';

      if (status == 'approved') {
        items.add(
          AppNotificationItem(
            id: 'prop_${p['id']}',
            title: 'Usulan Diterima: $title',
            message: note.isNotEmpty ? 'Catatan Admin: $note' : 'Usulan pemilihanmu telah disetujui oleh admin dan akan segera dipersiapkan.',
            timestamp: createdAt,
            type: 'proposal_approved',
          ),
        );
      } else if (status == 'rejected') {
        items.add(
          AppNotificationItem(
            id: 'prop_${p['id']}',
            title: 'Usulan Ditolak: $title',
            message: note.isNotEmpty ? 'Alasan Ditolak: $note' : 'Mohon maaf, usulan pemilihanmu belum dapat dilanjutkan saat ini.',
            timestamp: createdAt,
            type: 'proposal_rejected',
          ),
        );
      } else {
        items.add(
          AppNotificationItem(
            id: 'prop_${p['id']}',
            title: 'Usulan Dalam Peninjauan: $title',
            message: 'Usulan pemilihanmu saat ini sedang diproses dan ditinjau oleh tim verifikator admin.',
            timestamp: createdAt,
            type: 'proposal_pending',
          ),
        );
      }
    }
  } catch (_) {}

  // Urutkan berdasarkan timestamp terbaru
  items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return items;
});
