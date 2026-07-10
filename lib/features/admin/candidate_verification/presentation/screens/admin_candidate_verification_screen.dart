import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/features/admin/candidate_verification/presentation/providers/admin_candidate_verification_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminCandidateVerificationScreen extends ConsumerWidget {
  const AdminCandidateVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatesAsync = ref.watch(adminCandidateVerificationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Verifikasi Kandidat', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(adminCandidateVerificationProvider.notifier).fetchCandidates(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: candidatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goldMid)),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Gagal memuat data kandidat', style: AppTypography.bodyMedium),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(adminCandidateVerificationProvider.notifier).fetchCandidates(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (candidates) {
          if (candidates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('Belum ada kandidat di database', style: AppTypography.screenTitle.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.goldMid,
            onRefresh: () async {
              await ref.read(adminCandidateVerificationProvider.notifier).fetchCandidates();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: candidates.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final c = candidates[index];
                final name = c['full_name']?.toString() ?? 'Nama tidak diketahui';
                final faculty = c['faculty']?.toString() ?? c['major']?.toString() ?? '-';
                final candNo = c['candidate_number']?.toString() ?? '-';
                final nimVal = c['nim']?.toString() ?? '-';
                final nim = '$nimVal • No. Urut $candNo';
                final imageUrl = getCandidateAvatarUrl(c);
                final isVerified = c['is_verified'] == true;
                final electionTitle = (c['elections'] is Map) ? (c['elections']['title']?.toString() ?? 'Pemilihan Umum') : 'Pemilihan Umum';
                final candidateId = c['id']?.toString() ?? '';
                final electionId = c['election_id']?.toString() ?? '';
                final isProposal = c['is_proposal'] == true;

                return _buildCandidateCard(
                  context: context,
                  ref: ref,
                  candidateId: candidateId,
                  electionId: electionId,
                  isProposal: isProposal,
                  name: name,
                  faculty: faculty,
                  nim: nim,
                  electionTitle: electionTitle,
                  imageUrl: imageUrl,
                  isVerified: isVerified,
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCandidateCard({
    required BuildContext context,
    required WidgetRef ref,
    required String candidateId,
    required String electionId,
    required bool isProposal,
    required String name,
    required String faculty,
    required String nim,
    required String electionTitle,
    required String? imageUrl,
    required bool isVerified,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: !isVerified ? Border.all(color: AppColors.goldMid) : Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: !isVerified ? AppColors.goldMid : Colors.green,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppRadius.card)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCandidateAvatarWidget(
                          imageUrl: imageUrl,
                          size: 48,
                          radius: 10,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primary900,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(faculty,
                                  style: AppTypography.caption.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: !isVerified
                                ? AppColors.goldMid.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: !isVerified
                                    ? AppColors.goldMid.withOpacity(0.3)
                                    : Colors.green.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: !isVerified
                                          ? AppColors.goldMid
                                          : Colors.green,
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text(!isVerified ? 'MENUNGGU' : 'TERVERIFIKASI',
                                  style: AppTypography.captionBold.copyWith(
                                      color: !isVerified
                                          ? AppColors.goldDark
                                          : Colors.green.shade800,
                                      fontSize: 9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pemilihan',
                            style: AppTypography.caption.copyWith(
                                color: AppColors.outline, fontSize: 12)),
                        Flexible(
                          child: Text(electionTitle,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Identitas / No. Urut',
                            style: AppTypography.caption.copyWith(
                                color: AppColors.outline, fontSize: 12)),
                        Text(nim,
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary900,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.pushNamed(
                                'admin-candidate-review',
                                pathParameters: {'id': candidateId},
                                extra: {
                                  'electionId': electionId,
                                  'isProposal': isProposal,
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.outlineVariant),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Lihat Berkas',
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primary900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: !isVerified
                              ? ElevatedButton(
                                  onPressed: () async {
                                    final success = await ref
                                        .read(adminCandidateVerificationProvider.notifier)
                                        .updateVerificationStatus(candidateId, true, isProposal: isProposal);
                                    if (context.mounted && success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('✅ Kandidat $name berhasil diverifikasi!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text('Setujui',
                                      style: AppTypography.bodyMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    final success = await ref
                                        .read(adminCandidateVerificationProvider.notifier)
                                        .updateVerificationStatus(candidateId, false, isProposal: isProposal);
                                    if (context.mounted && success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('⚠️ Verifikasi $name dibatalkan.'),
                                          backgroundColor: AppColors.errorRed,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.errorRed,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text('Batalkan',
                                      style: AppTypography.bodyMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            context.pushNamed(
                              'admin-candidate-review',
                              pathParameters: {'id': candidateId},
                              extra: {
                                'electionId': electionId,
                                'isProposal': isProposal,
                              },
                            );
                          },
                          tooltip: 'Tinjau Detail',
                          icon: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primary900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view, 'Overview', false, () {
                context.pushNamed('admin-dashboard');
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Elections', false, () {
                context.pushNamed('admin-proposals');
              }),
              _buildNavItem(Icons.people_outline, 'Voters', false, () {
                context.pushNamed('admin-candidate-manage');
              }),
              _buildNavItem(Icons.settings_outlined, 'Settings', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
