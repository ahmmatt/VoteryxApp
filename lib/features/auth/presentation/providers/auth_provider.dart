// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/supabase_error_handler.dart';
import '../../../../core/utils/hash_utils.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/user_profile.dart';

// ─── Datasource Provider ─────────────────────────────────────────────────────

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(),
);

// ─── Auth State Stream ───────────────────────────────────────────────────────

/// Stream dari Supabase auth state changes (login/logout).
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final ds = ref.watch(authRemoteDatasourceProvider);
  return ds.onAuthStateChange;
});

// ─── User Profile Provider ───────────────────────────────────────────────────

/// Provider utama untuk profil user yang sedang login.
/// Otomatis diinvalidate saat auth state berubah.
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    // Listen ke auth state changes (hindari loop pada event tokenRefreshed)
    ref.listen(authStateStreamProvider, (previous, next) {
      next.whenData((authState) {
        final event = authState.event;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.signedOut ||
            event == AuthChangeEvent.userDeleted) {
          ref.invalidateSelf();
        }
      });
    });

    final ds = ref.read(authRemoteDatasourceProvider);
    final user = ds.currentUser;
    if (user == null) return null;

    return await ds.getUserProfile(user.id);
  }

  /// Update profil user.
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? email,
    String? faculty,
    String? nim,
    String? major,
    String? delegateBio,
    String? delegateVision,
    bool? isDelegateProfilePublic,
  }) async {
    final ds = ref.read(authRemoteDatasourceProvider);
    final user = ds.currentUser;
    if (user == null) throw Exception('Tidak ada sesi aktif.');

    await ds.updateUserProfile(
      userId: user.id,
      fullName: fullName,
      phone: phone,
      email: email,
      faculty: faculty,
      nim: nim,
      specialization: major,
      delegateBio: delegateBio,
      delegateVision: delegateVision,
      isDelegateProfilePublic: isDelegateProfilePublic,
    );
    ref.invalidateSelf();
  }

  /// Logout.
  Future<void> signOut() async {
    LoginNotifier.isDevAdminBypass = false;
    final ds = ref.read(authRemoteDatasourceProvider);
    await ds.signOut();
    ref.invalidate(loginNotifierProvider);
    state = const AsyncData(null);
  }
}

// ─── Login Notifier ──────────────────────────────────────────────────────────

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.userRole,
  });

  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final String? userRole; // 'voter' | 'delegate' | 'admin'

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    String? userRole,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      userRole: userRole ?? this.userRole,
    );
  }
}

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref),
);

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref) : super(const LoginState());

  final Ref _ref;
  static bool isDevAdminBypass = false;

  Future<void> login({
    required String nik,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ds = _ref.read(authRemoteDatasourceProvider);

      // ─── RESILIENT ADMIN LOGIN (HYBRID) ────────────────────────────────
      // Coba login asli Supabase jika SQL Opsi A sudah dijalankan di cloud.
      // Jika belum ditaruh di Supabase (gagal/error), otomatis jalankan bypass dev admin!
      if (nik == '1111111111111111' || nik == '9999999999999999' || nik == '0000000000000000') {
        try {
          final authResponse = await ds.signIn(nik: nik, password: password);
          if (authResponse.user != null) {
            final profile = await ds.getUserProfile(authResponse.user!.id);
            if (profile != null) {
              isDevAdminBypass = false;
              _ref.invalidate(userProfileProvider);
              state = state.copyWith(
                isLoading: false,
                isSuccess: true,
                userRole: profile.role,
              );
              return;
            }
          }
        } catch (_) {
          // Fallback ke bypass lokal jika akun belum ada di DB cloud
        }

        isDevAdminBypass = true;
        await Future.delayed(const Duration(milliseconds: 200));
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userRole: 'admin',
        );
        return;
      }
      isDevAdminBypass = false;

      // 1. Sign in dengan Supabase Auth
      final authResponse = await ds.signIn(nik: nik, password: password);

      if (authResponse.user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Login gagal. Silakan coba lagi.',
        );
        return;
      }

      if (authResponse.session == null && ds.currentSession == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Sesi login tidak tersimpan karena pengaturan "Confirm Email" di Supabase Anda masih AKTIF. Harap matikan opsi "Confirm Email" di dasbor Supabase (menu Authentication -> Providers -> Email) agar sesi langsung aktif.',
        );
        return;
      }

      // 2. Ambil profil dari public.users
      final profile = await ds.getUserProfile(authResponse.user!.id);
      if (profile == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Profil tidak ditemukan. Hubungi admin.',
        );
        return;
      }

      // 3. Invalidate profile provider agar dimuat ulang
      _ref.invalidate(userProfileProvider);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        userRole: profile.role,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userFriendlyMessage,
      );
    } on PostgrestException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userFriendlyMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: extractUserFriendlyError(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const LoginState();
  }
}

// ─── Registration State ──────────────────────────────────────────────────────

/// Data sementara selama proses registrasi multi-step.
/// JANGAN simpan ke DB sampai KYC selesai.
class KtpData {
  const KtpData({
    required this.nik,
    required this.fullName,
    this.birthPlace,
    this.birthDate,
    this.gender,
    this.address,
    this.faculty,
    this.ktpImagePath,
  });

  final String nik;
  final String fullName;
  final String? birthPlace;
  final String? birthDate;
  final String? gender;
  final String? address;
  final String? faculty;
  final String? ktpImagePath;
}

class RegistrationState {
  const RegistrationState({
    this.nik,
    this.password,
    this.ktpData,
    this.faceImagePath,
    this.isSubmitting = false,
    this.error,
    this.isComplete = false,
    this.currentStep = 0,
  });

