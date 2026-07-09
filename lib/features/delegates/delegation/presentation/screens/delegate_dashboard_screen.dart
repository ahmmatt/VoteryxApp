// lib/features/delegates/delegation/presentation/screens/delegate_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_dashboard_provider.dart';

/// Layar Manajemen Mandat — menampilkan total bobot suara,
/// daftar mandator beserta statusnya, dan tombol eksekusi secara dinamis dari database.
class DelegateDashboardScreen extends ConsumerStatefulWidget {
  const DelegateDashboardScreen({super.key});

  @override
  ConsumerState<DelegateDashboardScreen> createState() =>
      _DelegateDashboardScreenState();
}

class _DelegateDashboardScreenState extends ConsumerState<DelegateDashboardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(delegateDashboardProvider);
    final data = dashboardAsync.valueOrNull ?? const DelegateDashboardData();

    final allMandates = data.mandates;
    final activeCount = allMandates.where((m) => m.status == 'active').length;
    final pendingCount = allMandates.where((m) => m.status == 'pending').length;

    final tabs = [
      'Semua (${allMandates.length})',
      'Aktif ($activeCount)',
      'Menunggu ($pendingCount)',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      bottomNavigationBar: _buildBottomNav(context),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(gradient: AppColors.pageGradient),
          ),
          // Scrollable content
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(delegateDashboardProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: 100, // Space for pinned bottom button
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalSuaraCard(data),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTabBar(tabs),
                  const SizedBox(height: AppSpacing.xl),
                  _buildMandatorList(allMandates),
                ],
              ),
            ),
          ),
          // Pinned bottom CTA button
          _buildPinnedButton(data),
        ],
      ),
    );
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Manajemen Mandat',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  // ──────────────────── Total Bobot Suara Card ────────────────────
  Widget _buildTotalSuaraCard(DelegateDashboardData data) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5EDD5), Color(0xFFEDD9A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldMid.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL BOBOT SUARA',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.goldDark,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data.totalVotesHeld}',
                      style: AppTypography.displayHeading.copyWith(
                        fontSize: 52,
                        height: 1.0,
                        color: AppColors.primary900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Delegasi Terverifikasi',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Progress bar + label
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (data.trustScore / 100).clamp(0.1, 1.0),
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.goldDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      data.urgentElectionTitle ?? 'Ketua BEM\n2026',
                      style: AppTypography.captionBold.copyWith(
                        fontSize: 10,
                        color: AppColors.goldDark,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Trust circle
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldDark, width: 3.5),
              color: Colors.transparent,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TRUST',
                    style: AppTypography.captionBold.copyWith(
                      fontSize: 9,
                      color: AppColors.primary900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${data.trustScore.round()}%',
                    style: AppTypography.displayHeading.copyWith(
                      fontSize: 18,
                      color: AppColors.primary900,
                      height: 1.1,
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

  // ─────────────────────────── Tab Bar ───────────────────────────
  Widget _buildTabBar(List<String> tabs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == _selectedTab;
          return Padding(
            padding: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.goldMid : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.outlineVariant,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.goldMid.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tabs[i],
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────── Mandator List ────────────────────────────
  Widget _buildMandatorList(List<DelegateMandateItem> allMandates) {
    // 0: Semua, 1: Aktif, 2: Menunggu
    final filteredData = allMandates.where((m) {
      if (_selectedTab == 0) return true;
      if (_selectedTab == 1) return m.status == 'active';
      if (_selectedTab == 2) return m.status == 'pending';
      return true;
    }).toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('Tidak ada data mandator untuk tab ini'),
        ),
      );
    }

    return Column(
      children: filteredData.map((data) {
        String statusText = 'Aktif';
        Color statusColor = const Color(0xFF10B981);
        bool isRevoked = false;

        if (data.status == 'revoked') {
          statusText = 'Mandat telah ditarik oleh pemberi';
          statusColor = Colors.red;
          isRevoked = true;
        } else if (data.status == 'pending') {
          statusText = 'Menunggu Verifikasi';
          statusColor = AppColors.goldDark;
        }

        return _buildMandatorCard(
          name: data.delegatorName,
          nim: data.delegatorNim ?? '220104000',
          faculty: data.delegatorFaculty ?? 'Fakultas',
          votes: data.delegatorVoteWeight,
          status: statusText,
          statusColor: statusColor,
          imageUrl: data.delegatorAvatarUrl ?? 'https://i.pravatar.cc/150?img=11',
          isRevoked: isRevoked,
        );
      }).toList(),
    );
  }

  Widget _buildMandatorCard({
    required String name,
    required String nim,
    required String faculty,
    required int votes,
    required String status,
    required Color statusColor,
    required String imageUrl,
    bool isRevoked = false,
  }) {
    return GestureDetector(
      onTap: isRevoked
          ? null
          : () => context.pushNamed(
                'mandator-profile',
                pathParameters: {'name': name.replaceAll(' ', '-').toLowerCase()},
                extra: {
                  'name': name,
                  'nim': nim,
                  'faculty': faculty,
                  'status': status,
                  'statusColor': statusColor,
                  'votes': votes,
                  'isRevoked': isRevoked,
                  'imageUrl': imageUrl,
                },
              ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isRevoked ? const Color(0xFFF5F5F5) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: isRevoked
              ? Border.all(color: Colors.red.withValues(alpha: 0.15))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isRevoked ? 0.01 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            _buildAvatar(imageUrl, isRevoked),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTypography.displayHeading.copyWith(
                            fontSize: 18,
                            color: isRevoked
                                ? AppColors.textSecondary
                                : AppColors.primary900,
                            decoration: isRevoked
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppColors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (isRevoked)
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 2),
                          child: Text(
                            'DICABUT',
                            style: AppTypography.captionBold.copyWith(
                              color: Colors.red.withValues(alpha: 0.7),
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.goldMid.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$votes\nsuara',
                              textAlign: TextAlign.center,
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.goldDark,
                                fontSize: 10,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$nim • $faculty',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.outline,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status row
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isRevoked ? status : 'Status: $status',
                          style: AppTypography.captionBold.copyWith(
                            color: statusColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Trailing icon
            if (isRevoked)
              Icon(Icons.do_not_disturb_alt, color: Colors.red.withValues(alpha: 0.6), size: 22)
            else
              const Icon(Icons.chevron_right, color: AppColors.outline, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl, bool isRevoked) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isRevoked
              ? AppColors.outlineVariant
              : AppColors.goldMid.withValues(alpha: 0.3),
          width: 1.5,
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: isRevoked
              ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
              : null,
        ),
      ),
    );
  }

  // ──────────────── Pinned Bottom CTA Button ──────────────────────
  Widget _buildPinnedButton(DelegateDashboardData data) {
    return Positioned(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: AppSpacing.lg,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldDark.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.pushNamed('delegate-vote-execution'),
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Eksekusi ${data.totalVotesHeld} Suara untuk ${data.urgentElectionTitle ?? 'BEM 2026'}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────── Bottom Navigation Bar ──────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                label: 'Beranda',
                onTap: () => context.goNamed('delegate-home'),
              ),
              _buildNavItem(
                context,
                icon: Icons.gavel_outlined,
                label: 'Mandat',
                isSelected: true,
                onTap: () {},
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline_rounded,
                label: 'Profil',
                onTap: () => context.goNamed('delegate-profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppColors.goldDark : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: color,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
