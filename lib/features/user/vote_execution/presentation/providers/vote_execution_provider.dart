// lib/features/user/vote_execution/presentation/providers/vote_execution_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:voteryxapp/core/error/supabase_error_handler.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/core/utils/hash_utils.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

// ─── Vote Execution State ─────────────────────────────────────────────────────

class VoteExecutionState {
  const VoteExecutionState({
    this.selectedCandidateId,
    this.selectedCandidateName,
    this.electionId,
    this.electionTitle,
    this.timestampFormatted,
    this.isDelegation = false,
    this.isProcessing = false,
    this.isSuccess = false,
    this.transactionHash,
    this.error,
  });

  final String? selectedCandidateId;
  final String? selectedCandidateName;
  final String? electionId;
  final String? electionTitle;
  final String? timestampFormatted;
  final bool isDelegation;
  final bool isProcessing;
  final bool isSuccess;
  final String? transactionHash;
  final String? error;

  VoteExecutionState copyWith({
    String? selectedCandidateId,
    String? selectedCandidateName,
    String? electionId,
    String? electionTitle,
    String? timestampFormatted,
    bool? isDelegation,
    bool? isProcessing,
    bool? isSuccess,
    String? transactionHash,
    String? error,
  }) {
    return VoteExecutionState(
      selectedCandidateId: selectedCandidateId ?? this.selectedCandidateId,
      selectedCandidateName: selectedCandidateName ?? this.selectedCandidateName,
      electionId: electionId ?? this.electionId,
      electionTitle: electionTitle ?? this.electionTitle,
      timestampFormatted: timestampFormatted ?? this.timestampFormatted,
      isDelegation: isDelegation ?? this.isDelegation,
      isProcessing: isProcessing ?? this.isProcessing,
      isSuccess: isSuccess ?? this.isSuccess,
      transactionHash: transactionHash ?? this.transactionHash,
      error: error,
    );
  }
}

// ─── Vote Execution Notifier ──────────────────────────────────────────────────

final voteExecutionProvider =
    StateNotifierProvider<VoteExecutionNotifier, VoteExecutionState>(
  (ref) => VoteExecutionNotifier(ref),
);

class VoteExecutionNotifier extends StateNotifier<VoteExecutionState> {
  VoteExecutionNotifier(this._ref) : super(const VoteExecutionState());

  final Ref _ref;
  SupabaseClient get _client => SupabaseConfig.client;

  /// Set kandidat yang dipilih sebelum eksekusi.
  void setSelectedCandidate({
    required String candidateId,
    required String candidateName,
    required String electionId,
  }) {
    state = state.copyWith(
      selectedCandidateId: candidateId,
      selectedCandidateName: candidateName,
      electionId: electionId,
      isSuccess: false,
      error: null,
    );
  }

  /// Eksekusi vote: generate hash → insert ke Supabase.
  Future<void> executeVote() async {
    final userId = _ref.read(currentUserIdProvider);
    final candidateId = state.selectedCandidateId;
    final electionId = state.electionId;

    if (userId == null || candidateId == null || electionId == null) {
      state = state.copyWith(error: 'Data vote tidak lengkap.');
      return;
    }

    state = state.copyWith(isProcessing: true, error: null);

    try {
      // 1. Generate transaction hash
      final hash = HashUtils.generateVoteTransactionHash(
        userId: userId,
        electionId: electionId,
        candidateId: candidateId,
        timestamp: DateTime.now(),
      );

      // 2. Insert ke tabel votes
      // Note: encrypted_choice diisi dengan candidateId untuk saat ini
      // (enkripsi RSA dengan electionPublicKey bisa ditambahkan nanti)
      await _client.from('votes').insert({
        'election_id': electionId,
        'voter_id': userId,
        'vote_weight': 1,
        'encrypted_choice': candidateId, // TODO: enkripsi RSA dengan public key
        'transaction_hash': hash,
      });

      state = state.copyWith(
        isProcessing: false,
        isSuccess: true,
        transactionHash: hash,
      );
    } on PostgrestException catch (e) {
      // 23505 = unique violation → sudah memilih
      if (e.code == '23505') {
        state = state.copyWith(
          isProcessing: false,
          error: 'Kamu sudah memilih di pemilihan ini.',
        );
      } else {
        state = state.copyWith(
          isProcessing: false,
          error: e.userFriendlyMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: extractUserFriendlyError(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Set data receipt secara langsung (berguna dari HistoryScreen / Lihat Bukti)
  void setReceiptData({
    required String transactionHash,
    required String candidateName,
    required String electionId,
    String? electionTitle,
    String? timestampFormatted,
    bool isDelegation = false,
  }) {
    state = state.copyWith(
      transactionHash: transactionHash,
      selectedCandidateName: candidateName,
      electionId: electionId,
      electionTitle: electionTitle,
      timestampFormatted: timestampFormatted,
      isDelegation: isDelegation,
      isSuccess: true,
      error: null,
    );
  }

  void reset() {
    state = const VoteExecutionState();
  }
}