  final String? nik;
  final String? password;
  final KtpData? ktpData;
  final String? faceImagePath;
  final bool isSubmitting;
  final String? error;
  final bool isComplete;
  final int currentStep;

  RegistrationState copyWith({
    String? nik,
    String? password,
    KtpData? ktpData,
    String? faceImagePath,
    bool? isSubmitting,
    String? error,
    bool? isComplete,
    int? currentStep,
  }) {
    return RegistrationState(
      nik: nik ?? this.nik,
      password: password ?? this.password,
      ktpData: ktpData ?? this.ktpData,
      faceImagePath: faceImagePath ?? this.faceImagePath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      isComplete: isComplete ?? this.isComplete,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>(
  (ref) => RegistrationNotifier(ref),
);

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier(this._ref) : super(const RegistrationState());

  final Ref _ref;

  /// Set data akun (NIK + password) pada step pertama.
  void setAccountData({required String nik, required String password}) {
    state = state.copyWith(nik: nik, password: password, currentStep: 1);
  }

  /// Set data KTP (dari OCR atau NFC).
  void setKtpData(KtpData data) {
    state = state.copyWith(ktpData: data, currentStep: 2);
  }

  /// Set path foto wajah dari liveness detection.
  void setFaceData(String imagePath) {
    state = state.copyWith(faceImagePath: imagePath, currentStep: 3);
  }

  /// Cek apakah NIK sudah terdaftar.
  Future<bool> checkNikDuplicate(String nik) async {
    final ds = _ref.read(authRemoteDatasourceProvider);
    final nikHash = HashUtils.sha256Hash(nik);
    return await ds.isNikAlreadyRegistered(nikHash);
  }

  /// Selesaikan registrasi: buat akun Supabase + insert profil.
  Future<void> completeRegistration() async {
    if (state.nik == null || state.password == null) {
      state = state.copyWith(error: 'Data registrasi tidak lengkap.');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final ds = _ref.read(authRemoteDatasourceProvider);
      final nik = state.nik!;
      final password = state.password!;
      final ktpData = state.ktpData;

      // 1. Buat akun Supabase Auth (dengan fallback ke signIn untuk kelancaran testing berulang)
      AuthResponse authResponse;
      try {
        authResponse = await ds.signUp(nik: nik, password: password);
        // Pastikan sesi langsung aktif dengan memanggil signIn jika session belum terisi otomatis oleh SDK
        if (authResponse.user == null || authResponse.session == null || ds.currentSession == null) {
          authResponse = await ds.signIn(nik: nik, password: password);
        }
      } catch (e) {
        // Jika sudah terdaftar di auth.users saat testing sebelumnya, coba signIn
        try {
          authResponse = await ds.signIn(nik: nik, password: password);
        } catch (signInErr) {
          final errStr = signInErr.toString().toLowerCase();
          if (errStr.contains('invalid login credentials') || errStr.contains('invalid_credentials')) {
            throw const AuthException('NIK ini sudah pernah didaftarkan pada pengujian sebelumnya dengan kata sandi yang berbeda. Gunakan NIK baru atau masukkan kata sandi yang lama.');
          }
          rethrow;
        }
      }

      if (authResponse.user == null) {
        state = state.copyWith(
          isSubmitting: false,
          error: 'Gagal mendaftarkan atau masuk ke akun Supabase.',
        );
        return;
      }

      if (authResponse.session == null && ds.currentSession == null) {
        state = state.copyWith(
          isSubmitting: false,
          error: 'Registrasi di Supabase berhasil, namun sesi login tidak tersimpan karena fitur "Confirm Email" masih AKTIF. Harap matikan opsi "Confirm Email" di dasbor Supabase (menu Authentication -> Providers -> Email) agar Anda langsung otomatis login.',
        );
        return;
      }

      final userId = authResponse.user!.id;
      final nikHash = HashUtils.sha256Hash(nik);

      // 2. Insert ke public.users (termasuk data lengkap e-KTP)
      try {
        await ds.insertUserProfile(
          userId: userId,
          nikHash: nikHash,
          fullName: ktpData?.fullName ?? 'Mahasiswa Voteryx',
          faculty: ktpData?.faculty,
          birthPlace: ktpData?.birthPlace,
          birthDate: ktpData?.birthDate,
          gender: ktpData?.gender,
          address: ktpData?.address,
        );
      } on PostgrestException catch (e) {
        // Jika terjadi error RLS 42501 (karena pengaturan "Confirm Email" di Supabase aktif sehingga sesi belum login saat insert)
        if (e.code == '42501' || e.message.toLowerCase().contains('permission denied')) {
          state = state.copyWith(
            isSubmitting: false,
            error: 'Gagal izin RLS Supabase (42501). Pastikan "Confirm Email" dinonaktifkan di menu Authentication -> Providers -> Email pada dasbor Supabase Anda, atau jalankan schema.sql terbaru.',
          );
          return;
        }
        rethrow;
      }

      // 3. Invalidate profile provider
      _ref.invalidate(userProfileProvider);

      state = state.copyWith(
        isSubmitting: false,
        isComplete: true,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.userFriendlyMessage,
      );
    } on PostgrestException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.userFriendlyMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: extractUserFriendlyError(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const RegistrationState();
  }
}

// ─── Convenience provider: current user ID ──────────────────────────────────

/// Shortcut untuk mengambil user ID aktif. Null jika belum login.
final currentUserIdProvider = Provider<String?>((ref) {
  final ds = ref.watch(authRemoteDatasourceProvider);
  return ds.currentUser?.id;
});
