// lib/features/admin/election_management/presentation/providers/admin_proposal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/user/election_proposal/domain/entities/election_proposal.dart';

// ─── Model untuk admin: proposal + kandidat + info pengusul ───────────────────

class AdminProposalItem {
  const AdminProposalItem({
    required this.proposal,
    required this.candidates,
    required this.proposerName,
  });

  final ElectionProposal proposal;
  final List<ProposalCandidate> candidates;
  final String proposerName;
}

// ─── Filter status provider ───────────────────────────────────────────────────

final adminProposalFilterProvider = StateProvider<String>((ref) => 'all');
// 'all' | 'pending' | 'approved' | 'rejected'

// ─── All Proposals Provider (untuk admin) ────────────────────────────────────

final adminAllProposalsProvider =
    FutureProvider.autoDispose<List<AdminProposalItem>>((ref) async {
  final filter = ref.watch(adminProposalFilterProvider);
  final client = SupabaseConfig.client;

  // Query proposals + join ke proposer (users) — filter sebelum order
  final selectBuilder = client
      .from('election_proposals')
      .select(
        'id, proposer_id, title, election_type, organization, purpose, '
        'proposed_start_date, proposed_end_date, estimated_voters, status, '
        'admin_note, created_at, users!proposer_id(full_name)',
      );

  final List proposalRows;
  if (filter != 'all') {
    proposalRows = await selectBuilder
        .eq('status', filter)
        .order('created_at', ascending: false);
  } else {
    proposalRows = await selectBuilder
        .order('created_at', ascending: false);
  }

  final List<AdminProposalItem> results = [];

  for (final row in proposalRows) {
    // Parse proposal
    final proposerInfo = row['users'] as Map<String, dynamic>?;
    final proposerName = proposerInfo?['full_name'] as String? ?? 'Tidak Diketahui';

    final proposal = ElectionProposal(
      id: row['id'] as String,
      proposerId: row['proposer_id'] as String,
      title: row['title'] as String? ?? '',
      electionType: row['election_type'] as String? ?? 'BEM',
      status: row['status'] as String? ?? 'pending',
      organization: row['organization'] as String?,
      purpose: row['purpose'] as String?,
      proposedStartDate: row['proposed_start_date'] != null
          ? DateTime.tryParse(row['proposed_start_date'] as String)
          : null,
      proposedEndDate: row['proposed_end_date'] != null
          ? DateTime.tryParse(row['proposed_end_date'] as String)
          : null,
      estimatedVoters: (row['estimated_voters'] as num?)?.toInt(),
      adminNote: row['admin_note'] as String?,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'] as String)
          : null,
      proposerName: proposerName,
    );

    // Query kandidat untuk proposal ini
    List<ProposalCandidate> candidates = [];
    try {
      final candidateRows = await client
          .from('proposal_candidates')
          .select('*, users(faculty, avatar_url)')
          .eq('proposal_id', proposal.id);

      candidates = (candidateRows as List).map<ProposalCandidate>((c) {
        final userInfo = c['users'] as Map<String, dynamic>?;
        return ProposalCandidate(
          proposalCandidateId: c['id'] as String?,
          userId: c['user_id'] as String? ?? '',
          fullName: c['full_name'] as String? ?? '',
          nikOrNim: c['nik_or_nim'] as String?,
          avatarUrl: c['photo_url'] as String? ?? userInfo?['avatar_url'] as String?,
          faculty: userInfo?['faculty'] as String?,
          docsCompleted: c['docs_completed'] as bool? ?? false,
          isVerified: c['is_verified'] as bool? ?? false,
        );
      }).toList();
    } catch (e, st) {
      print('Error fetching candidates for proposal ${proposal.id}: $e\n$st');
    }

    results.add(AdminProposalItem(
      proposal: proposal,
      candidates: candidates,
      proposerName: proposerName,
    ));
  }

  return results;
});

// ─── Update Proposal Status (Approve/Reject) ─────────────────────────────────

