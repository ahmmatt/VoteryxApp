// lib/features/auth/domain/entities/user_profile.dart

/// Entity utama yang merepresentasikan profil user di Voteryx.
/// Data ini diambil dari tabel `public.users` di Supabase.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.nikHash,
    required this.fullName,
    this.faculty,
    this.major,
    this.nim,
    this.phone,
    this.email,
    required this.role,
    required this.kycStatus,
    required this.voteWeight,
    this.isDelegateProfilePublic = false,
    this.delegateBio,
    this.delegateVision,
    this.trustScore = 0.0,
    this.createdAt,
  });

  /// UUID dari Supabase Auth (`auth.users.id`).
  final String id;

  /// SHA-256 hash dari NIK (tidak pernah disimpan plain text).
  final String nikHash;

  /// Nama lengkap dari data KTP.
  final String fullName;

  /// Fakultas dari data KTP.
  final String? faculty;

  /// Jurusan / Spesialisasi.
  final String? major;

  /// NIM Mahasiswa (jika ada).
  final String? nim;

  /// Nomor telepon (bisa diupdate user).
  final String? phone;

  /// Email (bisa diupdate user).
  final String? email;

  /// Role: `'voter'` | `'delegate'` | `'admin'`
  final String role;

  /// Status KYC: `'pending'` | `'verified'` | `'rejected'`
  final String kycStatus;

  /// Bobot suara. Default 1, bisa bertambah dari mandat delegasi.
  final int voteWeight;

  /// Apakah profil delegate-nya publik (visible di hub delegasi).
  final bool isDelegateProfilePublic;

  /// Bio singkat sebagai delegate.
  final String? delegateBio;

  /// Visi sebagai delegate.
  final String? delegateVision;

  /// Trust score dari komunitas (0.0 - 5.0).
  final double trustScore;

  /// Waktu akun dibuat.
  final DateTime? createdAt;

  /// Apakah user ini sudah terverifikasi KYC.
  bool get isVerified => kycStatus == 'verified';

  /// Apakah user ini adalah delegate aktif.
  bool get isDelegate => role == 'delegate' || isDelegateProfilePublic;

  /// Apakah user ini adalah admin.
  bool get isAdmin => role == 'admin';

  UserProfile copyWith({
    String? fullName,
    String? faculty,
    String? major,
    String? nim,
    String? phone,
    String? email,
    String? role,
    String? kycStatus,
    int? voteWeight,
    bool? isDelegateProfilePublic,
    String? delegateBio,
    String? delegateVision,
    double? trustScore,
  }) {
    return UserProfile(
      id: id,
      nikHash: nikHash,
      fullName: fullName ?? this.fullName,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      nim: nim ?? this.nim,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      kycStatus: kycStatus ?? this.kycStatus,
      voteWeight: voteWeight ?? this.voteWeight,
      isDelegateProfilePublic: isDelegateProfilePublic ?? this.isDelegateProfilePublic,
      delegateBio: delegateBio ?? this.delegateBio,
      delegateVision: delegateVision ?? this.delegateVision,
      trustScore: trustScore ?? this.trustScore,
      createdAt: createdAt,
    );
  }
}
