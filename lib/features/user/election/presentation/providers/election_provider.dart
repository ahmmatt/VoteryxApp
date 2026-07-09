// lib/features/user/election/presentation/providers/election_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/user/election/data/repositories/election_repository.dart';
import 'package:voteryxapp/features/user/election/domain/entities/election.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

final electionRepositoryProvider = Provider<ElectionRepository>(
  (ref) => ElectionRepository(),
);

// ─── Election List Provider ───────────────────────────────────────────────────

/// List semua pemilihan aktif (live + scheduled).
final activeElectionsProvider = FutureProvider.autoDispose<List<Election>>((ref) async {
  final repo = ref.read(electionRepositoryProvider);
  return await repo.getActiveElections();
});

/// List semua pemilihan (semua status).
final allElectionsProvider = FutureProvider.autoDispose<List<Election>>((ref) async {
  final repo = ref.read(electionRepositoryProvider);
  return await repo.getAllElections();
});

/// Set ID pemilihan di mana user sudah memilih / mendelegasikan suara.
final userParticipatedElectionIdsProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  final repo = ref.read(electionRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return <String>{};
  return await repo.getUserParticipatedElectionIds(userId);
});

// ─── Election Detail Provider ─────────────────────────────────────────────────

/// Data parameter untuk election detail (election + candidates + user status).
class ElectionDetailData {
  const ElectionDetailData({
    required this.election,
    required this.candidates,
    this.hasVoted = false,
    this.hasDelegated = false,
  });

  final Election election;
  final List<Candidate> candidates;
  final bool hasVoted;
  final bool hasDelegated;

  bool get hasParticipated => hasVoted || hasDelegated;
}

final electionDetailProvider = FutureProvider.autoDispose
    .family<ElectionDetailData, String>((ref, electionId) async {
  final repo = ref.read(electionRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);

  // Ambil election + candidates paralel dengan status user
  final futures = await Future.wait([
    repo.getElectionWithCandidates(electionId),
    if (userId != null) repo.hasUserVotedInElection(electionId, userId),
    if (userId != null) repo.hasUserDelegatedInElection(electionId, userId),
  ]);

  final electionData = futures[0] as Map<String, dynamic>;
  final hasVoted = userId != null ? (futures[1] as bool) : false;
  final hasDelegated = userId != null ? (futures[2] as bool) : false;

  return ElectionDetailData(
    election: electionData['election'] as Election,
    candidates: electionData['candidates'] as List<Candidate>,
    hasVoted: hasVoted,
    hasDelegated: hasDelegated,
  );
});

// ─── Candidate Detail Provider ────────────────────────────────────────────────

final candidateDetailProvider = FutureProvider.autoDispose
    .family<Candidate?, String>((ref, candidateId) async {
  final repo = ref.read(electionRepositoryProvider);
  return await repo.getCandidateDetail(candidateId);
});

// ─── Dashboard Summary Provider ───────────────────────────────────────────────

/// Data gabungan untuk dashboard: pemilihan aktif + status partisipasi + mandat.
class DashboardData {
  const DashboardData({
    required this.activeElections,
    required this.votedElectionIds,
    required this.hasActiveMandate,
  });

  final List<Election> activeElections;
  final Set<String> votedElectionIds;
  final bool hasActiveMandate;
}

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final repo = ref.read(electionRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);

  // Parallel fetch
  final results = await Future.wait([
    repo.getActiveElections(),
    if (userId != null) repo.getUserParticipatedElectionIds(userId),
    if (userId != null) repo.hasActiveMandate(userId),
  ]);

  final elections = results[0] as List<Election>;
  final votedIds = userId != null
      ? (results[1] as Set<String>)
      : <String>{};
  final hasMandate = userId != null
      ? (results[2] as bool)
      : false;

  return DashboardData(
    activeElections: elections,
    votedElectionIds: votedIds,
    hasActiveMandate: hasMandate,
  );
});
