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
        .inFilter('status', ['live', 'scheduled'])
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

    // Coba join dengan users untuk mendapatkan avatar_url sebagai fallback
    List<dynamic> candidatesData;
    try {
      candidatesData = await _client
          .from('candidates')
          .select('*, users(avatar_url)')
          .eq('election_id', electionId)
          .order('candidate_number', ascending: true);
    } catch (_) {
      candidatesData = await _client
          .from('candidates')
          .select('*')
          .eq('election_id', electionId)
          .order('candidate_number', ascending: true);
    }

    // Ambil data suara real dari tabel votes
    int totalRealVotes = 0;
    Map<String, int> candVotes = {};
    try {
      final votesResp = await _client
          .from('votes')
          .select('candidate_id, encrypted_choice, vote_weight')
          .eq('election_id', electionId);
          
      for (var v in (votesResp as List)) {
        final weight = (v['vote_weight'] as num?)?.toInt() ?? 1;
        totalRealVotes += weight;
        final cId = (v['candidate_id'] ?? v['encrypted_choice'])?.toString() ?? '';
        if (cId.isNotEmpty) {
          candVotes[cId] = (candVotes[cId] ?? 0) + weight;
        }
      }
    } catch (_) {}

    int candVoteSum = 0;
    // Untuk setiap kandidat yang tidak punya photo_url, coba ambil avatar dari users
    final resolvedCandidates = <Map<String, dynamic>>[];
    for (final c in candidatesData as List) {
      final cMap = Map<String, dynamic>.from(c as Map);
      
      // Update vote_count dengan real votes
      final cId = cMap['id']?.toString() ?? '';
      final dbCount = (cMap['vote_count'] as num?)?.toInt() ?? 0;
      final realCount = candVotes[cId] ?? 0;
      cMap['vote_count'] = realCount > dbCount ? realCount : dbCount;
      
      candVoteSum += (cMap['vote_count'] as num?)?.toInt() ?? 0;

      final hasPhoto = (cMap['photo_url'] as String?)?.isNotEmpty ?? false;
      final hasAvatarFromJoin = (cMap['users'] as Map<String, dynamic>?)?['avatar_url'] != null;
      if (!hasPhoto && !hasAvatarFromJoin) {
        final userId = cMap['user_id'] as String?;
        if (userId != null) {
          try {
            final userRow = await _client
                .from('users')
                .select('avatar_url')
                .eq('id', userId)
                .maybeSingle();
            if (userRow != null && userRow['avatar_url'] != null) {
              cMap['users'] = {'avatar_url': userRow['avatar_url']};
            }
          } catch (_) {}
        }
      }
      resolvedCandidates.add(cMap);
    }

    int finalVoteCount = totalRealVotes > candVoteSum ? totalRealVotes : candVoteSum;
    
    // Perbarui participation_rate dan pastikan estimated_voters valid berdasarkan jumlah user terdaftar
    int totalUsers = 0;
    try {
      totalUsers = await _client.from('users').count(CountOption.exact);
    } catch (_) {}

    int estimatedVoters = totalUsers > 0 ? totalUsers : ((electionData['estimated_voters'] as num?)?.toInt() ?? 100);
    if (estimatedVoters <= 0) estimatedVoters = 100;
    electionData['estimated_voters'] = estimatedVoters;
    electionData['participation_rate'] = finalVoteCount / estimatedVoters;

    final election = ElectionModel.fromJson({
      ...electionData,
      'candidates': resolvedCandidates,
      'votes': {'count': finalVoteCount},
    });

    final candidates = resolvedCandidates
        .map((c) => CandidateModel.fromJson(c))
        .toList();

    return {'election': election, 'candidates': candidates};
  }

  // ─── Candidates ───────────────────────────────────────────────────────────

  /// Ambil detail satu kandidat (dengan fallback foto dari users).
  Future<Candidate?> getCandidateDetail(String candidateId) async {
    Map<String, dynamic>? response;
    try {
      response = await _client
          .from('candidates')
          .select('*, users(avatar_url)')
          .eq('id', candidateId)
          .maybeSingle();
    } catch (_) {
      response = await _client
          .from('candidates')
          .select('*')
          .eq('id', candidateId)
          .maybeSingle();
    }

    if (response == null) return null;

    // Jika photo_url kosong dan ada user_id, coba ambil avatar_url dari users
    final hasPhoto = (response['photo_url'] as String?)?.isNotEmpty ?? false;
    final hasAvatarFromJoin = (response['users'] as Map<String, dynamic>?)?['avatar_url'] != null;
    if (!hasPhoto && !hasAvatarFromJoin) {
      final userId = response['user_id'] as String?;
      if (userId != null) {
        try {
          final userRow = await _client
              .from('users')
              .select('avatar_url')
              .eq('id', userId)
              .maybeSingle();
          if (userRow != null && userRow['avatar_url'] != null) {
            response = Map<String, dynamic>.from(response!)
              ..['users'] = {'avatar_url': userRow['avatar_url']};
          }
        } catch (_) {}
      }
    }

    // Ambil data suara real dari tabel votes
    final electionId = response!['election_id'] as String?;
    if (electionId != null) {
      try {
        final votesResp = await _client
            .from('votes')
            .select('candidate_id, encrypted_choice, vote_weight')
            .eq('election_id', electionId);
        int realVotes = 0;
        for (var v in (votesResp as List)) {
          final cId = (v['candidate_id'] ?? v['encrypted_choice'])?.toString() ?? '';
          if (cId == candidateId) {
            realVotes += (v['vote_weight'] as num?)?.toInt() ?? 1;
          }
        }
        final dbVotes = (response!['vote_count'] as num?)?.toInt() ?? 0;
        response!['vote_count'] = realVotes > dbVotes ? realVotes : dbVotes;
      } catch (e) {
        print('Error fetching candidate votes: $e');
      }
    }

    return CandidateModel.fromJson(response!);
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

  /// Ambil semua election_id yang sudah didelegasikan user.
  Future<Set<String>> getUserDelegatedElectionIds(String userId) async {
    final response = await _client
        .from('delegations')
        .select('election_id')
        .eq('delegator_id', userId)
        .eq('status', 'active');

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

  /// Ambil daftar election_id di mana user memiliki mandat sebagai delegate.
  Future<List<String>> getMandateElectionIds(String userId) async {
    final response = await _client
        .from('delegations')
        .select('election_id')
        .eq('delegate_id', userId)
        .eq('status', 'active');
    
    return (response as List)
        .map((e) => e['election_id'] as String)
        .toSet()
        .toList();
  }

  /// Ambil riwayat/info delegasi user pada pemilihan tertentu.
  Future<Map<String, dynamic>?> getDelegationInfo(String electionId, String userId) async {
    final response = await _client
        .from('delegations')
        .select('id, delegate_id, users!delegations_delegate_id_fkey(full_name, avatar_url)')
        .eq('election_id', electionId)
        .eq('delegator_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    if (response == null) return null;
    
    final delegateUser = response['users'] as Map<String, dynamic>?;
    return {
      'delegation_id': response['id'],
      'delegate_id': response['delegate_id'],
      'delegate_name': delegateUser?['full_name'] ?? 'Unknown Delegate',
      'delegate_photo_url': delegateUser?['avatar_url'] ?? delegateUser?['photo_url'],
    };
  }
}
