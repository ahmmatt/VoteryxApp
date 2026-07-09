import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminProposalCandidateListScreen extends StatelessWidget {
  const AdminProposalCandidateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Detail Kandidat Usulan',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildProgressSection(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Daftar Kandidat',
              style: AppTypography.screenTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCandidateCard(
              name: 'Ahmad Subarjo',
              faculty: 'Fakultas Ekonomi',
              isComplete: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildCandidateCard(
              name: 'Siti Rahma',
              faculty: 'Fakultas Ekonomi',
              isComplete: false,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildCandidateCard(
              name: 'Budi Santoso',
              faculty: 'Fakultas Ekonomi',
              isComplete: false,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildAddCandidateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFFFDF5),
                border: const Border(
                  left: BorderSide(color: AppColors.warningAmber, width: 3),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.warningAmber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '2 dari 3 kandidat belum melengkapi profil. Admin dapat memantau kelengkapan sebelum pemilihan dipublikasikan.',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kelengkapan Kandidat',
                  style: AppTypography.captionBold
                      .copyWith(color: AppColors.textPrimary)),
              Text('33%',
                  style: AppTypography.captionBold
                      .copyWith(color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.33,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4C464),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(
      {required String name,
      required String faculty,
      required bool isComplete}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary800.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primary800),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.itemTitle),
                Text(faculty,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isComplete
                  ? const Color(0xFFE8F6F2)
                  : const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                  color: isComplete
                      ? const Color(0xFFB5E3D8)
                      : const Color(0xFFF0D695)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isComplete ? Icons.check_circle : Icons.hourglass_bottom,
                  size: 12,
                  color: isComplete
                      ? const Color(0xFF139971)
                      : AppColors.warningAmber,
                ),
                const SizedBox(width: 4),
                Text(
                  isComplete ? 'Lengkap' : 'Menunggu',
                  style: AppTypography.captionBold.copyWith(
                    color: isComplete
                        ? const Color(0xFF139971)
                        : AppColors.warningAmber,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCandidateButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.primary800, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_outlined,
                  color: AppColors.primary800, size: 20),
              const SizedBox(width: 8),
              Text(
                'Verifikasi Kandidat',
                style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary800, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
