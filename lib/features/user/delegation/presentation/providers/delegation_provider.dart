// lib/features/user/delegation/presentation/providers/delegation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:voteryxapp/core/error/supabase_error_handler.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/user/delegation/data/repositories/delegation_repository.dart';
import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

final delegationRepositoryProvider = Provider<DelegationRepository>(
  (ref) => DelegationRepository(),
);

// ─── Public Delegates List ────────────────────────────────────────────────────

final publicDelegatesProvider = FutureProvider.autoDispose<List<Delegate>>((ref) async {
  final repo = ref.read(delegationRepositoryProvider);
  return await repo.getPublicDelegates();
});

/// Provider untuk mengambil detail satu delegate berdasarkan ID-nya langsung dari DB.
final delegateDetailProvider =
    FutureProvider.autoDispose.family<Delegate?, String>((ref, delegateId) async {
  final repo = ref.read(delegationRepositoryProvider);
  return await repo.getDelegateById(delegateId);
});

// ─── Delegation Action State ──────────────────────────────────────────────────

class DelegationActionState {
  const DelegationActionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.selectedDelegateId,
    this.selectedDelegateName,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? selectedDelegateId;
  final String? selectedDelegateName;

  DelegationActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? selectedDelegateId,
    String? selectedDelegateName,
  }) {
    return DelegationActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      selectedDelegateId: selectedDelegateId ?? this.selectedDelegateId,
      selectedDelegateName: selectedDelegateName ?? this.selectedDelegateName,
    );
  }
}

final delegationActionProvider =
    StateNotifierProvider<DelegationActionNotifier, DelegationActionState>(
  (ref) => DelegationActionNotifier(ref),
);

class DelegationActionNotifier extends StateNotifier<DelegationActionState> {
  DelegationActionNotifier(this._ref) : super(const DelegationActionState());

  final Ref _ref;

  void selectDelegate({
    required String delegateId,
    required String delegateName,
  }) {
    state = state.copyWith(
      selectedDelegateId: delegateId,
      selectedDelegateName: delegateName,
      isSuccess: false,
      error: null,
    );
  }

  /// Buat delegasi untuk pemilihan tertentu.
  Future<void> createDelegation({required String electionId}) async {
    final userId = _ref.read(currentUserIdProvider);
    final delegateId = state.selectedDelegateId;

    if (userId == null || delegateId == null) {
      state = state.copyWith(error: 'Data tidak lengkap. Pilih delegate terlebih dahulu.');
      return;
    }

    // Tidak boleh delegasi ke diri sendiri
    if (userId == delegateId) {
      state = state.copyWith(error: 'Kamu tidak bisa mendelegasikan suara ke diri sendiri.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repo = _ref.read(delegationRepositoryProvider);
      await repo.createDelegation(
        electionId: electionId,
        delegatorId: userId,
        delegateId: delegateId,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on PostgrestException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.code == '23505'
            ? 'Kamu sudah mendelegasikan suara di pemilihan ini.'
            : e.userFriendlyMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: extractUserFriendlyError(e),
      );
    }
  }

  Future<void> cancelDelegation({required String electionId}) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(delegationRepositoryProvider);
      // Wait, let's look at the repository for cancelling. It is `revokeDelegation` actually!
      await repo.revokeDelegation(
        electionId: electionId,
        delegatorId: userId,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: extractUserFriendlyError(e),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
  void reset() => state = const DelegationActionState();
}
