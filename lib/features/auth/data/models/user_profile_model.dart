// lib/features/auth/data/models/user_profile_model.dart
import '../../domain/entities/user_profile.dart';

/// Model data untuk parsing response Supabase ke UserProfile entity.
/// Menangani konversi JSON dari tabel `public.users`.
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.nikHash,
    required super.fullName,
    super.faculty,
    super.major,
    super.nim,
    super.phone,
    super.email,
    required super.role,
    required super.kycStatus,
    required super.voteWeight,
    super.isDelegateProfilePublic,
    super.delegateBio,
    super.delegateVision,
    super.trustScore,
    super.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      nikHash: json['nik_hash'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Pengguna Voteryx',
      faculty: json['faculty'] as String?,
      major: (json['major'] ?? json['specialization']) as String?,
      nim: json['nim'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'voter',
      kycStatus: json['kyc_status'] as String? ?? 'pending',
      voteWeight: (json['vote_weight'] as num?)?.toInt() ?? 1,
      isDelegateProfilePublic: json['is_delegate_profile_public'] as bool? ?? false,
      delegateBio: json['delegate_bio'] as String?,
      delegateVision: json['delegate_vision'] as String?,
      trustScore: (json['trust_score'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toUpdateJson({
    String? fullName,
    String? faculty,
    String? major,
    String? nim,
    String? phone,
    String? email,
    bool? isDelegateProfilePublic,
    String? delegateBio,
    String? delegateVision,
  }) {
    return {
      if (fullName != null) 'full_name': fullName,
      if (faculty != null) 'faculty': faculty,
      if (major != null) 'major': major,
      if (nim != null) 'nim': nim,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (isDelegateProfilePublic != null) 'is_delegate_profile_public': isDelegateProfilePublic,
      if (delegateBio != null) 'delegate_bio': delegateBio,
      if (delegateVision != null) 'delegate_vision': delegateVision,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
