// lib/features/delegates/delegation/application/delegate_dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/profile_provider.dart';

class DelegateMandateItem {
  final String id;
  final String electionId;
  final String delegatorId;
  final String delegateId;
  final String status; // 'active' | 'pending' | 'revoked'
  final DateTime? createdAt;
  final String delegatorName;
  final String? delegatorNim;
  final String? delegatorFaculty;
  final String? delegatorMajor;
  final String? delegatorAvatarUrl;
  final int delegatorVoteWeight;
  final String? electionTitle;

  const DelegateMandateItem({
    required this.id,
    required this.electionId,
    required this.delegatorId,
    required this.delegateId,
    required this.status,
    this.createdAt,
    required this.delegatorName,
    this.delegatorNim,
    this.delegatorFaculty,
    this.delegatorMajor,
    this.delegatorAvatarUrl,
    this.delegatorVoteWeight = 1,
    this.electionTitle,
  });
}

class DelegateExecutionItem {
  final String electionId;
  final String title;
  final String dateString;
  final int totalVotes;
  final int totalMandators;
  final String status; // 'Menunggu' | 'Selesai'
  final String? accuracy;
  final DateTime? createdAt;

  const DelegateExecutionItem({
    required this.electionId,
    required this.title,
    required this.dateString,
    required this.totalVotes,
    required this.totalMandators,
    required this.status,
    this.accuracy,
    this.createdAt,
  });
}

/// Model kandidat yang tersedia pada suatu pemilihan.
class DelegateCandidateItem {
  final String id;
  final String name;
  final String? vision;
  final String? photoUrl;
  final int candidateNumber;

  const DelegateCandidateItem({
    required this.id,
    required this.name,
    this.vision,
    this.photoUrl,
    required this.candidateNumber,
  });
}

class DelegateDashboardData {
  final List<DelegateMandateItem> mandates;
  final List<DelegateExecutionItem> executionHistory;
  final int totalVotesHeld;
  final int activeElectionsCount;
  final int completedElectionsCount;
  final double trustScore;
  final double executionRate;
  final String? urgentElectionTitle;
  final String? urgentElectionId;
  final int urgentElectionHoursLeft;
  /// Konsensus = persentase suara mandator aktif dari semua delegasi yang masuk
  final double consensusPercent;
  /// Kandidat pada pemilihan yang paling urgent/aktif
  final List<DelegateCandidateItem> urgentElectionCandidates;

  const DelegateDashboardData({
    this.mandates = const [],
    this.executionHistory = const [],
    this.totalVotesHeld = 0,
    this.activeElectionsCount = 0,
    this.completedElectionsCount = 0,
    this.trustScore = 0.0,
    this.executionRate = 0.0,
    this.urgentElectionTitle,
    this.urgentElectionId,
    this.urgentElectionHoursLeft = 0,
    this.consensusPercent = 0.0,
    this.urgentElectionCandidates = const [],
  });
}

