import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Riwayat', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aktivitas Suara', style: AppTypography.cardTitle.copyWith(color: AppColors.navyMid, fontSize: 16)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Daftar partisipasi pemilihan Anda yang tercatat secara aman di blockchain.',
              style: AppTypography.bodyText,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            _buildHistoryCard(
              badgeText: 'Terverifikasi',
              badgeColor: AppColors.successBg,
              badgeTextColor: const Color(0xFF0F6E56),
              date: '12 Okt 2026 • 10:45',
              title: 'Pemilihan Ketua BEM 2026',
              subtitleLabel: 'KANDIDAT PILIHAN',
              subtitleValue: 'Arya Wiguna & Siti Aminah',
              leadingWidget: ClipOval(
                child: Image.network(
                  'https://ui-avatars.com/api/?name=Arya+Wiguna&background=random',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 36,
                    height: 36,
                    color: AppColors.primary800,
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
              actionIcon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: AppSpacing.md),
            
            _buildHistoryCard(
              badgeText: 'Didelegasikan',
              badgeColor: AppColors.warningBg,
              badgeTextColor: AppColors.goldDark,
              date: '05 Sep 2025 • 14:20',
              title: 'Ketua HIMA Informatika 2025',
              subtitleLabel: 'DELEGASI MELALUI',
              subtitleValue: 'Dewan Perwakilan Mahasiswa',
              leadingWidget: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0EBE1),
                ),
                child: const Icon(Icons.people, color: AppColors.goldDark, size: 20),
              ),
              actionIcon: Icons.receipt_long_outlined,
            ),
            const SizedBox(height: AppSpacing.md),
            
            _buildHistoryCard(
              badgeText: 'Terverifikasi',
              badgeColor: const Color(0xFF6DF0B6), // Approximate bright green from design
              badgeTextColor: const Color(0xFF0F6E56),
              date: '12 Jun 2025 • 09:12',
              title: 'Referendum Fasilitas Kampus',
              subtitleLabel: 'OPSI PILIHAN',
              subtitleValue: 'Setuju: Renovasi Student Center',
              leadingWidget: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE4E9F7),
                ),
                child: const Icon(Icons.view_list_outlined, color: AppColors.navyMid, size: 20),
              ),
              actionIcon: Icons.remove_red_eye_outlined,
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String date,
    required String title,
    required String subtitleLabel,
    required String subtitleValue,
    required Widget leadingWidget,
    required IconData actionIcon,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.captionBold.copyWith(color: badgeTextColor, fontSize: 12),
                ),
              ),
              Text(date, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leadingWidget,
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitleLabel, style: AppTypography.captionBold),
                    const SizedBox(height: 2),
                    Text(subtitleValue, style: AppTypography.itemTitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(actionIcon, size: 16, color: AppColors.goldDark),
                  const SizedBox(width: 4),
                  Text('Lihat Bukti', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
