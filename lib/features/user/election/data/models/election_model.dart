// lib/features/user/election/data/models/election_model.dart
import '../../domain/entities/election.dart';

class ElectionModel extends Election {
  const ElectionModel({
    required super.id,
    required super.title,
    required super.status,
    required super.startDate,
    required super.endDate,
    super.description,
    super.organization,
    super.electionType,
    super.candidateCount,
    super.voteCount,
    super.estimatedVoters,
    super.publicKey,
  });

  factory ElectionModel.fromJson(Map<String, dynamic> json) {
    // Parse candidate count dari nested response
    int candidateCount = 0;
    if (json['candidates'] != null) {
      if (json['candidates'] is List) {
        candidateCount = (json['candidates'] as List).length;
      } else if (json['candidates'] is Map) {
        candidateCount = (json['candidates']['count'] as num?)?.toInt() ?? 0;
      }
    }

    // Parse vote count dari nested response
    int voteCount = 0;
    if (json['votes'] != null) {
      if (json['votes'] is List) {
        voteCount = (json['votes'] as List).length;
      } else if (json['votes'] is Map) {
        voteCount = (json['votes']['count'] as num?)?.toInt() ?? 0;
      }
    }

    return ElectionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Pemilihan',
      status: json['status'] as String? ?? 'draft',
      startDate: _parseDate(json['start_date']) ?? DateTime.now(),
      endDate: _parseDate(json['end_date']) ?? DateTime.now().add(const Duration(days: 7)),
      description: json['description'] as String?,
      organization: json['organization'] as String?,
      electionType: json['election_type'] as String?,
      candidateCount: candidateCount,
      voteCount: voteCount,
      estimatedVoters: (json['estimated_voters'] as num?)?.toInt() ?? 0,
      publicKey: json['public_key'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class CandidateModel extends Candidate {
  const CandidateModel({
    required super.id,
    required super.electionId,
    required super.fullName,
    super.nim,
    super.faculty,
    super.photoUrl,
    super.visi,
    super.misi,
    super.trackRecords,
    super.programs,
    super.voteCount,
    super.isVerified,
    super.candidateNumber,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    // Parse track_records JSONB
    List<Map<String, dynamic>> trackRecords = [];
    if (json['track_records'] != null) {
      try {
        final raw = json['track_records'];
        if (raw is List) {
          trackRecords = raw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      } catch (_) {}
    }

    // Parse programs JSONB
    List<Map<String, dynamic>> programs = [];
    if (json['programs'] != null) {
      try {
        final raw = json['programs'];
        if (raw is List) {
          programs = raw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      } catch (_) {}
    }

    return CandidateModel(
      id: json['id'] as String? ?? '',
      electionId: json['election_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Kandidat',
      nim: json['nim'] as String?,
      faculty: json['faculty'] as String?,
      photoUrl: json['photo_url'] as String?,
      visi: json['visi'] as String?,
      misi: json['misi'] as String?,
      trackRecords: trackRecords,
      programs: programs,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      candidateNumber: (json['candidate_number'] as num?)?.toInt(),
    );
  }
}
