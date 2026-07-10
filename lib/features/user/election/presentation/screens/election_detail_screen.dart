import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/gold_button.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import '../../domain/entities/election.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';
import 'package:voteryxapp/features/user/delegation/presentation/providers/delegation_provider.dart';
import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';
import '../providers/election_provider.dart';
import '../widgets/election_summary_white_card.dart';

class ElectionDetailScreen extends ConsumerStatefulWidget {
  const ElectionDetailScreen({super.key, required this.electionId});

  final String electionId;

  @override
  ConsumerState<ElectionDetailScreen> createState() => _ElectionDetailScreenState();
}

class _ElectionDetailScreenState extends ConsumerState<ElectionDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _selectedCandidateId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(electionDetailProvider(widget.electionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Text('Pemilihan', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(electionDetailProvider(widget.electionId)),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary800),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat kandidat pemilihan.',
                  style: AppTypography.cardTitle.copyWith(color: AppColors.primary800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GoldButton(
                  label: 'Coba Lagi',
                  onPressed: () => ref.invalidate(electionDetailProvider(widget.electionId)),
                ),
              ],
            ),
          ),
        ),
        data: (detailData) {
          final election = detailData.election;
          final candidates = detailData.candidates;

          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.pageGradient,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
                  child: ElectionSummaryWhiteCard(
                    title: election.title,
                    participationPercentage: election.participationRate,
                    votersCountText: '${election.voteCount} dari ${election.estimatedVoters > 0 ? election.estimatedVoters : 100}\npemilih',
                    countdownText: election.timeRemainingFormatted,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (detailData.hasDelegated)
                  Expanded(
                    child: _DelegatedStatusTab(
                      electionId: widget.electionId,
                      delegationInfo: detailData.delegationInfo,
                    ),
                  )
                else ...[
                  // Tab Bar
                  Container(
                    color: Colors.transparent,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.goldDark,
                      indicatorWeight: 3,
                      labelColor: AppColors.primary800,
                      labelStyle: AppTypography.itemTitle,
                      unselectedLabelColor: AppColors.textSecondary,
                      unselectedLabelStyle: AppTypography.bodyMedium,
                      tabs: const [
                        Tab(text: 'Daftar\nKandidat'),
                        Tab(text: 'Delegasikan\nSuara'),
                      ],
                    ),
                  ),

                  // Divider
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.outlineVariant),

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _CandidateListTab(
                          candidates: candidates,
                          selectedId: _selectedCandidateId,
                          onSelect: (id) {
                            setState(() {
                              _selectedCandidateId = (_selectedCandidateId == id) ? null : id;
                            });
                          },
                          electionId: widget.electionId,
                          hasVoted: detailData.hasParticipated,
                          onVoteConfirm: () {
                            if (_selectedCandidateId == null) return;
                            final c = candidates.firstWhere((x) => x.id == _selectedCandidateId);
                            ref.read(voteExecutionProvider.notifier).setSelectedCandidate(
                                  candidateId: c.id,
                                  candidateName: c.fullName,
                                  electionId: widget.electionId,
                                );
                            context.pushNamed('election-vote', pathParameters: {'id': widget.electionId});
                          },
                        ),
                        _DelegatorListTab(electionId: widget.electionId),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Tab 1: Daftar Kandidat ───────────────────────────────────────────────────

class _CandidateListTab extends StatelessWidget {
  const _CandidateListTab({
    required this.candidates,
    required this.selectedId,
    required this.onSelect,
    required this.electionId,
    required this.hasVoted,
    required this.onVoteConfirm,
  });

  final List<Candidate> candidates;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final String electionId;
  final bool hasVoted;
  final VoidCallback onVoteConfirm;

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: AppColors.outline.withValues(alpha: 0.6)),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Kandidat',
                style: AppTypography.cardTitle.copyWith(color: AppColors.primary800),
              ),
              const SizedBox(height: 8),
              Text(
                'Kandidat untuk pemilihan ini akan segera diumumkan oleh panitia penyelenggara.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ListView.separated(
          padding: EdgeInsets.only(
            left: AppSpacing.pagePad,
            right: AppSpacing.pagePad,
            top: AppSpacing.pagePad,
            bottom: (selectedId != null || hasVoted) ? 100 : AppSpacing.xxl,
          ),
          physics: const ClampingScrollPhysics(),
          itemCount: candidates.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final candidate = candidates[index];
            final isSelected = selectedId == candidate.id;
            final numberStr = candidate.candidateNumber != null
                ? candidate.candidateNumber!.toString().padLeft(2, '0')
                : (index + 1).toString().padLeft(2, '0');

            return _CandidateCard(
              number: numberStr,
              candidate: candidate,
              isSelected: isSelected,
              onTap: () => onSelect(candidate.id),
              onDetailTap: () {
                context.pushNamed(
                  'election-candidate',
                  pathParameters: {'id': electionId, 'candidateId': candidate.id},
                );
              },
            );
          },
        ),

        // Sticky action bar below if hasVoted or selectedId is not null
        if (hasVoted)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.pagePad),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: const GoldButton(
                label: 'Anda Sudah Memilih',
                icon: Icons.check_circle_outline,
                onPressed: null,
              ),
            ),
          )
        else if (selectedId != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.pagePad),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: GoldButton(
                label: 'Lanjutkan Pilih Kandidat Ini',
                icon: Icons.how_to_vote,
                onPressed: onVoteConfirm,
              ),
            ),
          ),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.number,
    required this.candidate,
    required this.isSelected,
    required this.onTap,
    required this.onDetailTap,
  });

  final String number;
  final Candidate candidate;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final tagline = candidate.visi ?? (candidate.misi ?? '"Dedikasi dan Kolaborasi untuk Masa Depan Nyata"');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.goldMid : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F1F3D),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with Badges
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.goldMid : AppColors.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: _buildCandidateAvatar(candidate.photoUrl, isSelected),
                    ),
                  ),
                  // Number Badge
                  Positioned(
                    top: -2,
                    right: 4,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.goldDark : AppColors.outline,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: AppTypography.captionBold.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Checkmark Badge (if selected)
                  if (isSelected)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.goldDark,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.fullName,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.primary800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tagline,
                    style: AppTypography.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onDetailTap,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat Profil & Visi Misi',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isSelected ? AppColors.goldDark : AppColors.primary800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: isSelected ? AppColors.goldDark : AppColors.primary800,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCandidateAvatar(String? photoUrl, bool isSelected) {
    Widget placeholder = Container(
      color: const Color(0xFFE5E7EB),
      child: Icon(Icons.person, size: 40, color: isSelected ? AppColors.primary800 : AppColors.outline),
    );

    if (photoUrl == null || photoUrl.trim().isEmpty) return placeholder;
    
    final cleanUrl = photoUrl.trim();
    if (cleanUrl.startsWith('data:image')) {
      try {
        final base64Str = cleanUrl.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } catch (e) {
        return placeholder;
      }
    } else if (cleanUrl.startsWith('http')) {
      return Image.network(
        cleanUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    return placeholder;
  }
}

// ── Tab 2: Delegasikan Suara (Murni Database) ─────────────────────────────────

class _DelegatorListTab extends ConsumerStatefulWidget {
  const _DelegatorListTab({required this.electionId});

  final String electionId;

  @override
  ConsumerState<_DelegatorListTab> createState() => _DelegatorListTabState();
}

class _DelegatorListTabState extends ConsumerState<_DelegatorListTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final delegatesAsync = ref.watch(publicDelegatesProvider);

    ref.listen<DelegationActionState>(delegationActionProvider, (_, next) {
      if (next.error != null) {
        AppSnackBar.showError(context, next.error!);
        ref.read(delegationActionProvider.notifier).clearError();
      }
      if (next.isSuccess) {
        AppSnackBar.showSuccess(
          context,
          'Suaramu berhasil didelegasikan ke ${next.selectedDelegateName}!',
        );
        ref.read(delegationActionProvider.notifier).reset();
      }
    });

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          child: AppTextField(
            label: '',
            hint: 'Cari nama atau fakultas delegator...',
            prefixIcon: Icons.search,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.toLowerCase();
              });
            },
          ),
        ),

        // List / Database State
        Expanded(
          child: delegatesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.goldMid),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                    const SizedBox(height: 12),
                    Text('Gagal Memuat Daftar Delegator', style: AppTypography.cardTitle),
                    const SizedBox(height: 8),
                    GoldButton(
                      label: 'Coba Lagi',
                      onPressed: () => ref.invalidate(publicDelegatesProvider),
                    ),
                  ],
                ),
              ),
            ),
            data: (delegates) {
              final filtered = delegates.where((d) {
                if (_searchQuery.isEmpty) return true;
                return d.fullName.toLowerCase().contains(_searchQuery) ||
                    (d.faculty ?? '').toLowerCase().contains(_searchQuery) ||
                    (d.specialization ?? '').toLowerCase().contains(_searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64,
                            color: AppColors.outline.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('Belum Ada Delegator', style: AppTypography.cardTitle),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Tidak ada delegator yang cocok dengan pencarian "$_searchQuery".'
                              : 'Saat ini belum ada delegator publik yang terdaftar di database untuk pemilihan ini. Anda dapat mendaftarkan diri sebagai delegator publik melalui menu Profil.',
                          style: AppTypography.bodyText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
                physics: const ClampingScrollPhysics(),
                children: [
                  ...filtered.map((delegate) => _DelegatorCard(
                        delegate: delegate,
                        onDelegateTap: () => _showDelegateConfirmation(context, delegate),
                        onDetailTap: () => context.pushNamed(
                          'user-delegate-detail',
                          pathParameters: {'delegateId': delegate.id},
                        ),
                      )),
                  const SizedBox(height: AppSpacing.xl),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary800.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary800, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Delegasi bersifat cair. Anda dapat menarik suara atau mengubah delegator kapan saja selama pemilihan masih berlangsung.',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDelegateConfirmation(BuildContext context, Delegate delegate) {
    ref.read(delegationActionProvider.notifier).selectDelegate(
          delegateId: delegate.id,
          delegateName: delegate.fullName,
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DelegationConfirmModal(
        delegate: delegate,
        electionId: widget.electionId,
      ),
    );
  }
}

class _DelegatorCard extends StatelessWidget {
  const _DelegatorCard({
    required this.delegate,
    required this.onDelegateTap,
    required this.onDetailTap,
  });

  final Delegate delegate;
  final VoidCallback onDelegateTap;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];
    if (delegate.faculty != null && delegate.faculty!.isNotEmpty) {
      badges.add(_DelegatorBadge(label: delegate.faculty!, type: _BadgeType.green));
    } else {
      badges.add(const _DelegatorBadge(label: 'DELEGASI PUBLIK', type: _BadgeType.green));
    }
    if (delegate.specialization != null && delegate.specialization!.isNotEmpty) {
      badges.add(_DelegatorBadge(label: delegate.specialization!, type: _BadgeType.gray));
    }
    if (delegate.trustScore > 0) {
      badges.add(_DelegatorBadge(label: 'TRUST: ${(delegate.trustScore * 10).toStringAsFixed(1)}%', type: _BadgeType.gold));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F1F3D),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Avatar & Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar — tampilkan foto jika ada
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary800,
                backgroundImage: (delegate.photoUrl != null && delegate.photoUrl!.isNotEmpty)
                    ? NetworkImage(delegate.photoUrl!)
                    : null,
                onBackgroundImageError: (delegate.photoUrl != null && delegate.photoUrl!.isNotEmpty)
                    ? (_, __) {}
                    : null,
                child: (delegate.photoUrl == null || delegate.photoUrl!.isEmpty)
                    ? Text(
                        delegate.initials,
                        style: AppTypography.itemTitle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delegate.fullName,
                      style: AppTypography.cardTitle.copyWith(
                        color: AppColors.primary800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: badges,
                    ),
                    if (delegate.delegateBio != null && delegate.delegateBio!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        delegate.delegateBio!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyText.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Bottom Row: Stats & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BEBAN SUARA SAAT INI',
                    style: AppTypography.captionBold.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        delegate.delegationCount.toString(),
                        style: AppTypography.itemTitle.copyWith(
                          fontSize: 16,
                          color: AppColors.primary800,
                        ),
                      ),
                      Text(
                        ' Suara',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Buttons: Lihat Detail | Delegasikan
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onDetailTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: AppTypography.captionBold.copyWith(
                            color: AppColors.primary800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_forward, size: 13, color: AppColors.primary800),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelegateTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Delegasikan',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DelegationConfirmModal extends ConsumerWidget {
  const _DelegationConfirmModal({
    required this.delegate,
    required this.electionId,
  });

  final Delegate delegate;
  final String electionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(delegationActionProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary800,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    delegate.initials,
                    style: AppTypography.itemTitle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delegate.fullName,
                      style: AppTypography.cardTitle.copyWith(fontSize: 16),
                    ),
                    if (delegate.faculty != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        delegate.faculty!,
                        style: AppTypography.bodyText.copyWith(fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Konfirmasi Delegasi Suara',
            style: AppTypography.itemTitle.copyWith(color: AppColors.primary800),
          ),
          const SizedBox(height: 6),
          Text(
            'Dengan mendelegasikan suara ke ${delegate.fullName}, hak suaramu pada pemilihan ini akan diwakilkan olehnya. Kamu tetap bisa menarik kembali suaramu atau memilih secara mandiri kapan saja sebelum masa pemilihan berakhir.',
            style: AppTypography.bodyText.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GoldButton(
            label: actionState.isLoading ? 'Memproses...' : 'Konfirmasi Delegasi',
            isLoading: actionState.isLoading,
            onPressed: actionState.isLoading
                ? null
                : () {
                    Navigator.pop(context);
                    ref.read(delegationActionProvider.notifier).createDelegation(
                          electionId: electionId,
                        );
                  },
          ),
        ],
      ),
    );
  }
}

enum _BadgeType { gray, green, gold }

class _DelegatorBadge extends StatelessWidget {
  const _DelegatorBadge({required this.label, required this.type});

  final String label;
  final _BadgeType type;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case _BadgeType.green:
        bgColor = const Color(0x3334C759); // Light green
        textColor = const Color(0xFF0F6E56); // Dark green
        break;
      case _BadgeType.gold:
        bgColor = const Color(0x33D4A030);
        textColor = AppColors.goldDark;
        break;
      case _BadgeType.gray:
        bgColor = AppColors.outlineVariant.withValues(alpha: 0.3);
        textColor = AppColors.primary800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.captionBold.copyWith(
          color: textColor,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Tab: Delegated Status ───────────────────────────────────────────────────

class _DelegatedStatusTab extends ConsumerStatefulWidget {
  const _DelegatedStatusTab({
    required this.electionId,
    this.delegationInfo,
  });

  final String electionId;
  final Map<String, dynamic>? delegationInfo;

  @override
  ConsumerState<_DelegatedStatusTab> createState() => _DelegatedStatusTabState();
}

class _DelegatedStatusTabState extends ConsumerState<_DelegatedStatusTab> {
  bool _isCancelling = false;

  void _handleCancelDelegation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Delegasi?'),
        content: const Text(
            'Apakah Anda yakin ingin membatalkan delegasi suara ini? '
            'Bobot suara Anda akan kembali dan Anda dapat memilih kandidat secara langsung.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isCancelling = true;
    });

    await ref.read(delegationActionProvider.notifier).cancelDelegation(electionId: widget.electionId);

    if (!mounted) return;
    setState(() {
      _isCancelling = false;
    });

    final state = ref.read(delegationActionProvider);
    if (state.isSuccess) {
      AppSnackBar.showSuccess(context, 'Delegasi berhasil dibatalkan.');
      ref.invalidate(electionDetailProvider);
      ref.invalidate(dashboardProvider);
    } else if (state.error != null) {
      AppSnackBar.showError(context, state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final delegateName = widget.delegationInfo?['delegate_name'] ?? 'Seseorang';
    final delegatePhotoUrl = widget.delegationInfo?['delegate_photo_url'] as String?;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6), // Light gold/orange bg
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.goldMid),
              ),
              child: Column(
                children: [
                  const Icon(Icons.groups, size: 48, color: AppColors.goldDark),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Suara Didelegasikan',
                    style: AppTypography.cardTitle.copyWith(color: AppColors.goldDark),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Anda telah mendelegasikan suara Anda pada pemilihan ini kepada:',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.outlineVariant,
                        backgroundImage: delegatePhotoUrl != null ? NetworkImage(delegatePhotoUrl) : null,
                        child: delegatePhotoUrl == null ? const Icon(Icons.person, color: AppColors.outline) : null,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        delegateName,
                        style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _isCancelling ? null : _handleCancelDelegation,
                icon: _isCancelling
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.errorRed),
                      )
                    : const Icon(Icons.cancel_outlined, color: AppColors.errorRed),
                label: Text(
                  _isCancelling ? 'Membatalkan...' : 'Batalkan Delegasi',
                  style: AppTypography.buttonText.copyWith(color: AppColors.errorRed),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.errorRed),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
