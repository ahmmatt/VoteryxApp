// lib/features/user/election/data/repositories/election_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/user/election/data/models/election_model.dart';
import 'package:voteryxapp/features/user/election/domain/entities/election.dart';

/// Repository untuk semua query pemilihan via Supabase.
class ElectionRepository {
  SupabaseClient get _client => SupabaseConfig.client;

  // ─── Elections ───────────────────────────────────────────────────────────

  /// Ambil semua pemilihan aktif (live + scheduled).
  Future<List<Election>> getActiveElections() async {
    final response = await _client
        .from('elections')
        .select('*, candidates(count), votes(count)')
        .filter('status', 'in', '("live","scheduled")')
        .order('start_date', ascending: true);

    return (response as List)
        .map((e) => ElectionModel.fromJson(e as Map<String, dynamic>))
        .where((e) => e.candidateCount >= 2 && e.title.isNotEmpty && e.status != 'draft')
        .toList();
  }

  /// Ambil semua pemilihan (semua status) dengan jumlah kandidat dan suara.
  Future<List<Election>> getAllElections() async {
    final response = await _client
        .from('elections')
        .select('*, candidates(count), votes(count)')
        .order('start_date', ascending: false);

    return (response as List)
        .map((e) => ElectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Ambil detail satu pemilihan beserta semua kandidatnya.
  Future<Map<String, dynamic>> getElectionWithCandidates(String electionId) async {
    // Ambil detail election
    final electionData = await _client
        .from('elections')
        .select('*')
        .eq('id', electionId)
        .single();

    // Ambil kandidat election
    final candidatesData = await _client
        .from('candidates')
        .select('*')
        .eq('election_id', electionId)
        .order('candidate_number', ascending: true);

    // Ambil vote count
    final voteCount = await _client
        .from('votes')
        .count(CountOption.exact)
        .eq('election_id', electionId);

    final election = ElectionModel.fromJson({
      ...electionData,
      'candidates': candidatesData,
      'votes': {'count': voteCount},
    });

    final candidates = (candidatesData as List)
        .map((c) => CandidateModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return {'election': election, 'candidates': candidates};
  }

  // ─── Candidates ───────────────────────────────────────────────────────────

  /// Ambil detail satu kandidat.
  Future<Candidate?> getCandidateDetail(String candidateId) async {
    final response = await _client
        .from('candidates')
        .select('*')
        .eq('id', candidateId)
        .maybeSingle();

    if (response == null) return null;
    return CandidateModel.fromJson(response);
  }

  // ─── User Participation Status ────────────────────────────────────────────

  /// Ambil semua election_id yang sudah dipilih user (langsung).
  Future<Set<String>> getUserVotedElectionIds(String userId) async {
    final response = await _client
        .from('votes')
        .select('election_id')
        .eq('voter_id', userId);

    return (response as List)
        .map((e) => e['election_id'] as String)
        .toSet();
  }

  /// Ambil semua election_id di mana user sudah berpartisipasi (vote langsung / delegasi).
  Future<Set<String>> getUserParticipatedElectionIds(String userId) async {
    final votedIds = await getUserVotedElectionIds(userId);

    final response = await _client
        .from('delegations')
        .select('election_id')
        .eq('delegator_id', userId)
        .eq('status', 'active');

    final delegatedIds = (response as List)
        .map((e) => e['election_id'] as String)
        .toSet();

    return {...votedIds, ...delegatedIds};
  }

  /// Cek apakah user sudah memilih di pemilihan tertentu.
  Future<bool> hasUserVotedInElection(
      String electionId, String userId) async {
    final response = await _client
        .from('votes')
        .select('id')
        .eq('election_id', electionId)
        .eq('voter_id', userId)
        .maybeSingle();
    return response != null;
  }

  /// Cek apakah user sudah mendelegasikan suara di pemilihan tertentu.
  Future<bool> hasUserDelegatedInElection(
      String electionId, String userId) async {
    final response = await _client
        .from('delegations')
        .select('id')
        .eq('election_id', electionId)
        .eq('delegator_id', userId)
        .eq('status', 'active')
        .maybeSingle();
    return response != null;
  }

  /// Cek apakah user punya mandat delegasi aktif (sebagai delegate).
  Future<bool> hasActiveMandate(String userId) async {
    final response = await _client
        .from('delegations')
        .select('id')
        .eq('delegate_id', userId)
        .eq('status', 'active')
        .limit(1);
    return (response as List).isNotEmpty;
  }
}
