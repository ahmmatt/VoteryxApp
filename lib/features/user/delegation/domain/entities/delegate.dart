// lib/features/user/delegation/domain/entities/delegate.dart

/// Entity untuk profil delegate dari tabel `public.users`
/// yang `is_delegate_profile_public = true`.
class Delegate {
  const Delegate({
    required this.id,
    required this.fullName,
    this.faculty,
    this.delegateBio,
    this.delegateVision,
    this.trustScore = 0.0,
    this.delegationCount = 0,
    this.photoUrl,
    this.specialization,
  });

  final String id;
  final String fullName;
  final String? faculty;
  final String? delegateBio;
  final String? delegateVision;
  final double trustScore;
  final int delegationCount;
  final String? photoUrl;
  final String? specialization;

  /// Inisial untuk avatar fallback.
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}

/// Data untuk konfirmasi delegasi.
class DelegationData {
  const DelegationData({
    required this.id,
    required this.electionId,
    required this.delegatorId,
    required this.delegateId,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String electionId;
  final String delegatorId;
  final String delegateId;
  final String status; // 'active' | 'revoked'
  final DateTime? createdAt;
}
