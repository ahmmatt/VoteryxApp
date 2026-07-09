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
    super.avatarUrl,
    required super.role,
    required super.kycStatus,
    required super.voteWeight,
    super.isDelegateProfilePublic,
    super.delegateBio,
    super.delegateVision,
    super.delegateSkills,
    super.delegateTrackRecords,
    super.trustScore,
    super.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse delegate_skills: JSON array of string
    List<String>? skills;
    final rawSkills = json['delegate_skills'];
    if (rawSkills is List) {
      skills = rawSkills.map((e) => e.toString()).toList();
    }

    // Parse delegate_track_records: JSON array of map
    List<Map<String, dynamic>>? trackRecords;
    final rawTrack = json['delegate_track_records'];
    if (rawTrack is List) {
      trackRecords = rawTrack
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return UserProfileModel(
      id: json['id'] as String? ?? '',
      nikHash: json['nik_hash'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Pengguna Voteryx',
      faculty: json['faculty'] as String?,
      major: (json['major'] ?? json['specialization']) as String?,
      nim: json['nim'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatarUrl: (json['avatar_url'] ?? json['photo_url']) as String?,
      role: json['role'] as String? ?? 'voter',
      kycStatus: json['kyc_status'] as String? ?? 'pending',
      voteWeight: (json['vote_weight'] as num?)?.toInt() ?? 1,
      isDelegateProfilePublic: json['is_delegate_profile_public'] as bool? ?? false,
      delegateBio: json['delegate_bio'] as String?,
      delegateVision: json['delegate_vision'] as String?,
      delegateSkills: skills,
      delegateTrackRecords: trackRecords,
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
    String? avatarUrl,
    bool? isDelegateProfilePublic,
    String? delegateBio,
    String? delegateVision,
    List<String>? delegateSkills,
    List<Map<String, dynamic>>? delegateTrackRecords,
  }) {
    return {
      if (fullName != null) 'full_name': fullName,
      if (faculty != null) 'faculty': faculty,
      if (major != null) 'major': major,
      if (nim != null) 'nim': nim,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (isDelegateProfilePublic != null)
        'is_delegate_profile_public': isDelegateProfilePublic,
      if (delegateBio != null) 'delegate_bio': delegateBio,
      if (delegateVision != null) 'delegate_vision': delegateVision,
      if (delegateSkills != null) 'delegate_skills': delegateSkills,
      if (delegateTrackRecords != null)
        'delegate_track_records': delegateTrackRecords,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
