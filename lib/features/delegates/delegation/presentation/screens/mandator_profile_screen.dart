// lib/features/delegates/delegation/presentation/screens/mandator_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class MandatorProfileScreen extends StatelessWidget {
  final String name;
  final String nim;
  final String faculty;
  final String status;
  final Color statusColor;
  final int votes;
  final bool isRevoked;
  final String imageUrl;

  const MandatorProfileScreen({
    super.key,
    required this.name,
    required this.nim,
    required this.faculty,
    required this.status,
    required this.statusColor,
    required this.votes,
    this.isRevoked = false,
    required this.imageUrl,
  });

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
        title: Text('Profil Mandator', style: AppTypography.headerTitle),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildProfileCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildDelegationInfoCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildDelegationHistoryCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isRevoked ? AppColors.outlineVariant : AppColors.goldMid.withOpacity(0.4),
                width: 2.5,
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: isRevoked
                    ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Name
          Text(
            name,
            style: AppTypography.screenTitle.copyWith(
              decoration: isRevoked ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.textSecondary,
              color: isRevoked ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nim,
            style: AppTypography.captionBold.copyWith(color: AppColors.outline, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            faculty,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Status row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isRevoked ? Colors.red.withOpacity(0.06) : statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isRevoked ? Colors.red : statusColor).withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRevoked ? Colors.red : statusColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isRevoked ? 'Mandat Dicabut' : 'Status: $status',
                  style: AppTypography.captionBold.copyWith(
                    color: isRevoked ? Colors.red : statusColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelegationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_outlined, color: AppColors.goldDark, size: 20),
              const SizedBox(width: 8),
              Text(
                'Informasi Delegasi',
                style: AppTypography.cardTitle.copyWith(color: AppColors.primary900),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.md),

          _buildInfoRow('Bobot Suara', '$votes suara didelegasikan'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Tanggal Delegasi', '10 Jun 2026'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Berlaku Hingga', 'Pemilihan Ketua BEM 2026'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Metode', 'Liquid Democracy'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDelegationHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, color: AppColors.goldDark, size: 20),
              const SizedBox(width: 8),
              Text(
                'Riwayat Suara yang Didelegasikan',
                style: AppTypography.cardTitle.copyWith(color: AppColors.primary900),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildHistoryItem(
            title: 'Ketua BEM UI 2026',
            date: 'Jun 2026',
            result: 'Menunggu',
            resultColor: AppColors.warningAmber,
            isLast: false,
          ),
          _buildHistoryItem(
            title: 'HIMA Teknik 2025',
            date: 'Des 2025',
            result: 'Berhasil',
            resultColor: const Color(0xFF10B981),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String result,
    required Color resultColor,
    required bool isLast,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.how_to_vote_rounded, size: 18, color: resultColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
                Text(date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              result,
              style: AppTypography.captionBold.copyWith(color: resultColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
