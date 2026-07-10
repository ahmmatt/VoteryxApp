import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/user/election/domain/entities/election.dart';

final adminCandidateVerificationProvider = StateNotifierProvider<
    AdminCandidateVerificationNotifier,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return AdminCandidateVerificationNotifier();
});

class AdminCandidateVerificationNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  AdminCandidateVerificationNotifier() : super(const AsyncValue.loading()) {
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    state = const AsyncValue.loading();
    try {
      final client = SupabaseConfig.client;

      final response1 = await client
          .from('candidates')
          .select('*, elections(title)')
          .order('created_at', ascending: false);

      final response2 = await client
          .from('proposal_candidates')
          .select('*, election_proposals(title), users(faculty, photo_url:avatar_url)')
          .order('created_at', ascending: false);

      final list1 = (response1 as List).cast<Map<String, dynamic>>().map((c) {
        c['is_proposal'] = false;
        return c;
      }).toList();

      final list2 = (response2 as List).cast<Map<String, dynamic>>().map((p) {
        return {
          'id': p['id'],
          'is_proposal': true,
          'full_name': p['full_name'],
          'nim': p['nik_or_nim'],
          'faculty': p['users'] != null ? p['users']['faculty'] : null,
          'photo_url': p['photo_url'] ?? (p['users'] != null ? p['users']['photo_url'] : null),
          'is_verified': p['is_verified'] ?? false,
          'created_at': p['created_at'],
          'elections': {'title': p['election_proposals'] != null ? p['election_proposals']['title'] : 'Usulan Pemilihan'},
          'election_id': p['proposal_id'],
        };
      }).toList();

      final combined = [...list1, ...list2];
      combined.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));

      state = AsyncValue.data(combined);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateVerificationStatus(
      String id, bool isVerified, {bool isProposal = false}) async {
    try {
      final table = isProposal ? 'proposal_candidates' : 'candidates';
      await SupabaseConfig.client
          .from(table)
          .update({'is_verified': isVerified}).eq('id', id);
      await fetchCandidates();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final proposalCandidateDetailProvider = FutureProvider.autoDispose
    .family<Candidate?, String>((ref, candidateId) async {
  final response = await SupabaseConfig.client
      .from('proposal_candidates')
      .select('*, users(faculty, photo_url:avatar_url)')
      .eq('id', candidateId)
      .maybeSingle();

  if (response == null) return null;

  return Candidate(
    id: response['id'],
    electionId: response['proposal_id'],
    fullName: response['full_name'],
    nim: response['nik_or_nim'],
    faculty: response['users'] != null ? response['users']['faculty'] : null,
    photoUrl: response['photo_url'] ?? (response['users'] != null ? response['users']['photo_url'] : null),
    isVerified: response['is_verified'] ?? false,
    visi: response['visi'],
    misi: response['misi'],
    trackRecords: (response['track_records'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    programs: (response['programs'] as List?)?.cast<Map<String, dynamic>>() ?? [],
  );
});

/// Helper konsisten untuk mengambil URL foto kandidat dari database (`photo_url`).
/// Jika tidak ada atau tidak valid di database, mengembalikan null sehingga UI menampilkan icon default.
String? getCandidateAvatarUrl(Map<String, dynamic> c) {
  final photo = c['photo_url']?.toString().trim();
  if (photo != null && photo.isNotEmpty && photo != 'null' && (photo.startsWith('http') || photo.startsWith('data:image'))) {
    return photo;
  }
  return null;
}

/// Widget konsisten untuk menampilkan foto profil kandidat dari database (`photo_url`),
/// atau icon default jika foto tidak ada di database.
Widget buildCandidateAvatarWidget({
  required String? imageUrl,
  required double size,
  double radius = 12,
  Color iconColor = AppColors.primary800,
  Color backgroundColor = const Color(0xFFEFF3F8),
}) {
  final cleanUrl = imageUrl?.trim();
  final hasImage = cleanUrl != null && cleanUrl.isNotEmpty && cleanUrl != 'null' && (cleanUrl.startsWith('http') || cleanUrl.startsWith('data:image'));
  
  Widget fallbackWidget = Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.8)),
    ),
    child: Center(
      child: Icon(
        Icons.person_rounded,
        color: iconColor,
        size: size * 0.55,
      ),
    ),
  );

  if (!hasImage) {
    return fallbackWidget;
  }

  Widget imageWidget;
  if (cleanUrl.startsWith('data:image')) {
    try {
      final base64Str = cleanUrl.split(',').last;
      imageWidget = Image.memory(
        base64Decode(base64Str),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallbackWidget,
      );
    } catch (_) {
      imageWidget = fallbackWidget;
    }
  } else {
    imageWidget = Image.network(
      cleanUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallbackWidget,
    );
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: imageWidget,
  );
}

