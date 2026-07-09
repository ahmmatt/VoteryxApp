// lib/features/user/dashboard/presentation/widgets/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/core/widgets/status_badge.dart';
import 'package:voteryxapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:voteryxapp/features/user/election/domain/entities/election.dart';
import 'package:voteryxapp/features/user/election/presentation/providers/election_provider.dart';
import 'package:voteryxapp/features/user/notifications/presentation/widgets/notifications_modal.dart';

/// Tab Home untuk Dashboard User — terhubung ke Supabase via Riverpod.
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 17) return 'Selamat Siang';
    if (hour < 20) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    return RefreshIndicator(
      color: AppColors.goldMid,
      onRefresh: () async {
        ref.invalidate(dashboardProvider);
        ref.invalidate(userProfileProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header Section ──
            userProfileAsync.when(
              data: (profile) => _HeaderSection(
                greeting: _getGreeting(),
                userName: profile?.fullName ?? 'Pengguna Voteryx',
                isDelegate: dashboardAsync.maybeWhen(
                  data: (d) => d.hasActiveMandate,
                  orElse: () => false,
                ),
                mandateCount: 0, // TODO: ambil dari delegations
              ),
              loading: () => _HeaderSkeleton(),
              error: (_, __) => _HeaderSection(
                greeting: _getGreeting(),
                userName: 'Pengguna Voteryx',
                isDelegate: false,
                mandateCount: 0,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Pemilihan Aktif Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PEMILIHAN AKTIF',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('elections'),
                    child: Text(
                      'Lihat Semua',
                      style: AppTypography.bodyText.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Election cards
            dashboardAsync.when(
              data: (data) {
                if (data.activeElections.isEmpty) {
                  return _EmptyElectionState();
                }
                return Column(
                  children: data.activeElections.map((election) {
                    final hasVoted =
                        data.votedElectionIds.contains(election.id);
                    return _ActiveElectionCard(
                      election: election,
                      hasVoted: hasVoted,
                    );
                  }).toList(),
                );
              },
              loading: () => _ElectionCardSkeleton(),
              error: (err, _) => _ErrorState(
                message: 'Gagal memuat pemilihan',
                onRetry: () => ref.invalidate(dashboardProvider),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Ringkasan Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
              child: Text(
                'PENGUMUMAN',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _AnnouncementCard(),
          ],
        ),
      ),
    );
  }
}

// ── Header Section ────────────────────────────────────────────────────────────

class _HeaderSection extends ConsumerWidget {
  const _HeaderSection({
    required this.greeting,
    required this.userName,
    required this.isDelegate,
    required this.mandateCount,
  });

  final String greeting;
  final String userName;
  final bool isDelegate;
  final int mandateCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.sm,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName,
                      style: AppTypography.displayHeading.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                tooltip: 'Notifikasi',
                onPressed: () {
                  showNotificationsModal(context, ref);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Selamat datang di portal pemilihan digital.',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Bobot suara card
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.mdSm,
            ),
            decoration: BoxDecoration(
              color: const Color(0xCCB0BBCB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL BOBOT SUARA',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.goldDark,
                        letterSpacing: 0.7,
                      ),
                    ),
                    Text(
                      '1',
                      style: AppTypography.displayHeading.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMid.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.how_to_vote_outlined,
                    color: AppColors.primary800,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Delegate card (hanya jika ada mandat)
          if (isDelegate) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.mdSm,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.delegateGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.delegateTealMid.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MANDAT DITERIMA',
                        style: AppTypography.captionBold.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.7,
                        ),
                      ),
                      Text(
                        '$mandateCount Suara',
                        style: AppTypography.displayHeading.copyWith(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                      Text(
                        'Siap dieksekusi',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Active Election Card ───────────────────────────────────────────────────────

class _ActiveElectionCard extends StatelessWidget {
  const _ActiveElectionCard({
    required this.election,
    required this.hasVoted,
  });

  final Election election;
  final bool hasVoted;

  @override
  Widget build(BuildContext context) {
    final statusBadgeStatus = election.isLive
        ? ElectionStatus.live
        : ElectionStatus.scheduled;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePad,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: election.isLive
              ? AppColors.glassBorderGold
              : AppColors.outlineVariant,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F1F3D),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: statusBadgeStatus),
              if (hasVoted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.successTeal,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sudah Memilih',
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.successTeal,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          Text(
            election.title,
            style: AppTypography.cardTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Countdown
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  election.timeRemainingFormatted,
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Participation bar
          Builder(
            builder: (context) {
              final participation = election.participationRate;
              final pctText = election.voteCount > 0 && (participation * 100).round() == 0
                  ? '< 1%'
                  : '${(participation * 100).round()}%';
              final progressVal = election.voteCount > 0 && participation < 0.02
                  ? 0.02
                  : participation;
              final voterCountText = election.estimatedVoters > 0
                  ? '${election.voteCount} / ${election.estimatedVoters}'
                  : '${election.voteCount} Suara';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Partisipasi Pemilih',
                        style: AppTypography.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        pctText,
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.goldDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressVal,
                      backgroundColor: AppColors.outlineVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldMid),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(voterCountText, style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _HomeInfoPill(
                          icon: Icons.person_outline,
                          label: '${election.candidateCount} Kandidat',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _HomeInfoPill(
                          icon: Icons.groups_outlined,
                          label: '${election.voteCount} Suara Masuk',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(
                      'election-info',
                      pathParameters: {'id': election.id},
                    );
                  },
                  child: Text(
                    'Lihat Detail',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: GoldButton(
                  label: hasVoted ? 'Sudah Memilih' : 'Pilih Sekarang',
                  icon: hasVoted ? Icons.check : Icons.arrow_forward,
                  height: 42,
                  onPressed: hasVoted
                      ? null
                      : () => context.pushNamed(
                            'election',
                            pathParameters: {'id': election.id},
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeInfoPill extends StatelessWidget {
  const _HomeInfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary800),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Announcement Card ─────────────────────────────────────────────────────────

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0x1A0F1F3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: AppColors.primary800,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENTING',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.goldDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sosialisasi Teknis Pemilihan Raya Digital 2026...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty & Error States ──────────────────────────────────────────────────────

class _EmptyElectionState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.how_to_vote_outlined,
            size: 48,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tidak Ada Pemilihan Aktif',
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pemilihan baru akan muncul di sini ketika sudah dijadwalkan.',
            style: AppTypography.bodyText.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppColors.errorRed, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodyText),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Coba Lagi',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.goldDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton Loaders ─────────────────────────────────────────────────────────

class _HeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.goldMid,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ElectionCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.md),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.goldMid,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
