// lib/features/profile/presentation/screens/delegate_security_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ─────────────────── Model ─────────────────────────────────────────────────

class _SecurityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  /// Jika [activeBadge] true, tampilkan badge hijau "AKTIF".
  final bool activeBadge;
  final VoidCallback? onTap;

  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.activeBadge = false,
    this.onTap,
  });
}

// ─────────────────── Screen ────────────────────────────────────────────────

/// Layar Pusat Keamanan Akun — delegate dapat mengelola kata sandi,
/// melihat riwayat login, dan memantau enkripsi sesi.
class DelegateSecurityScreen extends StatelessWidget {
  const DelegateSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Shield Icon ──────────────────────────────────────────
            _buildShieldIcon(),
            const SizedBox(height: 20),

            // ── Page Title ───────────────────────────────────────────
            Text(
              'Pusat Keamanan Akun',
              style: AppTypography.displayHeading.copyWith(
                fontSize: 22,
                color: AppColors.primary900,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Kelola privasi dan akses akun Anda untuk\nmemastikan integritas partisipasi demokratis\nAnda.',
              style: AppTypography.bodyText.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Section: Kredensial & Akses ──────────────────────────
            _buildSectionHeader('KREDENSIAL & AKSES'),
            const SizedBox(height: 10),
            _buildMenuCard(items: [
              _SecurityItem(
                icon: Icons.key_outlined,
                title: 'Ubah Kata Sandi',
                subtitle: 'Terakhir diubah 3 bulan lalu',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),

            // ── Section: Aktivitas & Privasi ─────────────────────────
            _buildSectionHeader('AKTIVITAS & PRIVASI'),
            const SizedBox(height: 10),
            _buildMenuCard(items: [
              _SecurityItem(
                icon: Icons.laptop_mac_outlined,
                title: 'Riwayat Login',
                subtitle: '3 perangkat terhubung saat ini',
                onTap: () {},
              ),
              _SecurityItem(
                icon: Icons.shield_outlined,
                title: 'Enkripsi Sesi',
                subtitle: 'Enkripsi end-to-end aktif',
                activeBadge: true,
              ),
            ]),
            const SizedBox(height: AppSpacing.xl),

            // ── Info Banner ───────────────────────────────────────────
            _buildInfoBanner(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── AppBar ──────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Keamanan',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shield_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─────────────────── Shield Icon ─────────────────────────────────
  Widget _buildShieldIcon() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.goldMid.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.verified_user_rounded,
        color: Colors.white,
        size: 34,
      ),
    );
  }

  // ─────────────────── Section Header ──────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTypography.captionBold.copyWith(
          color: AppColors.textSecondary,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ─────────────────── Menu Card ────────────────────────────────────
  Widget _buildMenuCard({required List<_SecurityItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final hasNext = i < items.length - 1;
          return Column(
            children: [
              _SecurityTile(item: items[i]),
              if (hasNext)
                const Divider(
                  height: 1,
                  indent: 56,
                  color: Color(0xFFEEEFF4),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────── Info Banner ─────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEC),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFFFE594)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_rounded,
            color: AppColors.goldDark,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Delegate Portal menggunakan standar enkripsi AES-256 untuk melindungi semua data pemilihan Anda. Informasi pribadi Anda tidak akan pernah dibagikan kepada pihak ketiga.',
              style: AppTypography.caption.copyWith(
                color: AppColors.goldDark,
                fontSize: 12,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Security Tile ───────────────────────────────────────

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({required this.item});
  final _SecurityItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.activeBadge ? null : item.onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: AppColors.primary900,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing: badge AKTIF atau chevron
              if (item.activeBadge)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'AKTIF',
                    style: AppTypography.captionBold.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
