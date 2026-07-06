import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';
import '../widgets/election_summary_white_card.dart';

class ElectionInfoScreen extends StatelessWidget {
  const ElectionInfoScreen({super.key});

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
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Elections', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Election Summary White Card
            const ElectionSummaryWhiteCard(
              title: 'Pemilihan Ketua BEM 2026',
              participationPercentage: 0.62,
              votersCountText: '12,402 dari 20,000\nmahasiswa',
              countdownText: '02 : 14 : 45 : 12',
            ),
            const SizedBox(height: AppSpacing.xl),

            // 2. Deskripsi Pemilihan
            Text(
              'Deskripsi Pemilihan',
              style: AppTypography.itemTitle.copyWith(
                color: AppColors.primary800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Text(
                'Pemilihan Ketua Badan Eksekutif Mahasiswa (BEM) periode 2026/2027. Gunakan hak suara Anda secara langsung atau melalui delegasi untuk menentukan arah kebijakan kemahasiswaan satu tahun ke depan.',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 3. Informasi Penting
            Text(
              'Informasi Penting',
              style: AppTypography.itemTitle.copyWith(
                color: AppColors.primary800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _InfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Timeline',
              value: '15 Okt – 17 Okt 2025',
            ),
            const SizedBox(height: AppSpacing.sm),
            const _InfoCard(
              icon: Icons.account_balance_outlined,
              title: 'Penyelenggara',
              value: 'Sekretariat Negara Mahasiswa',
            ),
            const SizedBox(height: AppSpacing.sm),
            const _InfoCard(
              icon: Icons.account_tree_outlined,
              title: 'Metode',
              value: 'Liquid Democracy (Direct +\nDelegation)',
            ),
            const SizedBox(height: AppSpacing.xl),

            // 4. Aturan & Prosedur
            Text(
              'Aturan & Prosedur',
              style: AppTypography.itemTitle.copyWith(
                color: AppColors.primary800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: const Column(
                children: [
                  _RuleItem(
                    icon: Icons.verified_user_outlined,
                    text: 'Keamanan data terjamin melalui sistem audit independen.',
                  ),
                  Divider(height: 24, color: AppColors.outlineVariant),
                  _RuleItem(
                    icon: Icons.lock_outline,
                    text: 'Enkripsi end-to-end untuk menjaga kerahasiaan pilihan Anda.',
                  ),
                  Divider(height: 24, color: AppColors.outlineVariant),
                  _RuleItem(
                    icon: Icons.person_outline,
                    text: 'Prinsip 1-Student-1-Vote berlaku ketat melalui verifikasi biometrik.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // 5. Button
            GoldButton(
              label: 'Pilih Kandidat Sekarang',
              icon: Icons.chevron_right,
              onPressed: () {
                context.pushNamed('election', pathParameters: {'id': '1'});
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary800, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.goldDark, size: 18),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
