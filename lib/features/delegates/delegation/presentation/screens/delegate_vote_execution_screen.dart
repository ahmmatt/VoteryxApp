// lib/features/delegates/delegation/presentation/screens/delegate_vote_execution_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_vote_execution_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_dashboard_provider.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/profile_provider.dart';

/// Layar Eksekusi Suara — menampilkan data real dari database:
/// bobot suara, mandator aktif, kandidat dari pemilihan yang sedang berlangsung.
class DelegateVoteExecutionScreen extends ConsumerStatefulWidget {
  const DelegateVoteExecutionScreen({super.key});

  @override
  ConsumerState<DelegateVoteExecutionScreen> createState() =>
      _DelegateVoteExecutionScreenState();
}

class _DelegateVoteExecutionScreenState
    extends ConsumerState<DelegateVoteExecutionScreen> {
  int _selectedIndex = -1; // -1 berarti belum memilih
  double _sliderProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(delegateDashboardProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return dashboardAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator(color: AppColors.goldDark)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: Center(child: Text('Gagal memuat data: $e')),
      ),
      data: (data) {
        final myVoteWeight = profile?.voteWeight ?? 1;
        final activeMandates = data.mandates.where((m) => m.status == 'active').toList();
        final delegatedWeight = activeMandates.fold<int>(0, (sum, m) => sum + m.delegatorVoteWeight);
        final totalWeight = myVoteWeight + delegatedWeight;
        final candidates = data.urgentElectionCandidates;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
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

                  // 2. Detail bobot suara — dari database
                  _buildVoteWeightCard(
                    myVoteWeight: myVoteWeight,
                    activeMandates: activeMandates,
                    delegatedWeight: delegatedWeight,
                    totalWeight: totalWeight,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  if (candidates.isEmpty) ...[
                    // Tidak ada pemilihan aktif atau kandidat belum diisi
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.ballot_outlined, size: 48, color: AppColors.outline),
                          const SizedBox(height: 12),
                          Text(
                            data.urgentElectionTitle != null
                                ? 'Pemilihan "${data.urgentElectionTitle}" belum memiliki kandidat.'
                                : 'Tidak ada pemilihan aktif saat ini.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // 3. Pilih Kandidat
                    Text(
                      'Pilih Kandidat',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...candidates.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _buildCandidateCard(
                          candidate: entry.value,
                          isSelected: entry.key == _selectedIndex,
                          onTap: () {
                            setState(() => _selectedIndex = entry.key);
                            ref.read(delegateVoteExecutionProvider.notifier).selectCandidate(entry.value.id, entry.value.name);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.xxl),

                    // 4. Konfirmasi + swipe
                    if (_selectedIndex >= 0 && _selectedIndex < candidates.length)
                      _buildConfirmationSection(candidates[_selectedIndex], totalWeight, data.urgentElectionId ?? '')
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Pilih kandidat terlebih dahulu',
                            style: AppTypography.bodyText.copyWith(color: AppColors.outline),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ],
              ),
            ),
          ),
        );
      },
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
  Widget _buildVoteWeightCard({
    required int myVoteWeight,
    required List<DelegateMandateItem> activeMandates,
    required int delegatedWeight,
    required int totalWeight,
  }) {
    // Ambil nama 3 mandator pertama untuk ditampilkan
    final names = activeMandates.take(3).map((m) => m.delegatorName.split(' ').first).join(', ');
    final remaining = activeMandates.length - 3;
    final mandatorLabel = activeMandates.isEmpty
        ? 'Belum ada mandator'
        : names + (remaining > 0 ? ' +$remaining lainnya' : '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                // Suara milikku
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
                      '+$myVoteWeight',
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
                            mandatorLabel,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.outline,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activeMandates.isEmpty ? '+0' : '+$delegatedWeight',
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
                  '$totalWeight Suara',
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
    required DelegateCandidateItem candidate,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final photoUrl = candidate.photoUrl;
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
                    color: AppColors.goldMid.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Avatar kandidat
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldMid.withValues(alpha: 0.4)
                      : AppColors.outlineVariant,
                  width: 2,
                ),
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
              child: ClipOval(
                child: _buildCandidateAvatar(candidate.photoUrl, candidate.candidateNumber.toString(), isSelected),
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
                  if (candidate.vision != null && candidate.vision!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      candidate.vision!,
                      style: AppTypography.caption.copyWith(
                        color: isSelected ? AppColors.goldDark : AppColors.outline,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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

  Widget _buildCandidateAvatar(String? avatarUrl, String fallbackNumber, bool isSelected) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return Center(
        child: Text(
          fallbackNumber,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary900,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    
    try {
      if (avatarUrl.startsWith('data:image')) {
        final base64Str = avatarUrl.split(',').last;
        final normalized = base64.normalize(base64Str.replaceAll(RegExp(r'\s+'), ''));
        return Image.memory(
          base64Decode(normalized),
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          avatarUrl,
          fit: BoxFit.cover,
        );
      }
    } catch (_) {
      return Center(
        child: Text(
          fallbackNumber,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary900,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  // ─────────────────── Confirmation + Swipe ───────────────────────
  Widget _buildConfirmationSection(DelegateCandidateItem selected, int totalWeight, String electionId) {
    return Column(
      children: [
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
                '$totalWeight Suara akan diberikan',
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
            color: Colors.red.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
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
        _buildSwipeButton(totalWeight, electionId),
      ],
    );
  }

  Widget _buildSwipeButton(int totalWeight, String electionId) {
    const double height = 64.0;
    const double thumbSize = 56.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - thumbSize - 8;

        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: thumbSize + 8),
                child: Text(
                  'GESER UNTUK MENGUNCI $totalWeight SUARA',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.outline,
                    fontSize: 9,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: 4 + (_sliderProgress * maxDrag),
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderProgress = ((_sliderProgress * maxDrag + details.delta.dx) / maxDrag).clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (_) async {
                    if (_sliderProgress > 0.75) {
                      final notifier = ref.read(delegateVoteExecutionProvider.notifier);
                      notifier.setTotalWeight(totalWeight);
                      
                      context.pushNamed('delegate-vote-processing');
                      
                      await notifier.executeDelegateVote(electionId: electionId);
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
                          color: AppColors.goldDark.withValues(alpha: 0.35),
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
}
