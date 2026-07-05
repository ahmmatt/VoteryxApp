import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DelegateApplicationStatus { none, pending, approved, rejected }

class DelegateApplication {
  const DelegateApplication({
    required this.id,
    required this.name,
    required this.expertise,
    required this.bio,
    required this.portfolioUrl,
    required this.isStudent,
    required this.nim,
    required this.status,
  });

  final String id;
  final String name;
  final String expertise;
  final String bio;
  final String portfolioUrl;
  final bool isStudent;
  final String nim;
  final DelegateApplicationStatus status;

  DelegateApplication copyWith({
    String? id,
    String? name,
    String? expertise,
    String? bio,
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
            portfolioUrl: 'https://linkedin.com/in/dian-sastro',
            isStudent: true,
            nim: '221011001',
            status: DelegateApplicationStatus.pending,
          ),
        ]);

  void submit({
    required String name,
    required String expertise,
    required String bio,
    required String portfolioUrl,
    required bool isStudent,
    required String nim,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final application = DelegateApplication(
      id: 'DEL-REQ-$timestamp',
      name: name.trim().isEmpty ? 'Pengguna Voteryx' : name.trim(),
      expertise: expertise,
      bio: bio.trim().isEmpty ? 'Belum ada bio rinci.' : bio.trim(),
      portfolioUrl: portfolioUrl.trim(),
      isStudent: isStudent,
      nim: isStudent ? nim.trim() : '',
      status: DelegateApplicationStatus.pending,
    );

    state = [application, ...state];
  }

  void approve(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(status: DelegateApplicationStatus.approved)
        else
          item,
    ];
  }

  void reject(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(status: DelegateApplicationStatus.rejected)
        else
          item,
    ];
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
