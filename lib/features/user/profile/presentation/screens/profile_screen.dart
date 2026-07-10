// lib/features/user/profile/presentation/screens/profile_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/router/app_router.dart';

import '../providers/profile_provider.dart';
import 'history_screen.dart';
import 'help_screen.dart';
import 'profile_settings_screen.dart';
import 'package:voteryxapp/features/user/notifications/presentation/widgets/notifications_modal.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_application_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profil Saya',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            tooltip: 'Notifikasi',
            onPressed: () {
              showNotificationsModal(context, ref);
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(
                name: profile?.fullName ?? 'Pengguna Voteryx',
                faculty: profile?.faculty ?? '',
                kycStatus: profile?.kycStatus ?? 'pending',
                avatarUrl: profile?.avatarUrl,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildMenuSection(context, ref),
              const SizedBox(height: AppSpacing.xxl),
              _buildSecureBadge(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goldMid),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off_outlined, size: 48, color: AppColors.outline),
              const SizedBox(height: AppSpacing.md),
              Text('Gagal memuat profil', style: AppTypography.bodyMedium),
              TextButton(
                onPressed: () => ref.invalidate(userProfileProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.primary800,
      child: Center(
        child: Text(
          name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?',
          style: AppTypography.displayHeading.copyWith(
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader({
    required String name,
    required String faculty,
    required String kycStatus,
    String? avatarUrl,
  }) {
    // Tentukan ImageProvider berdasarkan tipe URL: Base64 data URI, network URL, atau fallback inisial
    final cleanUrl = (avatarUrl != null && avatarUrl.trim().isNotEmpty) ? avatarUrl.trim() : null;
    ImageProvider? imageProvider;
    if (cleanUrl != null) {
      if (cleanUrl.startsWith('data:image')) {
        try {
          final base64Str = cleanUrl.split(',').last;
          imageProvider = MemoryImage(base64Decode(base64Str));
        } catch (_) {
          imageProvider = null;
        }
      } else if (cleanUrl.startsWith('http')) {
        imageProvider = NetworkImage(cleanUrl);
      }
    }

    return Container(
      width: double.infinity,
      color: AppColors.primary800,
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.xxl,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
      ),
      child: Column(
        children: [
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
                  child: imageProvider != null
                      ? Image(
                          image: imageProvider,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(name),
                        )
                      : _buildAvatarFallback(name),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: Icon(
                  kycStatus == 'verified'
                      ? Icons.verified
                      : Icons.pending_outlined,
                  color: kycStatus == 'verified'
                      ? AppColors.successTeal
                      : AppColors.warningAmber,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTypography.displayHeading.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kycStatus == 'verified'
                ? 'Warga Terverifikasi · Pemilih Aktif'
                : 'Menunggu Verifikasi KYC',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
          if (faculty.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              faculty,
              style: AppTypography.captionBold.copyWith(
                color: AppColors.goldMid,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
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
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.assignment_ind_outlined,
            title: 'Masuk ke Portal Delegasi',
            onTap: () {
              final profile = ref.read(userProfileProvider).valueOrNull;
              final applications = ref.read(delegateApplicationProvider);
              final myApp = applications.where((a) =>
                  (profile?.nim != null && profile!.nim!.isNotEmpty && a.nim == profile.nim) ||
                  (profile?.fullName != null && a.name.trim().toLowerCase() == profile!.fullName.trim().toLowerCase())
              ).firstOrNull;

              final isApproved = (profile?.role == 'delegate') ||
                  (myApp?.status == DelegateApplicationStatus.approved);

              final isPending = (profile?.role != 'delegate' &&
                      (profile?.isDelegateProfilePublic == true ||
                          (profile?.delegateBio != null && profile!.delegateBio!.isNotEmpty))) ||
                  (myApp?.status == DelegateApplicationStatus.pending);

              if (isApproved) {
                context.pushNamed('delegate-home');
              } else if (isPending) {
                context.pushNamed('delegate-review');
              } else {
                context.pushNamed('delegate-terms');
              }
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
            title: 'Keluar',
            iconColor: AppColors.errorRed,
            trailingColor: AppColors.errorRed,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Keluar dari Voteryx?',
                    style: AppTypography.cardTitle,
                  ),
                  content: Text(
                    'Kamu akan keluar dari sesi ini. Pastikan kamu sudah menyimpan semua perubahan.',
                    style: AppTypography.bodyText,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        'Keluar',
                        style: TextStyle(color: AppColors.errorRed),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await ref.read(userProfileProvider.notifier).signOut();
                if (context.mounted) context.go(AppRoutes.login);
              }
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
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          leading: Icon(icon, color: iconColor ?? AppColors.navyMid, size: 22),
          title: Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            trailingIcon ?? Icons.chevron_right,
            color: trailingColor ?? AppColors.textSecondary,
            size: 20,
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSecureBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E9F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 14, color: AppColors.primary900),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Certified Secure by Voteryx',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.primary900,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.shield_outlined,
            size: 14,
            color: AppColors.primary900,
          ),
        ],
      ),
    );
  }
}
