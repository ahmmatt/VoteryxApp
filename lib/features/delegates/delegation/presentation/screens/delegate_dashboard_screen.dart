// lib/features/delegation/presentation/screens/delegate_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Layar Manajemen Mandat — menampilkan total bobot suara,
/// daftar mandator beserta statusnya, dan tombol eksekusi.
class DelegateDashboardScreen extends StatefulWidget {
  const DelegateDashboardScreen({super.key});

  @override
  State<DelegateDashboardScreen> createState() =>
      _DelegateDashboardScreenState();
}

class _DelegateDashboardScreenState extends State<DelegateDashboardScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Semua (12)', 'Aktif (10)', 'Menunggu (2)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(gradient: AppColors.pageGradient),
          ),
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: 88, // Space for pinned bottom button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalSuaraCard(),
                const SizedBox(height: AppSpacing.xl),
                _buildTabBar(),
                const SizedBox(height: AppSpacing.xl),
                _buildMandatorList(),
              ],
            ),
          ),
          // Pinned bottom CTA button
          _buildPinnedButton(),
        ],
      ),
    );
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Manajemen Mandat',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ──────────────────── Total Bobot Suara Card ────────────────────
  Widget _buildTotalSuaraCard() {
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
            color: AppColors.goldMid.withOpacity(0.12),
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
                      '47',
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
                          value: 0.85,
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.goldDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ketua BEM\n2026',
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
                    '85%',
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
  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = i == _selectedTab;
          return Padding(
            padding: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
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
                            color: AppColors.goldMid.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _tabs[i],
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
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
  Widget _buildMandatorList() {
    return Column(
      children: [
        _buildMandatorCard(
          name: 'Siti Rahma',
          nim: '220104052',
          faculty: 'Ilmu Komputer',
          votes: 1,
          status: 'Menunggu',
          statusColor: AppColors.goldDark,
          imageUrl: 'https://i.pravatar.cc/150?img=5',
        ),
        _buildMandatorCard(
          name: 'Ahmad Fauzi',
          nim: '220104099',
          faculty: 'Teknik Mesin',
          votes: 1,
          status: 'Aktif',
          statusColor: const Color(0xFF10B981),
          imageUrl: 'https://i.pravatar.cc/150?img=11',
        ),
        _buildMandatorCard(
          name: 'Dian Kartika',
          nim: '220104011',
          faculty: 'Psikologi',
          votes: 0,
          status: 'Mandat telah ditarik oleh pemberi',
          statusColor: Colors.red,
          imageUrl: 'https://i.pravatar.cc/150?img=9',
          isRevoked: true,
        ),
        _buildMandatorCard(
          name: 'Kevin Pratama',
          nim: '220104105',
          faculty: 'Ekonomi',
          votes: 1,
          status: 'Aktif',
          statusColor: const Color(0xFF10B981),
          imageUrl: 'https://i.pravatar.cc/150?img=12',
        ),
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isRevoked ? const Color(0xFFF5F5F5) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: isRevoked
            ? Border.all(color: Colors.red.withOpacity(0.15))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isRevoked ? 0.01 : 0.03),
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
                            color: Colors.red.withOpacity(0.7),
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
                            color: AppColors.goldMid.withOpacity(0.2),
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
            Icon(Icons.do_not_disturb_alt, color: Colors.red.withOpacity(0.6), size: 22)
          else
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 22),
        ],
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
              : AppColors.goldMid.withOpacity(0.3),
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
  Widget _buildPinnedButton() {
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
              color: AppColors.goldDark.withOpacity(0.35),
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
                  'Eksekusi 47 Suara untuk BEM 2026',
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

}