final delegateDashboardProvider = FutureProvider.autoDispose<DelegateDashboardData>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const DelegateDashboardData();

  final profile = ref.watch(userProfileProvider).valueOrNull;
  final client = SupabaseConfig.client;

  // ── 1. Ambil semua delegasi di mana user ini adalah delegate ──────
  final delegationsRes = await client
      .from('delegations')
      .select()
      .eq('delegate_id', userId)
      .order('created_at', ascending: false);

  final List<dynamic> rawDelegations = delegationsRes as List<dynamic>? ?? [];

  // ── 2. Ambil data delegator (users) ──────────────────────────────
  final delegatorIds = rawDelegations
      .map((d) => d['delegator_id'] as String)
      .toSet()
      .toList();
  Map<String, dynamic> usersMap = {};
  if (delegatorIds.isNotEmpty) {
    final usersRes = await client
        .from('users')
        .select('id, full_name, nim, faculty, major, avatar_url, vote_weight')
        .inFilter('id', delegatorIds);
    for (final u in (usersRes as List<dynamic>)) {
      usersMap[u['id'] as String] = u;
    }
  }

  // ── 3. Ambil data elections (live saja yang relevan untuk delegate) ──
  final electionsRes = await client
      .from('elections')
      .select()
      .inFilter('status', ['live', 'completed'])
      .order('created_at', ascending: false);
  final List<dynamic> rawElections = electionsRes as List<dynamic>? ?? [];
  Map<String, dynamic> electionsMap = {};
  for (final e in rawElections) {
    electionsMap[e['id'] as String] = e;
  }

  // ── 4. Ambil votes yang pernah dilakukan delegate ini ─────────────
  final votesRes = await client
      .from('votes')
      .select('election_id, vote_weight, created_at')
      .eq('voter_id', userId);
  final List<dynamic> rawVotes = votesRes as List<dynamic>? ?? [];
  final votedElectionIds = rawVotes.map((v) => v['election_id'] as String).toSet();

  // ── 5. Susun daftar Mandates ────────────────────────────────────
  final List<DelegateMandateItem> mandates = [];
  // Suara sendiri (voteWeight dari profile, minimal 1)
  int myOwnVoteWeight = profile?.voteWeight ?? 1;
  int delegatedVotesTotal = 0;

  for (final row in rawDelegations) {
    final delegatorId = row['delegator_id'] as String? ?? '';
    final electionId = row['election_id'] as String? ?? '';
    final status = (row['status'] as String? ?? 'active').toLowerCase();
    final delegatorUser = usersMap[delegatorId] as Map<String, dynamic>?;
    final electionObj = electionsMap[electionId] as Map<String, dynamic>?;

    final voteWeight = (delegatorUser?['vote_weight'] as num?)?.toInt() ?? 1;
    if (status == 'active') {
      delegatedVotesTotal += voteWeight;
    }

    mandates.add(DelegateMandateItem(
      id: row['id'] as String? ?? '',
      electionId: electionId,
      delegatorId: delegatorId,
      delegateId: userId,
      status: status,
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'] as String)
          : null,
      delegatorName: delegatorUser?['full_name'] as String? ?? 'Mahasiswa',
      delegatorNim: delegatorUser?['nim'] as String?,
      delegatorFaculty: delegatorUser?['faculty'] as String?,
      delegatorMajor: delegatorUser?['major'] as String?,
      delegatorAvatarUrl: delegatorUser?['avatar_url'] as String?,
      delegatorVoteWeight: voteWeight,
      electionTitle: electionObj?['title'] as String?,
    ));
  }

  // Total suara = suara sendiri + delegasi aktif
  final int calculatedVotesHeld = myOwnVoteWeight + delegatedVotesTotal;

  // ── 6. Hitung konsensus (persen mandator aktif dari semua delegasi) ─
  final double consensusPercent = mandates.isNotEmpty
      ? (mandates.where((m) => m.status == 'active').length / mandates.length * 100)
      : 0.0;

  // ── 7. Susun Execution History dari data elections nyata ──────────
  final List<DelegateExecutionItem> history = [];
  int activeCount = 0;
  int completedCount = 0;
  String? urgentTitle;
  String? urgentId;
  DateTime? urgentEndDate;

  for (final e in rawElections) {
    final eId = e['id'] as String? ?? '';
    final eTitle = e['title'] as String? ?? 'Pemilihan';
    final eStatus = e['status'] as String? ?? '';
    final startStr = e['start_date'] as String?;
    final endStr = e['end_date'] as String?;
    final date = startStr != null ? DateTime.tryParse(startStr) : null;
    final dateFormatted = date != null
        ? '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}'
        : '';

    final hasVoted = votedElectionIds.contains(eId);
    
    int actualVoteWeight = calculatedVotesHeld;
    if (hasVoted) {
      final voteRecord = rawVotes.firstWhere((v) => v['election_id'] == eId, orElse: () => <String, dynamic>{});
      actualVoteWeight = (voteRecord['vote_weight'] as num?)?.toInt() ?? calculatedVotesHeld;
    }
    
    // For active elections, use the current active mandates.
    // For past elections, we infer the number of mandators from the vote weight 
    // by subtracting the delegate's own vote weight.
    int activeMandators = mandates.where((m) => m.electionId == eId && m.status == 'active').length;
    if (hasVoted) {
      activeMandators = (actualVoteWeight - myOwnVoteWeight).clamp(0, 9999);
    }

    if (eStatus == 'live' && !hasVoted) {
      activeCount++;
      final endDate = endStr != null ? DateTime.tryParse(endStr) : null;
      // Pilih pemilihan yang paling urgent (deadline paling dekat)
      if (urgentId == null || (endDate != null && urgentEndDate != null && endDate.isBefore(urgentEndDate))) {
        urgentTitle = eTitle;
        urgentId = eId;
        urgentEndDate = endDate;
      }
      history.add(DelegateExecutionItem(
        electionId: eId,
        title: eTitle,
        dateString: dateFormatted,
        totalVotes: actualVoteWeight,
        totalMandators: activeMandators,
        status: 'Menunggu',
        createdAt: date,
      ));
    } else if (eStatus == 'completed' || (eStatus == 'live' && hasVoted)) {
      completedCount++;
      history.add(DelegateExecutionItem(
        electionId: eId,
        title: eTitle,
        dateString: dateFormatted,
        totalVotes: actualVoteWeight,
        totalMandators: activeMandators,
        status: 'Selesai',
        createdAt: date,
      ));
    }
  }

  // ── 8. Ambil kandidat untuk pemilihan urgent ─────────────────────
  List<DelegateCandidateItem> urgentCandidates = [];
  if (urgentId != null) {
    final candidatesRes = await client
        .from('candidates')
        .select('id, full_name, visi, photo_url, candidate_number')
        .eq('election_id', urgentId)
        .order('candidate_number');
    for (final c in (candidatesRes as List<dynamic>)) {
      urgentCandidates.add(DelegateCandidateItem(
        id: c['id'] as String? ?? '',
        name: c['full_name'] as String? ?? 'Kandidat',
        vision: c['visi'] as String?,
        photoUrl: c['photo_url'] as String?,
        candidateNumber: (c['candidate_number'] as num?)?.toInt() ?? 1,
      ));
    }
  }

  // ── 9. Hitung jam tersisa untuk pemilihan urgent ─────────────────
  int hoursLeft = 0;
  if (urgentEndDate != null) {
    final diff = urgentEndDate.difference(DateTime.now());
    hoursLeft = diff.inHours.clamp(0, 9999);
  }

  // ── 10. Hitung trust score & execution rate ───────────────────────
  final double trustScore = profile?.trustScore != null && profile!.trustScore > 0
      ? profile.trustScore
      : 0.0;
  final int totalExec = activeCount + completedCount;
  final double execRate = totalExec > 0
      ? (completedCount / totalExec * 100).clamp(0.0, 100.0)
      : 0.0;

  return DelegateDashboardData(
    mandates: mandates,
    executionHistory: history,
    totalVotesHeld: calculatedVotesHeld,
    activeElectionsCount: activeCount,
    completedElectionsCount: completedCount,
    trustScore: trustScore,
    executionRate: execRate,
    urgentElectionTitle: urgentTitle,
    urgentElectionId: urgentId,
    urgentElectionHoursLeft: hoursLeft,
    consensusPercent: consensusPercent,
    urgentElectionCandidates: urgentCandidates,
  );
});

String _monthName(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  if (month >= 1 && month <= 12) return months[month - 1];
  return 'Jun';
}
