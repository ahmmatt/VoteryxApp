// lib/features/delegation/presentation/screens/delegate_vote_execution_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Model kandidat untuk pemilihan.
class _Candidate {
  final String name;
  final String vision;
  final String imageUrl;

  const _Candidate({
    required this.name,
    required this.vision,
    required this.imageUrl,
  });
}

/// Layar Eksekusi Suara — memilih kandidat dan mengkonfirmasi
/// eksekusi suara dengan gestur swipe.
class DelegateVoteExecutionScreen extends StatefulWidget {
  const DelegateVoteExecutionScreen({super.key});

  @override
  State<DelegateVoteExecutionScreen> createState() =>
      _DelegateVoteExecutionScreenState();
}

class _DelegateVoteExecutionScreenState
    extends State<DelegateVoteExecutionScreen> {
  int _selectedIndex = 1; // Default: Arjuna Pratama terpilih
  double _sliderProgress = 0.0;

  static const List<_Candidate> _candidates = [
    _Candidate(
      name: 'Siti Rahayu',
      vision: 'Visi Indonesia Inklusif',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    _Candidate(
      name: 'Arjuna Pratama',
      vision: 'Akselerasi Digital Kampus',
      imageUrl: 'https://i.pravatar.cc/150?img=11',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _candidates[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Verified delegate banner
              _buildVerifiedBanner(),
              const SizedBox(height: AppSpacing.xl),

              // 2. Detail bobot suara card
              _buildVoteWeightCard(),
              const SizedBox(height: AppSpacing.xxl),

              // 3. Pilih Kandidat
              Text(
                'Pilih Kandidat',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ..._candidates.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildCandidateCard(
                    candidate: entry.value,
                    isSelected: entry.key == _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = entry.key),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xxl),

              // 4. Konfirmasi + swipe
              _buildConfirmationSection(selected),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Eksekusi Suara',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.lock_outline, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─────────────────── Verified Delegate Banner ───────────────────
  Widget _buildVerifiedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE594)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.goldMid,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kamu bertindak sebagai Delegate terverifikasi',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Vote Weight Detail Card ────────────────────
  Widget _buildVoteWeightCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Detail rows
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DETAIL BOBOT SUARA',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Suara milikmu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suara Milikmu',
                      style: AppTypography.bodyText.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '+1',
                      style: AppTypography.displayHeading.copyWith(
                        fontSize: 16,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Mandat kolektif
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mandat Kolektif',
                            style: AppTypography.bodyText.copyWith(
                              color: AppColors.primary900,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Siti, Budi, Rizal +9 lainnya',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.outline,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+46',
                      style: AppTypography.displayHeading.copyWith(
                        fontSize: 16,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Total footer
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EDD5),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.card),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Kekuatan Suara',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '47 Suara',
                  style: AppTypography.displayHeading.copyWith(
                    fontSize: 16,
                    color: AppColors.goldDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Candidate Card ────────────────────────────
  Widget _buildCandidateCard({
    required _Candidate candidate,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFBEC) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? AppColors.goldMid : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldMid.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldMid.withOpacity(0.4)
                      : AppColors.outlineVariant,
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(candidate.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name + vision
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    style: AppTypography.displayHeading.copyWith(
                      fontSize: 17,
                      color: AppColors.primary900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    candidate.vision,
                    style: AppTypography.caption.copyWith(
                      color: isSelected ? AppColors.goldDark : AppColors.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.goldMid : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.goldMid : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── Confirmation + Swipe ───────────────────────
  Widget _buildConfirmationSection(_Candidate selected) {
    return Column(
      children: [
        // Confirmation label
        Text(
          'Konfirmasi Pilihan Anda',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          selected.name,
          style: AppTypography.displayHeading.copyWith(
            fontSize: 24,
            color: AppColors.primary900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        // Vote badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.primary900,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_alt_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                '47 Suara akan diberikan',
                style: AppTypography.captionBold.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Warning banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Tindakan Tidak Dapat Dibatalkan',
                style: AppTypography.captionBold.copyWith(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Swipe to lock
        _buildSwipeButton(),
      ],
    );
  }

  Widget _buildSwipeButton() {
    const double height = 64.0;
    const double thumbSize = 56.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - thumbSize - 8;

        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track label
              Padding(
                padding: const EdgeInsets.only(left: thumbSize + 8),
                child: Text(
                  'GESER UNTUK MENGUNCI 47 SUARA',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.outline,
                    fontSize: 9,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Draggable thumb
              Positioned(
                left: 4 + (_sliderProgress * maxDrag),
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderProgress = ((_sliderProgress * maxDrag +
                              details.delta.dx) /
                          maxDrag)
                          .clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (_sliderProgress > 0.75) {
                      // Navigate to processing
                      context.pushNamed('delegate-vote-processing');
                    } else {
                      setState(() => _sliderProgress = 0.0);
                    }
                  },
                  child: Container(
                    width: thumbSize,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldDark.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ──────────────────── Bottom Navigation Bar ─────────────────────
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Beranda', false, () {
                context.pushNamed('delegate-home');
              }),
              _buildNavItem(Icons.gavel_outlined, 'Mandat', false, () {
                context.pushNamed('delegate-dashboard');
              }),
              _buildNavItem(Icons.how_to_vote, 'Eksekusi', true, () {}),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  isSelected ? AppColors.goldDark : AppColors.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected
                    ? AppColors.goldDark
                    : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
