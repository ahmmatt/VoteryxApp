import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class ProposalTrackDetailScreen extends StatelessWidget {
  const ProposalTrackDetailScreen({super.key});

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
        title: Text('Status Pengajuan', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildStatusCard(),
            const SizedBox(height: AppSpacing.xl),
            
            Text(
              'Rincian Pengajuan',
              style: AppTypography.screenTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.md),
            
            _buildDetailsCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.warningAmber.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.warningAmber),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sedang Direview Admin',
                  style: AppTypography.captionBold.copyWith(color: AppColors.warningAmber, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Pemilihan Ketua HIMA TI 2026',
            style: AppTypography.screenTitle.copyWith(fontSize: 18, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Vertical Stepper
          _buildVerticalStepper(),
        ],
      ),
    );
  }

  Widget _buildVerticalStepper() {
    return Column(
      children: [
        _buildStepItem(
          title: 'Diajukan',
          subtitle: '14 Okt 2025, 09:30 WIB',
          isActive: true,
          isCompleted: true,
          isLast: false,
        ),
        _buildStepItem(
          title: 'Review Admin',
          subtitle: 'Sedang diperiksa oleh administrator terkait kelengkapan dokumen.',
          isActive: true,
          isCompleted: false,
          isLast: false,
        ),
        _buildStepItem(
          title: 'Disetujui',
          subtitle: 'Menunggu persetujuan.',
          isActive: false,
          isCompleted: false,
          isLast: false,
        ),
        _buildStepItem(
          title: 'Live / Berjalan',
          subtitle: 'Pemilihan siap dilaksanakan.',
          isActive: false,
          isCompleted: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    required bool isLast,
  }) {
    final color = isCompleted ? const Color(0xFF139971) : (isActive ? AppColors.warningAmber : AppColors.outline);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? color : (isActive ? color.withOpacity(0.1) : Colors.transparent),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: isCompleted ? 0 : 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : (isActive ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? color : AppColors.outlineVariant,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.itemTitle.copyWith(
                    color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _buildDetailRow('Tanggal Pengajuan', '14 Okt 2025, 09:30 WIB'),
          const Divider(height: 24, color: AppColors.outlineVariant),
          _buildDetailRow('Tujuan Pemilihan', 'Memilih ketua Himpunan Mahasiswa Teknik Informatika (HIMA TI) periode 2026/2027.'),
          const Divider(height: 24, color: AppColors.outlineVariant),
          _buildDetailRow('Penanggung Jawab', 'Ahmad Faris (Ketua Panitia)'),
          const Divider(height: 24, color: AppColors.outlineVariant),
          _buildDetailRow('Metode Pemilihan', 'Liquid Democracy (Delegasi Diizinkan)'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
