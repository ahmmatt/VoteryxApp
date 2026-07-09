import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';

final adminCandidateVerificationProvider = StateNotifierProvider<
    AdminCandidateVerificationNotifier,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return AdminCandidateVerificationNotifier();
});

class AdminCandidateVerificationNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  AdminCandidateVerificationNotifier() : super(const AsyncValue.loading()) {
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    state = const AsyncValue.loading();
    try {
      final response = await SupabaseConfig.client
          .from('candidates')
          .select('*, elections(title)')
          .order('created_at', ascending: false);

      final list = (response as List).cast<Map<String, dynamic>>();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateVerificationStatus(
      String candidateId, bool isVerified) async {
    try {
      await SupabaseConfig.client
          .from('candidates')
          .update({'is_verified': isVerified}).eq('id', candidateId);
      await fetchCandidates();
      return true;
    } catch (e) {
      return false;
    }
  }
}
