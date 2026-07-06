import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/user_bottom_nav_bar.dart';
import 'package:voteryxapp/core/router/app_router.dart';

import 'history_screen.dart';
import 'help_screen.dart';
import 'profile_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Profile', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppSpacing.lg),
            _buildStatsCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildMenuSection(context),
            const SizedBox(height: AppSpacing.xxl),
            _buildSecureBadge(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://ui-avatars.com/api/?name=Ahmad+Fauzi&background=random',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.primary800,
                    child: const Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.verified, color: AppColors.successTeal, size: 24),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Ahmad Fauzi', style: AppTypography.screenTitle),
        const SizedBox(height: 4),
        Text('Warga Terverifikasi • NIK **** **** **** 8901', style: AppTypography.bodyText),
        const SizedBox(height: 2),
        Text(
          'Mahasiswa: NIM 1202190045 • Fakultas Teknik Informatika',
          style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: _buildStatItem('BOBOT SUARA', '1')),
            Container(width: 1, height: 40, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            Expanded(child: _buildStatItem('DELEGASI', '0')),
            Container(width: 1, height: 40, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            Expanded(child: _buildStatItem('VERIFIKASI', 'Aktif', valueColor: AppColors.goldDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(label, style: AppTypography.captionBold),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.displayHeading.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.verified_user_outlined,
            title: 'Identitas Terverifikasi',
            iconColor: AppColors.successTeal,
            trailingIcon: Icons.check_circle_outline,
            trailingColor: AppColors.successTeal,
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.history,
            title: 'Riwayat Pemilihan',
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.manage_accounts_outlined,
            title: 'Pengaturan Profil',
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.switch_account_outlined,
            title: 'Beralih ke Mode Delegate',
            onTap: () {
              // Navigasi ke portal Delegate
              context.go('/delegation/home');
            },
          ),
          _buildMenuItem(
            icon: Icons.group_add_outlined,
            title: 'Usulan Pemilihan',
            onTap: () {
              context.pushNamed('proposal-status');
            },
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Keluar (Logout)',
            iconColor: AppColors.errorRed,
            trailingColor: AppColors.errorRed,
            onTap: () {
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    IconData? trailingIcon,
    Color? trailingColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          leading: Icon(icon, color: iconColor ?? AppColors.navyMid, size: 22),
          title: Text(title, style: AppTypography.itemTitle.copyWith(fontSize: 14)),
          trailing: Icon(
            trailingIcon ?? Icons.chevron_right,
            color: trailingColor ?? AppColors.textSecondary,
            size: 20,
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        ),
      ),
    );
  }

  Widget _buildSecureBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E9F7), // Light navy tint
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 14, color: AppColors.primary900),
          const SizedBox(width: AppSpacing.xs),
          Text('Certified Secure by Voteryx', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.shield_outlined, size: 14, color: AppColors.primary900),
        ],
      ),
    );
  }
}

