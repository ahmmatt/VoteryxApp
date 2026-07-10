import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';

class CandidateDocumentState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic>? candidateData;

  const CandidateDocumentState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.candidateData,
  });

  CandidateDocumentState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    Map<String, dynamic>? candidateData,
  }) {
    return CandidateDocumentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      candidateData: candidateData ?? this.candidateData,
    );
  }
}

class CandidateDocumentNotifier extends StateNotifier<CandidateDocumentState> {
  final Ref ref;

  CandidateDocumentNotifier(this.ref) : super(const CandidateDocumentState());

  Future<void> fetchCandidateData(String proposalId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) throw Exception('User tidak ditemukan.');

      final response = await SupabaseConfig.client
          .from('proposal_candidates')
          .select()
          .eq('proposal_id', proposalId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Data kandidat tidak ditemukan.');
      }

      state = state.copyWith(isLoading: false, candidateData: response as Map<String, dynamic>);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> submitDocument({
    required String proposalId,
    required String visi,
    required String misi,
    required List<Map<String, dynamic>> trackRecords,
    required List<Map<String, dynamic>> programs,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) throw Exception('User tidak ditemukan.');

      // Ambil photo URL user
      final userResponse = await SupabaseConfig.client
          .from('users')
          .select('avatar_url')
          .eq('id', userId)
          .maybeSingle();
          
      final String? photoUrl = userResponse?['avatar_url'] as String?;

      await SupabaseConfig.client
          .from('proposal_candidates')
          .update({
            'visi': visi,
            'misi': misi,
            'track_records': trackRecords,
            'programs': programs,
            'photo_url': photoUrl,
            'docs_completed': true,
          })
          .eq('proposal_id', proposalId)
          .eq('user_id', userId);

      // Notifikasi akan otomatis menjadi dismissible karena docs_completed = true
      // (dinilai secara dinamis oleh userNotificationsProvider).

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final candidateDocumentProvider = StateNotifierProvider.autoDispose<CandidateDocumentNotifier, CandidateDocumentState>((ref) {
  return CandidateDocumentNotifier(ref);
});
