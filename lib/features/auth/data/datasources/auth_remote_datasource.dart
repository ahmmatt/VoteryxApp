// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/user_profile_model.dart';

/// Datasource untuk semua operasi autentikasi dan profil user via Supabase.
class AuthRemoteDatasource {
  SupabaseClient get _client => SupabaseConfig.client;

  // ─── Auth Operations ─────────────────────────────────────────────────────

  /// Login dengan NIK (dikonversi ke email fiktif) + password.
  Future<AuthResponse> signIn({
    required String nik,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: '${nik.trim()}@voteryx.app',
      password: password,
    );
  }

  /// Registrasi akun baru.
  Future<AuthResponse> signUp({
    required String nik,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: '${nik.trim()}@voteryx.app',
      password: password,
    );
  }

  /// Logout dari sesi aktif.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ─── User Profile Operations ──────────────────────────────────────────────

  /// Ambil profil user dari tabel `public.users`.
  Future<UserProfileModel?> getUserProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfileModel.fromJson(response);
  }

  /// Insert profil user baru ke `public.users` setelah registrasi.
  Future<void> insertUserProfile({
    required String userId,
    required String nikHash,
    required String fullName,
    String? faculty,
    String? birthPlace,
    String? birthDate,
    String? gender,
    String? address,
    String? avatarUrl,
  }) async {
    final baseData = {
      'id': userId,
      'nik_hash': nikHash,
      'full_name': fullName,
      'faculty': faculty ?? '',
      'kyc_status': 'verified',
      'role': 'voter',
      'vote_weight': 1,
      'is_delegate_profile_public': false,
      if (avatarUrl != null && avatarUrl.trim().isNotEmpty) 'avatar_url': avatarUrl,
    };

    final fullData = {
      ...baseData,
      'birth_place': birthPlace ?? '',
      'birth_date': birthDate ?? '',
      'gender': gender ?? '',
      'address': address ?? '',
    };

    try {
      await _client.from('users').upsert(fullData);
    } on PostgrestException catch (e) {
      // Jika kolom birth_place/birth_date/gender/address belum ditambahkan di Supabase SQL Cloud (PGRST204 / 42703),
      // otomatis fallback simpan ke kolom standar agar proses registrasi tidak gagal
      if (e.code == 'PGRST204' || e.code == '42703' || e.message.toLowerCase().contains('column')) {
        await _client.from('users').upsert(baseData);
      } else {
        rethrow;
      }
    }
  }

  /// Unggah file foto profil ke bucket Supabase Storage (`avatars`).
  Future<String?> uploadAvatar(String userId, Uint8List bytes, String fileExtension) async {
    try {
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      await _client.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      final publicUrl = _client.storage.from('avatars').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  /// Update field profil user di tabel `users`.
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? email,
    String? faculty,
    String? nim,
    String? specialization,
    String? avatarUrl,
    String? delegateBio,
    String? delegateVision,
    List<String>? delegateSkills,
    List<Map<String, dynamic>>? delegateTrackRecords,
    bool? isDelegateProfilePublic,
  }) async {
    final data = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (faculty != null) data['faculty'] = faculty;
    if (nim != null) data['nim'] = nim;
    if (specialization != null) data['major'] = specialization;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    if (delegateBio != null) data['delegate_bio'] = delegateBio;
    if (delegateVision != null) data['delegate_vision'] = delegateVision;
    if (delegateSkills != null) data['delegate_skills'] = delegateSkills;
    if (delegateTrackRecords != null) data['delegate_track_records'] = delegateTrackRecords;
    if (isDelegateProfilePublic != null) {
      data['is_delegate_profile_public'] = isDelegateProfilePublic;
    }

    try {
      await _client.from('users').update(data).eq('id', userId);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST204' || e.code == '42703' || e.message.toLowerCase().contains('column') || e.message.toLowerCase().contains('schema cache')) {
        // Step 1: Coba hapus kolom 'nim' saja terlebih dahulu
        final step1Data = Map<String, dynamic>.from(data)..remove('nim');
        try {
          await _client.from('users').update(step1Data).eq('id', userId);
        } on PostgrestException catch (e2) {
          if (e2.code == 'PGRST204' || e2.code == '42703' || e2.message.toLowerCase().contains('column') || e2.message.toLowerCase().contains('schema cache')) {
            // Step 2: Coba hapus kolom delegate opsional baru jika masih gagal
            final step2Data = Map<String, dynamic>.from(step1Data)
              ..remove('delegate_bio')
              ..remove('delegate_vision')
              ..remove('delegate_skills')
              ..remove('delegate_track_records')
              ..remove('is_delegate_profile_public');
            try {
              await _client.from('users').update(step2Data).eq('id', userId);
            } on PostgrestException catch (e3) {
              if (e3.code == 'PGRST204' || e3.code == '42703' || e3.message.toLowerCase().contains('column') || e3.message.toLowerCase().contains('schema cache')) {
                // Step 3: Core fallback
                final coreData = <String, dynamic>{
                  'updated_at': DateTime.now().toIso8601String(),
                };
                if (fullName != null) coreData['full_name'] = fullName;
                if (faculty != null) coreData['faculty'] = faculty;
                if (specialization != null) coreData['major'] = specialization;
                await _client.from('users').update(coreData).eq('id', userId);
              } else {
                rethrow;
              }
            }
          } else {
            rethrow;
          }
        }
      } else {
        rethrow;
      }
    }
  }

  /// Cek apakah NIK sudah terdaftar (cek nik_hash duplikat).
  Future<bool> isNikAlreadyRegistered(String nikHash) async {
    final response = await _client
        .from('users')
        .select('id')
        .eq('nik_hash', nikHash)
        .maybeSingle();
    return response != null;
  }

  /// Session aktif saat ini.
  Session? get currentSession => _client.auth.currentSession;

  /// User aktif saat ini.
  User? get currentUser => _client.auth.currentUser;

  /// Stream perubahan auth state (login/logout).
  Stream<AuthState> get onAuthStateChange =>
      _client.auth.onAuthStateChange;
}
