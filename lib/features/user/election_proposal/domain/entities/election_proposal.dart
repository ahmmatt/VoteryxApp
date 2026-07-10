// lib/features/user/election_proposal/domain/entities/election_proposal.dart

/// Entity satu kandidat yang diajukan dalam proposal.
class ProposalCandidate {
  const ProposalCandidate({
    required this.fullName,
    required this.userId,
    this.nikOrNim,
    this.avatarUrl,
    this.faculty,
    this.docsCompleted = false,
    this.isVerified = false,
    this.proposalCandidateId,
  });

  final String fullName;
  final String userId;   // UUID user di tabel users
  final String? proposalCandidateId; // UUID of proposal_candidates row
  final String? nikOrNim;
  final String? avatarUrl;
  final String? faculty;
  final bool docsCompleted;
  final bool isVerified;
}

/// Entity untuk usulan pemilihan dari tabel `election_proposals`.
class ElectionProposal {
  const ElectionProposal({
    required this.id,
    required this.proposerId,
    required this.title,
    required this.electionType,
    required this.status,
    this.organization,
    this.purpose,
    this.proposedStartDate,
    this.proposedEndDate,
    this.estimatedVoters,
    this.adminNote,
    this.createdAt,
    this.candidates,
    this.proposerName,
  });

  final String id;
  final String proposerId;
  final String title;
  final String electionType;

  /// Status: `'pending'` | `'under_review'` | `'approved'` | `'rejected'`
  final String status;

  final String? organization;
  final String? purpose;
  final DateTime? proposedStartDate;
  final DateTime? proposedEndDate;
  final int? estimatedVoters;
  final String? adminNote;
  final DateTime? createdAt;
  final List<ProposalCandidate>? candidates;
  final String? proposerName;

  bool get isPending => status == 'pending';
  bool get isUnderReview => status == 'under_review';
  bool get isApproved => status == 'approved';
  bool get isPublished => status == 'published';
  bool get isRejected => status == 'rejected';
}

/// Draft sementara selama mengisi form usulan.
class ElectionProposalDraft {
  const ElectionProposalDraft({
    this.title = '',
    this.electionType = 'BEM',
    this.organization = '',
    this.purpose = '',
    this.proposedStartDate,
    this.proposedEndDate,
    this.estimatedVoters,
    this.selectedCandidates = const [],
  });

  final String title;
  final String electionType;
  final String organization;
  final String purpose;
  final DateTime? proposedStartDate;
  final DateTime? proposedEndDate;
  final int? estimatedVoters;
  final List<ProposalCandidate> selectedCandidates;

  ElectionProposalDraft copyWith({
    String? title,
    String? electionType,
    String? organization,
    String? purpose,
    DateTime? proposedStartDate,
    DateTime? proposedEndDate,
    int? estimatedVoters,
    List<ProposalCandidate>? selectedCandidates,
  }) {
    return ElectionProposalDraft(
      title: title ?? this.title,
      electionType: electionType ?? this.electionType,
      organization: organization ?? this.organization,
      purpose: purpose ?? this.purpose,
      proposedStartDate: proposedStartDate ?? this.proposedStartDate,
      proposedEndDate: proposedEndDate ?? this.proposedEndDate,
      estimatedVoters: estimatedVoters ?? this.estimatedVoters,
      selectedCandidates: selectedCandidates ?? this.selectedCandidates,
    );
  }

  bool get isValid =>
      title.trim().isNotEmpty &&
      organization.trim().isNotEmpty &&
      purpose.trim().isNotEmpty;
}
