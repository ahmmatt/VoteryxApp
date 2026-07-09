// lib/features/user/profile/presentation/providers/profile_provider.dart
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:voteryxapp/core/error/supabase_error_handler.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

// Re-export userProfileProvider from auth_provider agar mudah diakses
// dari fitur profile tanpa harus import auth langsung.
export 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart'
    show userProfileProvider, currentUserIdProvider;

// ─── Profile Update State ─────────────────────────────────────────────────────

class ProfileUpdateState {
  const ProfileUpdateState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? error;

  ProfileUpdateState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return ProfileUpdateState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

final profileUpdateProvider =
    StateNotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>(
  (ref) => ProfileUpdateNotifier(ref),
);

class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  ProfileUpdateNotifier(this._ref) : super(const ProfileUpdateState());

  final Ref _ref;

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? email,
    String? faculty,
    String? nim,
    String? major,
    String? avatarUrl,
    Uint8List? avatarBytes,
    String? delegateBio,
    String? delegateVision,
    List<String>? delegateSkills,
    List<Map<String, dynamic>>? delegateTrackRecords,
    bool? isDelegateProfilePublic,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      String? targetAvatarUrl = avatarUrl;
      if (avatarBytes != null) {
        targetAvatarUrl = await _ref.read(userProfileProvider.notifier).uploadAvatar(avatarBytes, 'jpg');
        if (targetAvatarUrl == null) {
          throw Exception('Gagal mengunggah foto profil ke bucket "avatars". Pastikan bucket sudah dibuat di Supabase Storage.');
        }
      }

      await _ref.read(userProfileProvider.notifier).updateProfile(
            fullName: fullName,
            phone: phone,
            email: email,
            faculty: faculty,
            nim: nim,
            major: major,
            avatarUrl: targetAvatarUrl,
            delegateBio: delegateBio,
            delegateVision: delegateVision,
            delegateSkills: delegateSkills,
            delegateTrackRecords: delegateTrackRecords,
            isDelegateProfilePublic: isDelegateProfilePublic,
          );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on PostgrestException catch (e) {
      state = state.copyWith(isLoading: false, error: e.userFriendlyMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: extractUserFriendlyError(e));
    }
  }

  void clearError() => state = state.copyWith(error: null);
  void reset() => state = const ProfileUpdateState();
}
