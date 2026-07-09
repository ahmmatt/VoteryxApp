import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';

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
      final response = await SupabaseConfig.client
          .from('candidates')
          .select('*, elections(title)')
          .order('created_at', ascending: false);

      final list = (response as List).cast<Map<String, dynamic>>();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateVerificationStatus(
      String candidateId, bool isVerified) async {
    try {
      await SupabaseConfig.client
          .from('candidates')
          .update({'is_verified': isVerified}).eq('id', candidateId);
      await fetchCandidates();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Helper konsisten untuk mengambil URL foto kandidat dari database (`photo_url`).
/// Jika tidak ada atau tidak valid di database, mengembalikan null sehingga UI menampilkan icon default.
String? getCandidateAvatarUrl(Map<String, dynamic> c) {
  final photo = c['photo_url']?.toString().trim();
  if (photo != null && photo.isNotEmpty && photo != 'null' && photo.startsWith('http')) {
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
  final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty && imageUrl != 'null' && imageUrl.startsWith('http');
  if (!hasImage) {
    return Container(
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
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.network(
      imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
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
      ),
    ),
  );
}

