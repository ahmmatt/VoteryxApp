// lib/features/user/delegation/data/repositories/delegation_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';

/// Repository untuk operasi delegasi suara.
class DelegationRepository {
  SupabaseClient get _client => SupabaseConfig.client;

  /// Helper: parse satu row users + delegate_applications menjadi Delegate entity.
  Delegate _parseDelegate(Map<String, dynamic> json,
      {Map<String, dynamic>? appRow}) {
    String? rawPhoto = json['avatar_url'] as String?;
    if (rawPhoto != null && rawPhoto.isNotEmpty && !rawPhoto.startsWith('http')) {
      rawPhoto = SupabaseConfig.client.storage.from('avatars').getPublicUrl(rawPhoto);
    }

    // Parse track records JSONB (kolom lama, mungkin tidak ada)
    List<Map<String, dynamic>> trackRecords = [];
    final rawTr = json['delegate_track_records'];
    if (rawTr is List) {
      trackRecords = rawTr.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }

    // Parse skills array (kolom lama, mungkin tidak ada)
    List<String> skills = [];
    final rawSkills = json['delegate_skills'];
    if (rawSkills is List) {
      skills = rawSkills.map((e) => e.toString()).toList();
    }

    return Delegate(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Delegate',
      faculty: json['faculty'] as String?,
      specialization: json['major'] as String?,
      delegateBio: json['delegate_bio'] as String?,
      delegateVision: json['delegate_vision'] as String?,
      photoUrl: rawPhoto,
      trustScore: (json['trust_score'] as num?)?.toDouble() ?? 0.0,
      delegationCount: 0,
      trackRecords: trackRecords,
      skills: skills,
      // Dari tabel delegate_applications
      expertise: appRow?['expertise'] as String?,
      bio: appRow?['bio'] as String?,
      trackRecord: appRow?['track_record'] as String?,
      portfolioUrl: appRow?['portfolio_url'] as String?,
      nim: appRow?['nim'] as String?,
    );
  }

  /// Ambil semua delegate publik (join dengan delegate_applications).
  Future<List<Delegate>> getPublicDelegates() async {
    final response = await _client
        .from('users')
        .select(
            'id, full_name, faculty, major, delegate_bio, delegate_vision, '
            'trust_score, avatar_url, role, is_delegate_profile_public, '
            'delegate_skills, delegate_track_records')
        .eq('role', 'delegate')
        .eq('is_delegate_profile_public', true)
        .order('trust_score', ascending: false);

    final List<Delegate> delegates = [];
    for (final json in (response as List)) {
      if (json['role'] != 'delegate' || json['is_delegate_profile_public'] != true) continue;

      // Coba ambil data dari delegate_applications berdasarkan user_id
      Map<String, dynamic>? appRow;
      try {
        appRow = await _client
            .from('delegate_applications')
            .select('expertise, bio, track_record, portfolio_url, nim, status')
            .eq('user_id', json['id'] as String)
            .eq('status', 'approved')
            .maybeSingle();
      } catch (_) {}

      delegates.add(_parseDelegate(Map<String, dynamic>.from(json), appRow: appRow));
    }
    return delegates;
  }

  /// Ambil satu delegate berdasarkan user ID (fresh dari DB).
  Future<Delegate?> getDelegateById(String userId) async {
    final json = await _client
        .from('users')
        .select(
            'id, full_name, faculty, major, delegate_bio, delegate_vision, '
            'trust_score, avatar_url, role, is_delegate_profile_public, '
            'delegate_skills, delegate_track_records')
        .eq('id', userId)
        .maybeSingle();

    if (json == null) return null;

    // Ambil data dari delegate_applications
    Map<String, dynamic>? appRow;
    try {
      appRow = await _client
          .from('delegate_applications')
          .select('expertise, bio, track_record, portfolio_url, nim, status')
          .eq('user_id', userId)
          .eq('status', 'approved')
          .maybeSingle();
    } catch (_) {}

    return _parseDelegate(Map<String, dynamic>.from(json), appRow: appRow);
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
