// lib/features/profile/presentation/screens/delegate_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/router/app_router.dart';
import 'delegate_edit_bio_screen.dart';
import 'delegate_update_skills_screen.dart';
import 'delegate_track_record_screen.dart';
import 'delegate_help_screen.dart';
import 'delegate_notifications_screen.dart';
import 'delegate_security_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const Color _teal = Color(0xFF10B981);

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Layar Profil Saya (Role: Delegate)
///
/// Layout:
///  ┌─ Navy Header ───────────────────────────────┐
///  │  AppBar row (back arrow + title + "Edit")   │
///  │  Avatar (circular photo + gold edit badge)  │
///  │  Name & subtitle                            │
///  │  Stats card (1.2k | 15 | 4.9)              │
///  └─────────────────────────────────────────────┘
///  ┌─ Scrollable Body ───────────────────────────┐
///  │  Performa Delegate card                     │
///  │  Pengaturan Profil section                  │
///  │  Akun & Keamanan section                    │
///  │  Version footer                             │
///  └─────────────────────────────────────────────┘
///  Bottom Navigation Bar
class DelegateProfileScreen extends StatelessWidget {
  const DelegateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Navy Header (non-scrollable) ───────────────────────────
          _DelegateProfileHeader(context: context),

          // ── Scrollable Content ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performa Delegate card
                  _PerformaCard(),
                  const SizedBox(height: AppSpacing.lg),

                  // Pengaturan Profil
                  _MenuSection(
                    title: 'Pengaturan Profil',
                    items: [
                      _MenuItem(
                        icon: Icons.edit_outlined,
                        label: 'Edit Bio & Visi',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) => const DelegateEditBioScreen()),
                        ),
                      ),
                      _MenuItem(
                        icon: Icons.psychology_outlined,
                        label: 'Update Keahlian',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  const DelegateUpdateSkillsScreen()),
                        ),
                      ),
                      _MenuItem(
                        icon: Icons.history_edu_outlined,
                        label: 'Kelola Track Record',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  const DelegateTrackRecordScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Akun & Keamanan
                  _MenuSection(
                    title: 'Akun & Keamanan',
                    items: [
                      _MenuItem(
                        icon: Icons.shield_outlined,
                        label: 'Security',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) => const DelegateSecurityScreen()),
                        ),
                      ),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  const DelegateNotificationsScreen()),
                        ),
                      ),
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Help',
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (_) => const DelegateHelpScreen()),
                        ),
                      ),
                    ],
                    logoutItem: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Version footer
                  Center(
                    child: Text(
                      'Delegate Portal v2.4.0 (Alpha Build)',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.outline,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Navy Header
// ─────────────────────────────────────────────────────────────────────────────

class _DelegateProfileHeader extends StatelessWidget {
  const _DelegateProfileHeader({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: AppColors.primary800,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            6,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── AppBar Row ───────────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Profil Saya',
                      style: AppTypography.headerTitle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Edit',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Avatar ───────────────────────────────────────────────
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.goldMid, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://i.pravatar.cc/150?img=15'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 10),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Name ─────────────────────────────────────────────────
              Text(
                'Aditya Dharmawan',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Fakultas Teknik • Angkatan 2021',
                style: AppTypography.caption.copyWith(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),

              // ── Stats Card (inside header, dark navy pill) ───────────
              _StatsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Card
// ─────────────────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                value: '1.2k',
                label: 'Mandat',
                valueColor: AppColors.goldMid,
              ),
            ),
            VerticalDivider(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _StatItem(
                value: '15',
                label: 'Eksekusi',
                valueColor: AppColors.goldMid,
              ),
            ),
            VerticalDivider(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _StatItem(
                value: '4.9',
                label: 'Rating',
                valueColor: AppColors.goldMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.valueColor,
  });
  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.displayHeading.copyWith(
              fontSize: 18,
              color: valueColor ?? Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.captionBold.copyWith(
              color: Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Performa Delegate Card
// ─────────────────────────────────────────────────────────────────────────────

class _PerformaCard extends StatelessWidget {
  const _PerformaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performa Delegate',
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.goldDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.goldDark,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Trust Score
          _PerformaRow(
            label: 'Trust Score',
            value: 0.78,
            valueText: '78%',
            color: AppColors.goldMid,
          ),
          const SizedBox(height: 14),

          // Execution Rate
          _PerformaRow(
            label: 'Execution Rate',
            value: 0.96,
            valueText: '96%',
            color: _teal,
          ),
        ],
      ),
    );
  }
}

class _PerformaRow extends StatelessWidget {
  const _PerformaRow({
    required this.label,
    required this.value,
    required this.valueText,
    required this.color,
  });
  final String label;
  final double value;
  final String valueText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.bodyText.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              valueText,
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 7,
            backgroundColor:
                AppColors.outlineVariant.withValues(alpha: 0.35),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu Section
// ─────────────────────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.title,
    required this.items,
    this.logoutItem = false,
  });
  final String title;
  final List<_MenuItem> items;
  final bool logoutItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Text(
          title,
          style: AppTypography.cardTitle.copyWith(
            color: AppColors.primary900,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        // Menu card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Regular items with dividers
              ...List.generate(items.length, (i) {
                final isLast = i == items.length - 1 && !logoutItem;
                return Column(
                  children: [
                    _MenuTile(item: items[i]),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0xFFF0F1F5),
                      ),
                  ],
                );
              }),

              // Logout item
              if (logoutItem) ...[
                const Divider(
                  height: 1,
                  indent: 52,
                  color: Color(0xFFF0F1F5),
                ),
                _LogoutTile(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});
  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: AppColors.primary900,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
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

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Logout delegate harus kembali ke halaman login role user,
          // bukan ke halaman login delegate. `go` mengganti lokasi aktif
          // sehingga user tidak kembali ke profil delegate via tombol back.
          context.go(AppRoutes.login);
        },
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                'Logout',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────

class _DelegateBottomNavBar extends StatelessWidget {
  const _DelegateBottomNavBar({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Beranda',
                isSelected: false,
                onTap: () => context.pushNamed('delegate-home'),
              ),
              _NavItem(
                icon: Icons.gavel_outlined,
                label: 'Mandat',
                isSelected: false,
                onTap: () => context.pushNamed('delegate-dashboard'),
              ),
              _NavItem(
                icon: Icons.how_to_vote_outlined,
                label: 'Eksekusi',
                isSelected: false,
                onTap: () => context.pushNamed('delegate-history'),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profil',
                isSelected: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.goldDark : AppColors.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? AppColors.goldDark : AppColors.textSecondary,
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
