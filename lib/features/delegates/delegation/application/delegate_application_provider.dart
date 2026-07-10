import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';

enum DelegateApplicationStatus { none, pending, approved, rejected }

class DelegateApplication {
  const DelegateApplication({
    required this.id,
    required this.name,
    required this.expertise,
    required this.bio,
    required this.trackRecord,
    required this.portfolioUrl,
    required this.isStudent,
    required this.nim,
    required this.status,
  });

  final String id;
  final String name;
  final String expertise;
  final String bio;
  final String trackRecord;
  final String portfolioUrl;
  final bool isStudent;
  final String nim;
  final DelegateApplicationStatus status;

  DelegateApplication copyWith({
    String? id,
    String? name,
    String? expertise,
    String? bio,
    String? trackRecord,
    String? portfolioUrl,
    bool? isStudent,
    String? nim,
    DelegateApplicationStatus? status,
  }) {
    return DelegateApplication(
      id: id ?? this.id,
      name: name ?? this.name,
      expertise: expertise ?? this.expertise,
      bio: bio ?? this.bio,
      trackRecord: trackRecord ?? this.trackRecord,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      isStudent: isStudent ?? this.isStudent,
      nim: nim ?? this.nim,
      status: status ?? this.status,
    );
  }
}

class DelegateApplicationController extends StateNotifier<List<DelegateApplication>> {
  DelegateApplicationController()
      : super(const [
          DelegateApplication(
            id: 'DEL-REQ-2407-001',
            name: 'Dian Sastro',
            expertise: 'Kebijakan Kampus',
            bio: 'Aktif dalam forum aspirasi mahasiswa dan terbiasa menyusun ringkasan isu untuk pemilih.',
            trackRecord: 'Ketua BEM Fakultas 2023, Juara 1 Debat Konstitusi Nasional, Pengurus Advokasi Mahasiswa.',
            portfolioUrl: 'https://linkedin.com/in/dian-sastro',
            isStudent: true,
            nim: '221011001',
            status: DelegateApplicationStatus.pending,
          ),
        ]) {
    fetchFromDb();
  }

  Future<void> fetchFromDb() async {
    try {
      final response = await SupabaseConfig.client
          .from('delegate_applications')
          .select('*')
          .order('created_at', ascending: false);

      List<DelegateApplication> dbList = (response as List).map((row) {
        final statusStr = row['status']?.toString() ?? 'pending';
        DelegateApplicationStatus st = DelegateApplicationStatus.pending;
        if (statusStr == 'approved') st = DelegateApplicationStatus.approved;
        if (statusStr == 'rejected') st = DelegateApplicationStatus.rejected;

        return DelegateApplication(
          id: row['id']?.toString() ?? '',
          name: row['name']?.toString() ?? 'Pengguna Voteryx',
          expertise: row['expertise']?.toString() ?? 'Umum',
          bio: row['bio']?.toString() ?? '-',
          trackRecord: row['track_record']?.toString() ?? '-',
          portfolioUrl: row['portfolio_url']?.toString() ?? '',
          isStudent: row['is_student'] == true,
          nim: row['nim']?.toString() ?? '',
          status: st,
        );
      }).toList();

      // Jika tabel di cloud masih kosong, otomatis seed Dian Sastro ke Supabase!
      if (dbList.isEmpty) {
        try {
          await SupabaseConfig.client.from('delegate_applications').insert({
            'id': 'DEL-REQ-2407-001',
            'name': 'Dian Sastro',
            'expertise': 'Kebijakan Kampus',
            'bio': 'Aktif dalam forum aspirasi mahasiswa dan terbiasa menyusun ringkasan isu untuk pemilih.',
            'track_record': 'Ketua BEM Fakultas 2023, Juara 1 Debat Konstitusi Nasional, Pengurus Advokasi Mahasiswa.',
            'portfolio_url': 'https://linkedin.com/in/dian-sastro',
            'is_student': true,
            'nim': '221011001',
            'status': 'pending',
          });
          dbList = [
            const DelegateApplication(
              id: 'DEL-REQ-2407-001',
              name: 'Dian Sastro',
              expertise: 'Kebijakan Kampus',
              bio: 'Aktif dalam forum aspirasi mahasiswa dan terbiasa menyusun ringkasan isu untuk pemilih.',
              trackRecord: 'Ketua BEM Fakultas 2023, Juara 1 Debat Konstitusi Nasional, Pengurus Advokasi Mahasiswa.',
              portfolioUrl: 'https://linkedin.com/in/dian-sastro',
              isStudent: true,
              nim: '221011001',
              status: DelegateApplicationStatus.pending,
            )
          ];
        } catch (_) {}
      }


      if (dbList.isNotEmpty) {
        state = dbList;
      }
    } catch (_) {
      // Abaikan jika tabel belum ada di cloud Supabase
    }
  }

