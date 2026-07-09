// lib/features/delegates/profile/presentation/screens/delegate_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'delegate_edit_bio_screen.dart';
import 'delegate_update_skills_screen.dart';
import 'delegate_track_record_screen.dart';
import 'delegate_security_screen.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_dashboard_provider.dart';

const Color _teal = Color(0xFF10B981);

/// Layar Profil Delegate — menampilkan informasi profil, performa, dan
/// pengaturan akun secara dinamis dari database (Supabase).
class DelegateProfileScreen extends ConsumerWidget {
  const DelegateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Navy Header (non-scrollable) ───────────────────────────
          _DelegateProfileHeader(context: context),

          // ── Scrollable Content ─────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userProfileProvider);
                ref.invalidate(delegateDashboardProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner kelengkapan profil (jika belum lengkap)
                    const _ProfileCompletenessCard(),
                    // Performa Delegate card
                    const _PerformaCard(),
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
                      logoutItem: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Version footer
                    Center(
                      child: Text(
                        'Delegate Portal v2.4.0 (Live Build)',
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
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Completeness Banner
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCompletenessCard extends ConsumerWidget {
  const _ProfileCompletenessCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    if (profile == null) return const SizedBox.shrink();

    final isComplete = profile.isDelegateProfileComplete;
    if (isComplete) return const SizedBox.shrink();

    // Hitung apa yang masih kurang
    final missing = <String>[];
    if (profile.delegateBio == null || profile.delegateBio!.trim().isEmpty) {
      missing.add('Bio');
    }
    if (profile.delegateVision == null || profile.delegateVision!.trim().isEmpty) {
      missing.add('Visi');
    }
    if (profile.delegateSkills == null || profile.delegateSkills!.isEmpty) {
      missing.add('Keahlian');
    }
    if (profile.delegateTrackRecords == null || profile.delegateTrackRecords!.isEmpty) {
      missing.add('Track Record');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFFFB74D).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Belum Lengkap',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFFE65100),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mandator tidak bisa mendelegasikan suara sebelum kamu mengisi: ${missing.join(', ')}.',
                  style: AppTypography.caption.copyWith(
                    color: const Color(0xFFBF360C),
                    height: 1.4,
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

// ─────────────────────────────────────────────────────────────────────────────
// Navy Header — tanpa tombol Edit di pojok kanan atas
// ─────────────────────────────────────────────────────────────────────────────

class _DelegateProfileHeader extends ConsumerWidget {
  const _DelegateProfileHeader({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.valueOrNull;

    final name = profile?.fullName ?? 'Delegator';
    final subtitle = profile != null && (profile.faculty != null || profile.major != null)
        ? '${profile.faculty ?? "Fakultas"} • ${profile.major ?? "Program Studi"}'
        : 'Delegator Terverifikasi';
    final avatarUrl = profile?.avatarUrl;

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
              // ── AppBar Row — NO Edit button ────────────────────────
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
                  // Tombol Edit DIHAPUS
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
                      border: Border.all(color: AppColors.goldMid, width: 2),
                      color: AppColors.primary900,
                      image: avatarUrl != null && avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                          ? DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: avatarUrl == null || !avatarUrl.startsWith('http')
                        ? const Icon(Icons.person, color: AppColors.goldMid, size: 36)
                        : null,
                  ),
                  // Badge edit kecil tetap ada untuk tap ke edit bio
                  GestureDetector(
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (_) => const DelegateEditBioScreen()),
                    ),
                    child: Container(
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
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Name ─────────────────────────────────────────────────
              Text(
                name,
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),

              // ── Stats Card ───────────────────────────────────────────
              const _StatsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Card — Rating dihitung dari execution rate (bukan hardcoded 4.9)
// ─────────────────────────────────────────────────────────────────────────────

class _StatsCard extends ConsumerWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(delegateDashboardProvider);
    final data = dashboardAsync.valueOrNull ?? const DelegateDashboardData();

    // Rating: skala 0–5 dari execution rate (0–100%)
    // Semakin banyak eksekusi tepat waktu → rating naik
    // Jika belum pernah eksekusi → 0
    final double ratingRaw = data.executionRate > 0
        ? (data.executionRate / 100 * 5.0).clamp(0.0, 5.0)
        : 0.0;
    final String ratingStr = data.executionRate > 0
        ? ratingRaw.toStringAsFixed(1)
        : '0';

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
                value: '${data.mandates.where((m) => m.status == "active").length}',
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
                value: '${data.executionHistory.where((h) => h.status == "Selesai").length}',
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
                value: ratingStr,
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
// Performa Delegate Card — hanya Execution Rate, TANPA Trust Score
// ─────────────────────────────────────────────────────────────────────────────

class _PerformaCard extends ConsumerWidget {
  const _PerformaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(delegateDashboardProvider);
    final data = dashboardAsync.valueOrNull ?? const DelegateDashboardData();

    // Execution Rate = jumlah pemilihan yg sudah dieksekusi / total pemilihan
    final executionRatePercent = data.executionRate.round();

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

          // Execution Rate ONLY — Trust Score dihapus
          _PerformaRow(
            label: 'Execution Rate',
            sublabel: executionRatePercent == 0
                ? 'Belum ada eksekusi suara'
                : '$executionRatePercent% pemilihan berhasil dieksekusi',
            value: (executionRatePercent / 100).clamp(0.0, 1.0),
            valueText: '$executionRatePercent%',
            color: executionRatePercent >= 80 ? _teal : AppColors.goldDark,
          ),
          const SizedBox(height: 10),

          // Info card kelengkapan profil
          Consumer(builder: (context, ref, _) {
            final profile = ref.watch(userProfileProvider).valueOrNull;
            final isComplete = profile?.isDelegateProfileComplete ?? false;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isComplete
                    ? _teal.withValues(alpha: 0.08)
                    : AppColors.goldMid.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isComplete ? Icons.check_circle : Icons.info_outline,
                    size: 16,
                    color: isComplete ? _teal : AppColors.goldDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isComplete
                          ? 'Profil lengkap — mandator dapat mendelegasikan suara kepadamu'
                          : 'Lengkapi profil agar mandator bisa mendelegasikan suara',
                      style: AppTypography.caption.copyWith(
                        color: isComplete ? _teal : AppColors.goldDark,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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
    this.sublabel,
  });
  final String label;
  final double value;
  final String valueText;
  final Color color;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyText.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                if (sublabel != null)
                  Text(
                    sublabel!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.outline,
                      fontSize: 10,
                    ),
                  ),
              ],
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
            backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.35),
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
                if (items.isNotEmpty)
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFF0F1F5),
                  ),
                const _LogoutTile(),
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
