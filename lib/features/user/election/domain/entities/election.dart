// lib/features/user/election/domain/entities/election.dart

/// Entity untuk data pemilihan dari tabel `elections`.
class Election {
  const Election({
    required this.id,
    required this.title,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.description,
    this.organization,
    this.electionType,
    this.candidateCount = 0,
    this.voteCount = 0,
    this.estimatedVoters = 0,
    this.publicKey,
  });

  final String id;
  final String title;

  /// Status: `'draft'` | `'scheduled'` | `'live'` | `'completed'` | `'cancelled'`
  final String status;

  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? organization;
  final String? electionType;
  final int candidateCount;
  final int voteCount;
  final int estimatedVoters;

  /// Public key untuk enkripsi suara.
  final String? publicKey;

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';
  bool get isCompleted => status == 'completed';

  /// Persentase partisipasi (0.0 - 1.0).
  double get participationRate {
    if (estimatedVoters == 0) return 0;
    return (voteCount / estimatedVoters).clamp(0.0, 1.0);
  }

  /// Durasi tersisa sebelum pemilihan berakhir.
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return Duration.zero;
    return endDate.difference(now);
  }

  /// Format sisa waktu sebagai string "DD Hari : HH Jam : MM Menit"
  String get timeRemainingFormatted {
    final remaining = timeRemaining;
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    return '${days.toString().padLeft(2, '0')} Hari · ${hours.toString().padLeft(2, '0')} Jam · ${minutes.toString().padLeft(2, '0')} Menit';
  }
}

/// Entity untuk kandidat pemilihan dari tabel `candidates`.
class Candidate {
  const Candidate({
    required this.id,
    required this.electionId,
    required this.fullName,
    this.nim,
    this.faculty,
    this.photoUrl,
    this.visi,
    this.misi,
    this.trackRecords = const [],
    this.programs = const [],
    this.voteCount = 0,
    this.isVerified = false,
    this.candidateNumber,
  });

  final String id;
  final String electionId;
  final String fullName;
  final String? nim;
  final String? faculty;
  final String? photoUrl;
  final String? visi;
  final String? misi;

  /// List track record, format: [{'year': '2024', 'title': '...', 'description': '...'}]
  final List<Map<String, dynamic>> trackRecords;

  /// List program kerja, format: [{'title': '...', 'description': '...', 'icon': '...'}]
  final List<Map<String, dynamic>> programs;

  final int voteCount;
  final bool isVerified;
  final int? candidateNumber;
}