  Future<void> submit({
    required String name,
    required String expertise,
    required String bio,
    required String trackRecord,
    required String portfolioUrl,
    required bool isStudent,
    required String nim,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final id = 'DEL-REQ-$timestamp';
    final application = DelegateApplication(
      id: id,
      name: name.trim().isEmpty ? 'Pengguna Voteryx' : name.trim(),
      expertise: expertise,
      bio: bio.trim().isEmpty ? 'Belum ada bio rinci.' : bio.trim(),
      trackRecord: trackRecord.trim().isEmpty ? 'Belum dicantumkan.' : trackRecord.trim(),
      portfolioUrl: portfolioUrl.trim(),
      isStudent: isStudent,
      nim: isStudent ? nim.trim() : '',
      status: DelegateApplicationStatus.pending,
    );

    state = [application, ...state];

    try {
      final currentUserId = SupabaseConfig.client.auth.currentUser?.id;
      await SupabaseConfig.client.from('delegate_applications').insert({
        'id': id,
        'user_id': currentUserId,
        'name': application.name,
        'expertise': application.expertise,
        'bio': application.bio,
        'track_record': application.trackRecord,
        'portfolio_url': application.portfolioUrl,
        'is_student': application.isStudent,
        'nim': application.nim,
        'status': 'pending',
      });

      // Update juga tabel users jika user saat ini login agar datanya langsung menyatu
      if (currentUserId != null) {
        await SupabaseConfig.client.from('users').update({
          'delegate_bio': application.bio,
          'delegate_vision': application.expertise,
          'is_delegate_profile_public': true,
        }).eq('id', currentUserId);
      } else if (application.nim.isNotEmpty) {
        await SupabaseConfig.client.from('users').update({
          'delegate_bio': application.bio,
          'delegate_vision': application.expertise,
          'is_delegate_profile_public': true,
        }).eq('nim', application.nim);
      }
    } catch (_) {}
  }

  Future<void> approve(String id) async {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(status: DelegateApplicationStatus.approved)
        else
          item,
    ];

    try {
      await SupabaseConfig.client
          .from('delegate_applications')
          .update({'status': 'approved'}).eq('id', id);

      final app = state.firstWhere((e) => e.id == id);
      if (app.nim.isNotEmpty) {
        await SupabaseConfig.client
            .from('users')
            .update({
              'role': 'delegate',
              'is_delegate_profile_public': true,
              'delegate_bio': app.bio,
              'delegate_vision': app.expertise,
            })
            .eq('nim', app.nim);
      }
    } catch (_) {}
  }

  Future<void> reject(String id) async {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(status: DelegateApplicationStatus.rejected)
        else
          item,
    ];

    try {
      await SupabaseConfig.client
          .from('delegate_applications')
          .update({'status': 'rejected'}).eq('id', id);
    } catch (_) {}
  }
}

final delegateApplicationProvider = StateNotifierProvider<DelegateApplicationController, List<DelegateApplication>>(
  (ref) => DelegateApplicationController(),
);

final latestDelegateApplicationProvider = Provider<DelegateApplication?>((ref) {
  final applications = ref.watch(delegateApplicationProvider);
  if (applications.isEmpty) return null;
  return applications.first;
});

final pendingDelegateApplicationsProvider = Provider<List<DelegateApplication>>((ref) {
  return ref
      .watch(delegateApplicationProvider)
      .where((item) => item.status == DelegateApplicationStatus.pending)
      .toList(growable: false);
});
