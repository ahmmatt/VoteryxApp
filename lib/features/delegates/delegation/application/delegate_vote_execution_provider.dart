import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/core/utils/hash_utils.dart';

class DelegateVoteExecutionState {
  final bool isProcessing;
  final bool isSuccess;
  final String? error;
  final String? transactionHash;
  final String? selectedCandidateId;
  final String? selectedCandidateName;
  final int totalWeight;

  DelegateVoteExecutionState({
    this.isProcessing = false,
    this.isSuccess = false,
    this.error,
    this.transactionHash,
    this.selectedCandidateId,
    this.selectedCandidateName,
    this.totalWeight = 0,
  });

  DelegateVoteExecutionState copyWith({
    bool? isProcessing,
    bool? isSuccess,
    String? error,
    String? transactionHash,
    String? selectedCandidateId,
    String? selectedCandidateName,
    int? totalWeight,
    bool clearError = false,
  }) {
    return DelegateVoteExecutionState(
      isProcessing: isProcessing ?? this.isProcessing,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      transactionHash: transactionHash ?? this.transactionHash,
      selectedCandidateId: selectedCandidateId ?? this.selectedCandidateId,
      selectedCandidateName: selectedCandidateName ?? this.selectedCandidateName,
      totalWeight: totalWeight ?? this.totalWeight,
    );
  }
}

class DelegateVoteExecutionNotifier extends StateNotifier<DelegateVoteExecutionState> {
  final Ref _ref;
  final _client = SupabaseConfig.client;

  DelegateVoteExecutionNotifier(this._ref) : super(DelegateVoteExecutionState());

  void selectCandidate(String candidateId, String candidateName) {
    state = state.copyWith(
      selectedCandidateId: candidateId,
      selectedCandidateName: candidateName,
      clearError: true,
    );
  }

  void setTotalWeight(int weight) {
    state = state.copyWith(totalWeight: weight);
  }

  Future<void> executeDelegateVote({
    required String electionId,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    final candidateId = state.selectedCandidateId;
    final totalWeight = state.totalWeight;

    if (userId == null || candidateId == null || electionId.isEmpty) {
      state = state.copyWith(error: 'Data tidak lengkap untuk eksekusi suara.');
      return;
    }

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      final hash = HashUtils.generateVoteTransactionHash(
        userId: userId,
        electionId: electionId,
        candidateId: candidateId,
        timestamp: DateTime.now(),
      );

      await _client.from('votes').insert({
        'election_id': electionId,
        'voter_id': userId,
        'vote_weight': totalWeight,
        'encrypted_choice': candidateId,
        'transaction_hash': hash,
      });

      state = state.copyWith(
        isProcessing: false,
        isSuccess: true,
        transactionHash: hash,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }
}

final delegateVoteExecutionProvider = StateNotifierProvider<DelegateVoteExecutionNotifier, DelegateVoteExecutionState>((ref) {
  return DelegateVoteExecutionNotifier(ref);
});
