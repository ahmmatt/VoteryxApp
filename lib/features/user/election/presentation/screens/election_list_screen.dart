// lib/features/user/election/presentation/screens/election_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../../domain/entities/election.dart';
import '../providers/election_provider.dart';

class ElectionListScreen extends ConsumerStatefulWidget {
  const ElectionListScreen({super.key});

  @override
  ConsumerState<ElectionListScreen> createState() => _ElectionListScreenState();
}

class _ElectionListScreenState extends ConsumerState<ElectionListScreen> {
  // 0: Semua, 1: Aktif, 2: Sudah Selesai
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final allElectionsAsync = ref.watch(allElectionsProvider);
    final participatedIdsAsync = ref.watch(userParticipatedElectionIdsProvider);
    final participatedIds = participatedIdsAsync.maybeWhen(data: (s) => s, orElse: () => <String>{});

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: RefreshIndicator(
          color: AppColors.goldMid,
          onRefresh: () async {
            ref.invalidate(allElectionsProvider);
            ref.invalidate(userParticipatedElectionIdsProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _Header(context)),
              SliverToBoxAdapter(child: _buildFilterTabs()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePad,
                  AppSpacing.lg,
                  AppSpacing.pagePad,
                  AppSpacing.xxl,
                ),
                sliver: allElectionsAsync.when(
                  data: (elections) => _buildElectionsList(elections, participatedIds),
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.goldMid,
                        ),
                      ),
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: AppColors.errorRed,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat daftar pemilihan',
                            style: AppTypography.cardTitle.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            error.toString(),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                ref.invalidate(allElectionsProvider),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary800,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePad,
        AppSpacing.md,
        AppSpacing.pagePad,
        0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Semua', 0),
            const SizedBox(width: 8),
            _buildFilterChip('Aktif', 1),
            const SizedBox(width: 8),
            _buildFilterChip('Sudah Selesai', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary800 : AppColors.outlineVariant,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary800.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildElectionsList(List<Election> elections, Set<String> participatedIds) {
    final activeList = elections
        .where((e) => e.status == 'live' || e.status == 'scheduled')
        .toList();
    final completedList = elections
        .where((e) => e.status == 'completed' || e.status == 'ended')
        .toList();

    if (_selectedFilter == 1) {
      if (activeList.isEmpty) {
        return _buildEmptyState(
          'Belum Ada Pemilihan Aktif',
          'Saat ini tidak ada pemilihan yang sedang berlangsung atau dijadwalkan.',
        );
      }
      return SliverList.separated(
        itemCount: activeList.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (ctx, idx) => _ElectionCard(
          election: activeList[idx],
          hasVoted: participatedIds.contains(activeList[idx].id),
        ),
      );
    } else if (_selectedFilter == 2) {
      if (completedList.isEmpty) {
        return _buildEmptyState(
          'Belum Ada Pemilihan Selesai',
          'Belum ada riwayat pemilihan yang selesai diselenggarakan.',
        );
      }
      return SliverList.separated(
        itemCount: completedList.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (ctx, idx) => _ElectionCard(
          election: completedList[idx],
          hasVoted: participatedIds.contains(completedList[idx].id),
        ),
      );
    }

    // Semua
    if (elections.isEmpty) {
      return _buildEmptyState(
        'Belum Ada Pemilihan',
        'Belum ada data pemilihan yang tercatat di sistem saat ini.',
      );
    }

    final List<Widget> items = [];

    if (activeList.isNotEmpty) {
      items.add(
        const _SectionTitle(
          title: 'Sedang Aktif',
          subtitle: 'Pemilihan yang masih bisa atau akan datang Anda ikuti.',
        ),
      );
      items.add(const SizedBox(height: AppSpacing.sm));
      for (final e in activeList) {
        items.add(_ElectionCard(
          election: e,
          hasVoted: participatedIds.contains(e.id),
        ));
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    if (completedList.isNotEmpty) {
      if (activeList.isNotEmpty) {
        items.add(const SizedBox(height: AppSpacing.md));
      }
      items.add(
        const _SectionTitle(
          title: 'Sudah Berakhir',
          subtitle: 'Arsip hasil pemilihan yang telah selesai.',
        ),
      );
      items.add(const SizedBox(height: AppSpacing.sm));
      for (final e in completedList) {
        items.add(_ElectionCard(
          election: e,
          hasVoted: participatedIds.contains(e.id),
        ));
        items.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return SliverList(delegate: SliverChildListDelegate(items));
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(
              Icons.how_to_vote_outlined,
              size: 56,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.cardTitle.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodyText.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.context);

  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.sm,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
        bottom: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Daftar Pemilihan',
                style: AppTypography.headerTitle.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Semua pemilihan',
            style: AppTypography.displayHeading.copyWith(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pantau pemilihan aktif dan arsip hasil yang sudah berakhir.',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.cardTitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTypography.caption),
      ],
    );
  }
}

class _ElectionCard extends StatelessWidget {
  const _ElectionCard({required this.election, required this.hasVoted});

  final Election election;
  final bool hasVoted;

  ElectionStatus get _badgeStatus {
    switch (election.status.toLowerCase()) {
      case 'live':
        return ElectionStatus.live;
      case 'scheduled':
        return ElectionStatus.scheduled;
      case 'completed':
      case 'ended':
        return ElectionStatus.completed;
      case 'draft':
        return ElectionStatus.draft;
      default:
        return ElectionStatus.live;
    }
  }

  bool get _isCompleted =>
      election.status == 'completed' || election.status == 'ended';

  String get _periodText {
    if (election.isLive) {
      return 'Berakhir ${election.timeRemainingFormatted}';
    } else if (election.isScheduled) {
      return 'Mulai ${_formatDate(election.startDate)}';
    } else {
      return 'Selesai ${_formatDate(election.endDate)}';
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F1F3D),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(status: _badgeStatus),
              if (hasVoted) ...[
                const SizedBox(width: 8),
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
              const Spacer(),
              Icon(
                _isCompleted
                    ? Icons.verified_outlined
                    : Icons.how_to_vote_outlined,
                size: 19,
                color: _isCompleted
                    ? AppColors.textSecondary
                    : AppColors.goldDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            election.title,
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.primary800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            election.organization ?? 'Organisasi Pemilihan',
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                _isCompleted ? Icons.event_available : Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  _periodText,
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partisipasi',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                pctText,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.goldDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressVal,
              minHeight: 5,
              backgroundColor: AppColors.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _isCompleted ? AppColors.primary800 : AppColors.goldMid,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(voterCountText, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.person_outline,
                  label: '${election.candidateCount} Kandidat',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _InfoPill(
                  icon: Icons.groups_outlined,
                  label: '${election.voteCount} Suara Masuk',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      'election-info',
                      pathParameters: {'id': election.id},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary800,
                    side: const BorderSide(
                      color: AppColors.primary800,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Lihat Detail',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: (hasVoted && !_isCompleted)
                      ? null
                      : () {
                          context.pushNamed(
                            'election',
                            pathParameters: {'id': election.id},
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: (hasVoted && !_isCompleted)
                        ? AppColors.outlineVariant
                        : (_isCompleted
                            ? AppColors.primary800
                            : AppColors.goldDark),
                    foregroundColor: (hasVoted && !_isCompleted)
                        ? AppColors.textSecondary
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    (hasVoted && !_isCompleted)
                        ? 'Sudah Memilih'
                        : (_isCompleted ? 'Lihat Hasil' : 'Pilih Sekarang'),
                    style: AppTypography.bodyMedium.copyWith(
                      color: (hasVoted && !_isCompleted)
                          ? AppColors.textSecondary
                          : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

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
