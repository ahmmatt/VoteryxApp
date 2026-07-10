// lib/features/user/election_proposal/presentation/providers/election_proposal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:voteryxapp/core/error/supabase_error_handler.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/user/election_proposal/domain/entities/election_proposal.dart';

// ─── My Proposals Provider ────────────────────────────────────────────────────

final myProposalsProvider = FutureProvider.autoDispose<List<ElectionProposal>>((ref) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return [];

  final response = await SupabaseConfig.client
      .from('election_proposals')
      .select()
      .eq('proposer_id', userId)
      .order('created_at', ascending: false);

  return (response as List).map((json) {
    return ElectionProposal(
      id: json['id'] as String? ?? '',
      proposerId: json['proposer_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      electionType: json['election_type'] as String? ?? 'BEM',
      status: json['status'] as String? ?? 'pending',
      organization: json['organization'] as String?,
      purpose: json['purpose'] as String?,
      proposedStartDate: json['proposed_start_date'] != null
          ? DateTime.tryParse(json['proposed_start_date'] as String)
          : null,
      proposedEndDate: json['proposed_end_date'] != null
          ? DateTime.tryParse(json['proposed_end_date'] as String)
          : null,
      estimatedVoters: (json['estimated_voters'] as num?)?.toInt(),
      adminNote: json['admin_note'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }).toList();
});

// ─── Candidate Search Provider ────────────────────────────────────────────────
/// Mencari user berdasarkan nama atau NIK dari tabel public.users.
final candidateSearchQueryProvider = StateProvider<String>((ref) => '');

final candidateSearchResultsProvider = FutureProvider.autoDispose<List<ProposalCandidate>>((ref) async {
  final query = ref.watch(candidateSearchQueryProvider).trim();
  if (query.length < 2) return [];

  final client = SupabaseConfig.client;

  // Cari berdasarkan nama lengkap atau NIK hash (partial match nama, exact NIK)
  final List results = await client
      .from('users')
      .select('id, full_name, faculty, avatar_url, nik_hash, nim')
      .or('full_name.ilike.%$query%,nim.ilike.%$query%')
      .limit(10);

  return results.map<ProposalCandidate>((row) {
    return ProposalCandidate(
      userId: row['id'] as String,
      fullName: row['full_name'] as String? ?? 'Tidak Dikenal',
      nikOrNim: row['nim'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      faculty: row['faculty'] as String?,
    );
  }).toList();
});

// ─── Proposal Draft Provider ──────────────────────────────────────────────────

final proposalDraftProvider =
    StateNotifierProvider<ProposalDraftNotifier, ElectionProposalDraft>(
  (ref) => ProposalDraftNotifier(),
);

class ProposalDraftNotifier extends StateNotifier<ElectionProposalDraft> {
  ProposalDraftNotifier() : super(const ElectionProposalDraft());

  void setTitle(String v) => state = state.copyWith(title: v);
  void setElectionType(String v) => state = state.copyWith(electionType: v);
  void setOrganization(String v) => state = state.copyWith(organization: v);
  void setPurpose(String v) => state = state.copyWith(purpose: v);
  void setStartDate(DateTime d) => state = state.copyWith(proposedStartDate: d);
  void setEndDate(DateTime d) => state = state.copyWith(proposedEndDate: d);
  void setEstimatedVoters(int v) => state = state.copyWith(estimatedVoters: v);

  void addCandidate(ProposalCandidate c) {
    // Hindari duplikat
    if (state.selectedCandidates.any((e) => e.userId == c.userId)) return;
    state = state.copyWith(selectedCandidates: [...state.selectedCandidates, c]);
  }

  void removeCandidate(String userId) {
    state = state.copyWith(
      selectedCandidates: state.selectedCandidates.where((e) => e.userId != userId).toList(),
    );
  }

  void reset() => state = const ElectionProposalDraft();
}

// ─── Proposal Submission Provider ────────────────────────────────────────────

class ProposalSubmitState {
  const ProposalSubmitState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? error;

  ProposalSubmitState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return ProposalSubmitState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

final proposalSubmitProvider =
    StateNotifierProvider<ProposalSubmitNotifier, ProposalSubmitState>(
  (ref) => ProposalSubmitNotifier(ref),
);

class ProposalSubmitNotifier extends StateNotifier<ProposalSubmitState> {
  ProposalSubmitNotifier(this._ref) : super(const ProposalSubmitState());

  final Ref _ref;

  Future<void> submitProposal() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      state = state.copyWith(error: 'Sesi telah berakhir. Silakan login kembali.');
      return;
    }

    final draft = _ref.read(proposalDraftProvider);
    if (!draft.isValid) {
      state = state.copyWith(error: 'Lengkapi semua field yang wajib diisi.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final client = SupabaseConfig.client;

      // 1. Insert proposal ke tabel election_proposals
      final inserted = await client.from('election_proposals').insert({
        'proposer_id': userId,
        'title': draft.title.trim(),
        'election_type': draft.electionType,
        'organization': draft.organization.trim(),
        'purpose': draft.purpose.trim(),
        'proposed_start_date': draft.proposedStartDate?.toIso8601String(),
        'proposed_end_date': draft.proposedEndDate?.toIso8601String(),
        'estimated_voters': draft.estimatedVoters,
        'status': 'pending',
      }).select().single();

      final proposalId = inserted['id'] as String;

      // 2. Insert kandidat-kandidat terpilih ke tabel proposal_candidates
      //    dan kirim notifikasi persisten ke masing-masing kandidat
      for (final candidate in draft.selectedCandidates) {
        // Insert ke proposal_candidates
        await client.from('proposal_candidates').insert({
          'proposal_id': proposalId,
          'user_id': candidate.userId,
          'full_name': candidate.fullName,
          'nik_or_nim': candidate.nikOrNim,
          'docs_completed': false,
          'notification_sent': true,
        });

        // Kirim notifikasi persisten ke kandidat
        await client.from('user_notifications').insert({
          'user_id': candidate.userId,
          'title': 'Anda Diajukan Sebagai Kandidat',
          'message': 'Anda telah diusulkan sebagai kandidat dalam pemilihan "${draft.title.trim()}". '
              'Segera lengkapi data dan berkas Anda agar dapat dilanjutkan ke tahap verifikasi. '
              'Notifikasi ini akan tetap aktif sampai semua berkas Anda lengkap.',
          'type': 'candidate_nominated',
          'is_read': false,
          'is_dismissed': false,
          'reference_id': proposalId,
        });
      }

      // 3. Reset draft & invalidate providers
      _ref.read(proposalDraftProvider.notifier).reset();
      _ref.invalidate(myProposalsProvider);

      state = state.copyWith(isLoading: false, isSuccess: true);
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

  void clearError() => state = state.copyWith(error: null);
  void reset() => state = const ProposalSubmitState();
}
