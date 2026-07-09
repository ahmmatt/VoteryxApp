// lib/features/user/profile/presentation/providers/history_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

class HistoryItem {
  final String id;
  final String type; // 'vote' atau 'delegation'
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String dateFormatted;
  final String title;
  final String subtitleLabel;
  final String subtitleValue;
  final String? leadingImageUrl;
  final IconData actionIcon;
  final String? transactionHash;
  final String? electionId;
  final String? candidateId;

  const HistoryItem({
    required this.id,
    required this.type,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.dateFormatted,
    required this.title,
    required this.subtitleLabel,
    required this.subtitleValue,
    this.leadingImageUrl,
    required this.actionIcon,
    this.transactionHash,
    this.electionId,
    this.candidateId,
  });
}

final userHistoryProvider = FutureProvider.autoDispose<List<HistoryItem>>((ref) async {
  final client = SupabaseConfig.client;
  final userId = ref.watch(currentUserIdProvider) ?? client.auth.currentUser?.id;

  if (userId == null) {
    return [];
  }

  try {
    final List<HistoryItem> items = [];

    // 1. Ambil data dari tabel votes untuk user ini
    final votesResponse = await client
        .from('votes')
        .select('*, elections(*), candidates(*)')
        .eq('voter_id', userId)
        .order('created_at', ascending: false);

    for (final row in (votesResponse as List)) {
      final map = row as Map<String, dynamic>;
      final electionMap = map['elections'] as Map<String, dynamic>?;
      final candidateMap = map['candidates'] as Map<String, dynamic>?;

      final createdAtStr = map['created_at'] as String?;
      String dateFormatted = 'Baru saja';
      if (createdAtStr != null) {
        try {
          final dt = DateTime.parse(createdAtStr).toLocal();
          dateFormatted = DateFormat('dd MMM yyyy • HH:mm', 'id_ID').format(dt);
        } catch (_) {
          dateFormatted = createdAtStr;
        }
      }

      items.add(HistoryItem(
        id: map['id'].toString(),
        type: 'vote',
        badgeText: 'Terverifikasi',
        badgeColor: AppColors.successBg,
        badgeTextColor: const Color(0xFF0F6E56),
        dateFormatted: dateFormatted,
        title: electionMap?['title'] ?? 'Pemilihan Voteryx',
        subtitleLabel: 'KANDIDAT PILIHAN',
        subtitleValue: candidateMap?['full_name'] ?? 'Kandidat Terpilih',
        leadingImageUrl: candidateMap?['photo_url'],
        actionIcon: Icons.verified_user_outlined,
        transactionHash: map['transaction_hash']?.toString(),
        electionId: map['election_id']?.toString(),
        candidateId: map['candidate_id']?.toString(),
      ));
    }

    // 2. Ambil data dari tabel delegations untuk user ini
    final delegationsResponse = await client
        .from('delegations')
        .select('*, elections(*)')
        .eq('delegator_id', userId)
        .order('created_at', ascending: false);

    for (final row in (delegationsResponse as List)) {
      final map = row as Map<String, dynamic>;
      final electionMap = map['elections'] as Map<String, dynamic>?;
      final delegateId = map['delegate_id']?.toString();

      String delegateName = 'Delegasi Suara';
      String? delegateAvatarUrl;
      if (delegateId != null) {
        try {
          final userRow = await client
              .from('users')
              .select('full_name, avatar_url')
              .eq('id', delegateId)
              .maybeSingle();
          if (userRow != null) {
            delegateName = userRow['full_name'] ?? 'Delegasi';
            delegateAvatarUrl = userRow['avatar_url'];
          }
        } catch (_) {}
      }

      final createdAtStr = map['created_at'] as String?;
      String dateFormatted = 'Baru saja';
      if (createdAtStr != null) {
        try {
          final dt = DateTime.parse(createdAtStr).toLocal();
          dateFormatted = DateFormat('dd MMM yyyy • HH:mm', 'id_ID').format(dt);
        } catch (_) {
          dateFormatted = createdAtStr;
        }
      }

      items.add(HistoryItem(
        id: map['id'].toString(),
        type: 'delegation',
        badgeText: 'Didelegasikan',
        badgeColor: AppColors.warningBg,
        badgeTextColor: AppColors.goldDark,
        dateFormatted: dateFormatted,
        title: electionMap?['title'] ?? 'Delegasi Pemilihan',
        subtitleLabel: 'DELEGASI MELALUI',
        subtitleValue: delegateName,
        leadingImageUrl: delegateAvatarUrl,
        actionIcon: Icons.receipt_long_outlined,
        transactionHash: 'DLG-${map['id']?.toString().substring(0, 16)}',
        electionId: map['election_id']?.toString(),
      ));
    }

    // Urutkan berdasarkan waktu
    items.sort((a, b) => b.id.compareTo(a.id));
    return items;
  } catch (e) {
    return [];
  }
});