class AdminProposalActionNotifier extends StateNotifier<AsyncValue<void>> {
  AdminProposalActionNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> updateStatus(
    String proposalId,
    String newStatus, {
    String? adminNote,
  }) async {
    state = const AsyncValue.loading();
    try {
      await SupabaseConfig.client.from('election_proposals').update({
        'status': newStatus,
        if (adminNote != null) 'admin_note': adminNote,
      }).eq('id', proposalId);

      // Kirim notifikasi ke pengusul
      final row = await SupabaseConfig.client
          .from('election_proposals')
          .select('proposer_id, title')
          .eq('id', proposalId)
          .single();
      final proposerId = row['proposer_id'] as String;
      final title = row['title'] as String? ?? 'Usulan';

      await SupabaseConfig.client.from('user_notifications').insert({
        'user_id': proposerId,
        'title': newStatus == 'approved'
            ? 'Usulan Disetujui: $title'
            : 'Usulan Ditolak: $title',
        'message': newStatus == 'approved'
            ? (adminNote?.isNotEmpty == true
                ? 'Catatan Admin: $adminNote'
                : 'Selamat! Usulan pemilihanmu telah disetujui oleh admin.')
            : (adminNote?.isNotEmpty == true
                ? 'Alasan penolakan: $adminNote'
                : 'Mohon maaf, usulan pemilihanmu belum dapat dilanjutkan.'),
        'type': newStatus == 'approved' ? 'proposal_approved' : 'proposal_rejected',
        'is_read': false,
        'is_dismissed': false,
        'reference_id': proposalId,
      });

      _ref.invalidate(adminAllProposalsProvider);
      state = const AsyncValue.data(null);
    } on PostgrestException catch (e) {
      state = AsyncValue.error(e.message, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> publishElectionToLive({
    required AdminProposalItem item,
    required String facultyFilter,
    required String majorFilter,
    required List<String> specificUsers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final client = SupabaseConfig.client;
      final proposal = item.proposal;

      // 1. Insert ke tabel elections
      final electionInsertRes = await client.from('elections').insert({
        'title': proposal.title,
        'status': 'live',
        'start_date': proposal.proposedStartDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'end_date': proposal.proposedEndDate?.toIso8601String() ?? DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'description': proposal.purpose,
        'organization': proposal.organization,
        'election_type': proposal.electionType,
        'estimated_voters': proposal.estimatedVoters,
        'dpt_config': {
          'faculty': facultyFilter,
          'major': majorFilter,
          'specific_users': specificUsers,
        },
      }).select('id').single();

      final newElectionId = electionInsertRes['id'] as String;

      // 2. Insert ke tabel candidates (hanya yang is_verified = true)
      int candidateNum = 1;
      for (final c in item.candidates) {
        if (c.isVerified && c.proposalCandidateId != null) {
            // Ambil data lengkap dari proposal_candidates termasuk avatar user sebagai fallback
            final pcRow = await client
                .from('proposal_candidates')
                .select('visi, misi, track_records, programs, photo_url, user_id, users(avatar_url)')
                .eq('id', c.proposalCandidateId!)
                .maybeSingle();

            // Gunakan photo_url kandidat, fallback ke avatar_url user jika kosong
            String? candidatePhoto = pcRow?['photo_url'] as String?;
            if (candidatePhoto == null || candidatePhoto.isEmpty) {
              final userInfo = pcRow?['users'] as Map<String, dynamic>?;
              candidatePhoto = userInfo?['avatar_url'] as String?;
            }

            await client.from('candidates').insert({
                'election_id': newElectionId,
                'full_name': c.fullName,
                'nim': c.nikOrNim,
                'faculty': c.faculty,
                'candidate_number': candidateNum,
                'is_verified': true,
                'visi': pcRow?['visi'],
                'misi': pcRow?['misi'],
                'track_records': pcRow?['track_records'] ?? [],
                'programs': pcRow?['programs'] ?? [],
                'photo_url': candidatePhoto,
            });
            candidateNum++;
        }
      }

      // 3. Update status proposal menjadi published
      await client.from('election_proposals').update({
        'status': 'published',
      }).eq('id', proposal.id);

      _ref.invalidate(adminAllProposalsProvider);
      state = const AsyncValue.data(null);
      return true;
    } on PostgrestException catch (e) {
      state = AsyncValue.error(e.message, StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }
}

final adminProposalActionProvider =
    StateNotifierProvider.autoDispose<AdminProposalActionNotifier, AsyncValue<void>>(
  (ref) => AdminProposalActionNotifier(ref),
);
