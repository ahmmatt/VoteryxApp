import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class AdminProposalTrackDetailScreen extends StatelessWidget {
  const AdminProposalTrackDetailScreen({super.key});

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
        title: Text('Detail Review Usulan',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildAdminSummaryCard(),
            const SizedBox(height: AppSpacing.xl),
            Text('Alur Review Admin',
                style: AppTypography.screenTitle.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            _buildStatusCard(),
            const SizedBox(height: AppSpacing.xl),
            Text('Rincian Pengajuan',
                style: AppTypography.screenTitle.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            _buildDetailsCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildReviewActions(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFDF9F0), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
              color: AppColors.goldMid.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.primary800,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.admin_panel_settings_outlined,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('VTX-7777',
                    style: AppTypography.captionBold
                        .copyWith(color: AppColors.goldDark)),
                Text('Pemilihan Ketua HIMA TI 2026',
                    style: AppTypography.screenTitle
                        .copyWith(fontSize: 18, height: 1.25)),
              ])),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(AppRadius.input),
              border:
                  Border.all(color: AppColors.warningAmber.withOpacity(0.28))),
          child: Row(children: [
            const Icon(Icons.rate_review_outlined,
                color: AppColors.warningAmber, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                    'Menunggu pemeriksaan kelengkapan dokumen dan validasi jadwal oleh admin.',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textPrimary, height: 1.4))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(children: [
        _buildStepItem(
            title: 'Diajukan',
            subtitle: '14 Okt 2025, 09:30 WIB oleh Ahmad Faris.',
            isActive: true,
            isCompleted: true,
            isLast: false),
        _buildStepItem(
            title: 'Review Admin',
            subtitle:
                'Periksa tujuan, jadwal, panitia, metode, dan dokumen pendukung.',
            isActive: true,
            isCompleted: false,
            isLast: false),
        _buildStepItem(
            title: 'Disetujui',
            subtitle: 'Usulan dapat dilanjutkan ke pelengkapan kandidat.',
            isActive: false,
            isCompleted: false,
            isLast: false),
        _buildStepItem(
            title: 'Live / Berjalan',
            subtitle: 'Pemilihan siap dipublikasikan ke pemilih.',
            isActive: false,
            isCompleted: false,
            isLast: true),
      ]),
    );
  }

  Widget _buildStepItem(
      {required String title,
      required String subtitle,
      required bool isActive,
      required bool isCompleted,
      required bool isLast}) {
    final color = isCompleted
        ? AppColors.successTeal
        : (isActive ? AppColors.warningAmber : AppColors.outline);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: isCompleted
                  ? color
                  : (isActive ? color.withOpacity(0.12) : Colors.transparent),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: isCompleted ? 0 : 2)),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : isActive
                  ? Center(
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle)))
                  : null,
        ),
        if (!isLast)
          Container(
              width: 2,
              height: 44,
              color: isCompleted ? color : AppColors.outlineVariant),
      ]),
      const SizedBox(width: AppSpacing.md),
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTypography.itemTitle.copyWith(
                  color: isActive || isCompleted
                      ? AppColors.textPrimary
                      : AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary, height: 1.4)),
        ]),
      )),
    ]);
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(children: [
        _buildDetailRow('Tanggal Pengajuan', '14 Okt 2025, 09:30 WIB'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Pengusul', 'Ahmad Faris — Ketua Panitia'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Tujuan Pemilihan',
            'Memilih ketua Himpunan Mahasiswa Teknik Informatika periode 2026/2027.'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow(
            'Metode Pemilihan', 'Liquid Democracy (Delegasi Diizinkan)'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Catatan Admin',
            'Dokumen proposal lengkap. Perlu validasi konflik jadwal akademik.'),
      ]),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child: Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary))),
      Expanded(
          flex: 3,
          child: Text(value,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.right)),
    ]);
  }

  Widget _buildReviewActions() {
    return Row(children: [
      Expanded(
          child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Tolak'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                  side: const BorderSide(color: AppColors.errorRed)))),
      const SizedBox(width: AppSpacing.md),
      Expanded(
          child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check, size: 18, color: Colors.white),
              label: const Text('Setujui'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  foregroundColor: Colors.white))),
    ]);
  }
}
