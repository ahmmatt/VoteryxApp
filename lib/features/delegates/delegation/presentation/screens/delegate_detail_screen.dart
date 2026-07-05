import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

import '../../../../user/delegation/presentation/screens/delegation_receipt_screen.dart';

class DelegateDetailScreen extends StatelessWidget {
  const DelegateDetailScreen({super.key});

  // MOCK: Toggle jika user saat ini adalah seorang Delegate aktif (mencegah loop delegasi)
  final bool isDelegate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Detail Delegasi', style: AppTypography.headerTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    const Icon(Icons.show_chart, color: AppColors.navyMid, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Riwayat Pencapaian', style: AppTypography.cardTitle),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTimeline(),
                const SizedBox(height: AppSpacing.lg),
                _buildTermsCard(),
                const SizedBox(height: 100), // padding for bottom button
              ],
            ),
          ),
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: GoldButton(
              label: isDelegate ? 'Terkunci (Anda seorang Delegate)' : 'Delegasikan Suara ke Ahmad ->',
              onPressed: isDelegate ? null : () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const DelegationReceiptScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEDF), // Approximate gold-ish light background
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: const LinearGradient(
          colors: [Color(0xFFF3EEDF), Color(0xFFEBE2CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary900,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: AppTypography.displayHeading.copyWith(color: Colors.white, fontSize: 36),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEBE2CD),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.verified, color: AppColors.goldMid, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Ahmad Rizki', style: AppTypography.screenTitle),
          const SizedBox(height: 4),
          Text('Student Leader • Political Science', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.goldMid.withOpacity(0.2)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Suara', '47'),
              Container(width: 1, height: 30, color: AppColors.goldMid.withOpacity(0.2)),
              _buildStatItem('Aktif', '2 Thn'),
              Container(width: 1, height: 30, color: AppColors.goldMid.withOpacity(0.2)),
              _buildStatItem('Akurasi', '96%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTypography.captionBold),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.screenTitle.copyWith(fontSize: 20)),
      ],
    );
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            icon: Icons.school,
            date: 'Januari 2025 - Sekarang',
            title: 'Ketua BEM Universitas',
            description: 'Memimpin aspirasi 15.000 mahasiswa dengan transparansi kebijakan 100%.',
            isLast: false,
          ),
          _buildTimelineItem(
            icon: Icons.how_to_vote,
            date: 'Maret 2024',
            title: 'Delegator Voteryx Terverifikasi',
            description: 'Bergabung sebagai perwakilan suara mahasiswa tingkat fakultas.',
            isLast: false,
          ),
          _buildTimelineItem(
            icon: Icons.military_tech,
            date: '2023',
            title: 'Finalis Kompetisi Debat Nasional',
            description: 'Menganalisis kebijakan publik dalam skala makro dan mikro.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required IconData icon, required String date, required String title, required String description, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: AppColors.textSecondary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: AppColors.outlineVariant.withOpacity(0.5),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                  const SizedBox(height: 4),
                  Text(title, style: AppTypography.itemTitle),
                  const SizedBox(height: 4),
                  Text(description, style: AppTypography.bodyText.copyWith(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border(
          left: BorderSide(color: AppColors.warningAmber, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: AppColors.warningAmber, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ketentuan Delegasi', style: AppTypography.itemTitle),
                const SizedBox(height: 4),
                Text(
                  'Suara Anda akan mewakili pilihan Ahmad Rizki dalam setiap pemungutan suara mendatang. Anda dapat membatalkan delegasi ini kapan saja sebelum pemungutan suara dimulai.',
                  style: AppTypography.bodyText.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
