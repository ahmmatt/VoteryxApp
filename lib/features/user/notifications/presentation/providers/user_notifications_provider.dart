// lib/features/user/notifications/presentation/providers/user_notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'election', 'vote', 'delegation', 'proposal_approved', 'proposal_rejected', 'proposal_pending', 'candidate_nominated'
  final bool isRead;
  /// Notif 'candidate_nominated' tidak bisa dismiss sebelum docs_completed = true
  final bool isDismissible;
  final String? referenceId;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.isDismissible = true,
    this.referenceId,
  });
}

final userNotificationsProvider = FutureProvider.autoDispose<List<AppNotificationItem>>((ref) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return [];

  final client = SupabaseConfig.client;
  final List<AppNotificationItem> items = [];

  // Helper untuk parse timestamp UTC dari Supabase dengan aman
  DateTime _parseTimestamp(String? timestampStr) {
    if (timestampStr == null || timestampStr.isEmpty) return DateTime.now();
    var parsed = DateTime.tryParse(timestampStr) ?? DateTime.now();
    // Jika tidak ada info timezone (Z atau offset) di string, itu berarti UTC dari Postgres
    if (!parsed.isUtc && !timestampStr.endsWith('Z') && !timestampStr.contains('+') && (timestampStr.length > 10 && !timestampStr.substring(10).contains('-'))) {
      parsed = DateTime.utc(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.minute, parsed.second, parsed.millisecond, parsed.microsecond);
    }
    return parsed.toLocal(); // Pastikan selalu dikonversi ke waktu lokal HP pengguna
  }

  // ── 1. Baca notifikasi persisten dari tabel user_notifications ────────────
  try {
    final persistentRes = await client
        .from('user_notifications')
        .select('id, title, message, type, is_read, is_dismissed, reference_id, created_at')
        .eq('user_id', userId)
        .eq('is_dismissed', false)          // hanya yang belum di-dismiss
        .order('created_at', ascending: false)
        .limit(20);

    for (final n in (persistentRes as List)) {
      final type = n['type']?.toString() ?? 'info';
      final isRead = n['is_read'] as bool? ?? false;

      // Cek apakah kandidat sudah melengkapi berkas (untuk 'candidate_nominated')
      bool isDismissible = true;
      if (type == 'candidate_nominated') {
        final referenceId = n['reference_id']?.toString();
        if (referenceId != null) {
          try {
            final candidateRow = await client
                .from('proposal_candidates')
                .select('docs_completed')
                .eq('proposal_id', referenceId)
                .eq('user_id', userId)
                .maybeSingle();
            final docsCompleted = candidateRow?['docs_completed'] as bool? ?? false;
            isDismissible = docsCompleted; // hanya bisa dismiss jika sudah lengkap
          } catch (_) {
            isDismissible = false;
          }
        } else {
          isDismissible = false;
        }
      }

      items.add(AppNotificationItem(
        id: 'notif_${n['id']}',
        title: n['title']?.toString() ?? '',
        message: n['message']?.toString() ?? '',
        timestamp: _parseTimestamp(n['created_at']?.toString()),
        type: type,
        isRead: isRead,
        isDismissible: isDismissible,
        referenceId: n['reference_id']?.toString(),
      ));
    }
  } catch (_) {}

  // ── 2. Pemilihan aktif terbaru ────────────────────────────────────────────
  try {
    final electionsRes = await client
        .from('elections')
        .select('id, title, status, start_date, created_at')
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(4);

    for (final e in (electionsRes as List)) {
      final createdAt = _parseTimestamp(e['created_at']?.toString());
      items.add(AppNotificationItem(
        id: 'election_${e['id']}',
        title: 'Pemilihan Aktif: ${e['title']}',
        message: 'Pemilihan ini sedang berlangsung. Gunakan hak suaramu sekarang juga!',
        timestamp: createdAt,
        type: 'election',
      ));
    }
  } catch (_) {}

  // ── 3. Riwayat suara user ─────────────────────────────────────────────────
  try {
    final votesRes = await client
        .from('votes')
        .select('id, created_at, election_id, elections(title)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(4);

    for (final v in (votesRes as List)) {
      final createdAt = _parseTimestamp(v['created_at']?.toString());
      final electionData = v['elections'] as Map<String, dynamic>?;
      final electionTitle = electionData?['title'] ?? 'Pemilihan';
      items.add(AppNotificationItem(
        id: 'vote_${v['id']}',
        title: 'Suara Berhasil Diberikan',
        message: 'Suaramu pada "$electionTitle" telah berhasil direkam secara terenkripsi di database.',
        timestamp: createdAt,
        type: 'vote',
      ));
    }
  } catch (_) {}

  // ── 4. Riwayat delegasi suara ─────────────────────────────────────────────
  try {
    final delRes = await client
        .from('delegations')
        .select('id, created_at, election_id, elections(title)')
        .eq('delegator_id', userId)
        .order('created_at', ascending: false)
        .limit(4);

    for (final d in (delRes as List)) {
      final createdAt = _parseTimestamp(d['created_at']?.toString());
      final electionData = d['elections'] as Map<String, dynamic>?;
      final electionTitle = electionData?['title'] ?? 'Pemilihan';
      items.add(AppNotificationItem(
        id: 'del_${d['id']}',
        title: 'Delegasi Suara Berhasil',
        message: 'Hak suaramu untuk "$electionTitle" telah resmi didelegasikan kepada delegator pilihanmu.',
        timestamp: createdAt,
        type: 'delegation',
      ));
    }
  } catch (_) {}

  // ── 5. Status usulan pemilihan dari user ──────────────────────────────────
  try {
    final propRes = await client
        .from('election_proposals')
        .select('id, title, status, admin_note, created_at')
        .eq('proposer_id', userId)
        .order('created_at', ascending: false)
        .limit(5);

    for (final p in (propRes as List)) {
      final createdAt = _parseTimestamp(p['created_at']?.toString());
      final status = p['status']?.toString() ?? 'pending';
      final title = p['title']?.toString() ?? 'Usulan Pemilihan';
      final note = p['admin_note']?.toString() ?? '';

      if (status == 'approved') {
        items.add(AppNotificationItem(
          id: 'prop_${p['id']}',
          title: 'Usulan Diterima: $title',
          message: note.isNotEmpty ? 'Catatan Admin: $note' : 'Usulan pemilihanmu telah disetujui oleh admin dan akan segera dipersiapkan.',
          timestamp: createdAt,
          type: 'proposal_approved',
        ));
      } else if (status == 'rejected') {
        items.add(AppNotificationItem(
          id: 'prop_${p['id']}',
          title: 'Usulan Ditolak: $title',
          message: note.isNotEmpty ? 'Alasan Ditolak: $note' : 'Mohon maaf, usulan pemilihanmu belum dapat dilanjutkan saat ini.',
          timestamp: createdAt,
          type: 'proposal_rejected',
        ));
      } else {
        items.add(AppNotificationItem(
          id: 'prop_${p['id']}',
          title: 'Usulan Dalam Peninjauan: $title',
          message: 'Usulan pemilihanmu saat ini sedang diproses dan ditinjau oleh tim verifikator admin.',
          timestamp: createdAt,
          type: 'proposal_pending',
        ));
      }
    }
  } catch (_) {}

  // Urutkan berdasarkan timestamp terbaru
  items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return items;
});

/// Dismiss notifikasi — hanya untuk notif yang bisa di-dismiss
final dismissNotificationProvider = FutureProvider.family.autoDispose<void, String>((ref, notifDbId) async {
  await SupabaseConfig.client
      .from('user_notifications')
      .update({'is_dismissed': true, 'is_read': true})
      .eq('id', notifDbId);
  ref.invalidateSelf();
});
