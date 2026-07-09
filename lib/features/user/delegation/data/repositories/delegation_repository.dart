// lib/features/user/delegation/data/repositories/delegation_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';

/// Repository untuk operasi delegasi suara.
class DelegationRepository {
  SupabaseClient get _client => SupabaseConfig.client;

  /// Ambil semua user yang profil delegate-nya publik,
  /// diurutkan berdasarkan trust_score tertinggi.
  Future<List<Delegate>> getPublicDelegates() async {
    final response = await _client
        .from('users')
        .select(
            'id, full_name, faculty, major, delegate_bio, delegate_vision, '
            'trust_score, avatar_url, role, is_delegate_profile_public')
        .or('is_delegate_profile_public.eq.true,role.eq.delegate')
        .order('trust_score', ascending: false);

    return (response as List).map((json) {
      return Delegate(
        id: json['id'] as String? ?? '',
        fullName: json['full_name'] as String? ?? 'Delegate',
        faculty: json['faculty'] as String?,
        specialization: json['major'] as String? ?? json['specialization'] as String?,
        delegateBio: json['delegate_bio'] as String?,
        delegateVision: json['delegate_vision'] as String?,
        photoUrl: json['avatar_url'] as String? ?? json['photo_url'] as String?,
        trustScore: (json['trust_score'] as num?)?.toDouble() ?? 0.0,
        delegationCount: 0,
      );
    }).toList();
  }

  /// Buat delegasi baru.
  Future<void> createDelegation({
    required String electionId,
    required String delegatorId,
    required String delegateId,
  }) async {
    await _client.from('delegations').insert({
      'election_id': electionId,
      'delegator_id': delegatorId,
      'delegate_id': delegateId,
      'status': 'active',
    });
  }

  /// Cabut delegasi aktif.
  Future<void> revokeDelegation({
    required String electionId,
    required String delegatorId,
  }) async {
    await _client
        .from('delegations')
        .update({'status': 'revoked'})
        .eq('election_id', electionId)
        .eq('delegator_id', delegatorId)
        .eq('status', 'active');
  }

  /// Ambil delegasi aktif user di pemilihan tertentu (sebagai delegator).
  Future<DelegationData?> getActiveDelegation({
    required String electionId,
    required String userId,
  }) async {
    final response = await _client
        .from('delegations')
        .select()
        .eq('election_id', electionId)
        .eq('delegator_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    if (response == null) return null;
    return DelegationData(
      id: response['id'] as String? ?? '',
      electionId: response['election_id'] as String? ?? '',
      delegatorId: response['delegator_id'] as String? ?? '',
      delegateId: response['delegate_id'] as String? ?? '',
      status: response['status'] as String? ?? 'active',
      createdAt: response['created_at'] != null
          ? DateTime.tryParse(response['created_at'] as String)
          : null,
    );
  }

  /// Ambil riwayat semua delegasi user.
  Future<List<DelegationData>> getUserDelegationHistory(String userId) async {
    final response = await _client
        .from('delegations')
        .select()
        .eq('delegator_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      return DelegationData(
        id: json['id'] as String? ?? '',
        electionId: json['election_id'] as String? ?? '',
        delegatorId: json['delegator_id'] as String? ?? '',
        delegateId: json['delegate_id'] as String? ?? '',
        status: json['status'] as String? ?? 'active',
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );
    }).toList();
  }
}
