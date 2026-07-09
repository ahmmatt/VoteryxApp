import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class AdminCandidateReviewScreen extends StatelessWidget {
  const AdminCandidateReviewScreen({super.key});

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
            onPressed: () => context.pop()),
        title: Text('Tinjau Kandidat',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildProfileCard(),
            const SizedBox(height: AppSpacing.xl),
            Text('Checklist Verifikasi',
                style: AppTypography.screenTitle.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            _buildChecklistCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildDecisionCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFDF9F0)],
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
                color: AppColors.navy600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.person,
                color: AppColors.textSecondary, size: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Arjuna Pratama',
                    style: AppTypography.screenTitle
                        .copyWith(fontSize: 18, color: AppColors.primary900)),
                const SizedBox(height: 4),
                Text('Fakultas Teknik • NIM 2021001234',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ])),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _buildInfoRow('Pemilihan', 'Pemilihan Ketua BEM 2026'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildInfoRow('Diajukan', '2 Jam Lalu'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildInfoRow('Status', 'Menunggu Review Admin'),
      ]),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child: Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary))),
      Expanded(
          flex: 3,
          child: Text(value,
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900, fontWeight: FontWeight.w600))),
    ]);
  }

  Widget _buildChecklistCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(children: [
        _buildChecklistItem('Identitas mahasiswa valid', true),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Berkas pendaftaran lengkap', true),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Visi & misi sudah diunggah', true),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Tidak ada konflik kelayakan', false),
      ]),
    );
  }

  Widget _buildChecklistItem(String title, bool checked) {
    return Row(children: [
      Icon(checked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: checked ? AppColors.successTeal : AppColors.outline, size: 20),
      const SizedBox(width: 10),
      Expanded(
          child: Text(title,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.primary900))),
    ]);
  }

  Widget _buildDecisionCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Keputusan Admin',
            style:
                AppTypography.itemTitle.copyWith(color: AppColors.primary900)),
        const SizedBox(height: AppSpacing.sm),
        Text(
            'Berikan keputusan setelah memastikan seluruh checklist dan dokumen kandidat valid.',
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary, height: 1.45)),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Tolak'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(color: AppColors.errorRed),
                      padding: const EdgeInsets.symmetric(vertical: 12)))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check, size: 18, color: Colors.white),
                  label: const Text('Setujui'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldMid,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12)))),
        ]),
      ]),
    );
  }
}
