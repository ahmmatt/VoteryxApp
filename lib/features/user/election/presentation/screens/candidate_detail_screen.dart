import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';
import '../../domain/entities/election.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';
import '../providers/election_provider.dart';

class CandidateDetailScreen extends ConsumerStatefulWidget {
  const CandidateDetailScreen({
    super.key,
    required this.electionId,
    required this.candidateId,
  });

  final String electionId;
  final String candidateId;

  @override
  ConsumerState<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends ConsumerState<CandidateDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidateAsync = ref.watch(candidateDetailProvider(widget.candidateId));

    return candidateAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary800, elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary800)),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary800, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 16),
                Text('Gagal memuat profil kandidat.', style: AppTypography.cardTitle),
                const SizedBox(height: 16),
                GoldButton(
                  label: 'Coba Lagi',
                  onPressed: () => ref.invalidate(candidateDetailProvider(widget.candidateId)),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (candidate) {
        if (candidate == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(backgroundColor: AppColors.primary800, elevation: 0),
            body: Center(
              child: Text('Kandidat tidak ditemukan.', style: AppTypography.cardTitle),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              NestedScrollView(
                physics: const ClampingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 350,
                      pinned: true,
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
                      titleSpacing: 0,
                      title: Text(
                        'Profil Kandidat',
                        style: AppTypography.headerTitle.copyWith(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white, size: 20),
                          onPressed: () {},
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildProfileHeader(context, candidate),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            border: Border(
                              bottom: BorderSide(color: AppColors.outlineVariant, width: 1),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicatorColor: AppColors.goldDark,
                            indicatorWeight: 3,
                            labelColor: AppColors.goldDark,
                            unselectedLabelColor: AppColors.textSecondary,
                            labelStyle: AppTypography.labelLarge,
                            unselectedLabelStyle: AppTypography.bodyMedium,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: 'Visi & Misi'),
                              Tab(text: 'Track Record'),
                              Tab(text: 'Program Kerja'),
                              Tab(text: 'Statistik'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildVisiMisiTab(candidate),
                    _buildTrackRecordTab(candidate),
                    _buildProgramKerjaTab(candidate),
                    _buildStatistikTab(candidate),
                  ],
                ),
              ),

              // Bottom Sticky Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomButton(context, candidate),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, Candidate candidate) {
    final numberStr = candidate.candidateNumber != null
        ? 'No. ${candidate.candidateNumber!.toString().padLeft(2, '0')}'
        : 'Kandidat';

    return Container(
      color: AppColors.primary800,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
        bottom: 56,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar with Number badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC5C6CE),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 4),
                ),
                child: ClipOval(
                  child: candidate.photoUrl != null && candidate.photoUrl!.isNotEmpty
                      ? Image.network(candidate.photoUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 64, color: AppColors.textSecondary),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    numberStr,
                    style: AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name and verified badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  candidate.fullName,
                  style: AppTypography.displayHeading
                      .copyWith(color: Colors.white, fontSize: 24),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (candidate.isVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x33139971),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.successTeal),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: AppColors.successTeal, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        'Terverifikasi',
                        style: AppTypography.captionBold.copyWith(
                            color: AppColors.successTeal, fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            '${candidate.faculty ?? "Fakultas Mahasiswa"}${candidate.nim != null ? " • NIM ${candidate.nim}" : ""}',
            style: AppTypography.bodyText
                .copyWith(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildVisiMisiTab(Candidate candidate) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        Text('Visi', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
        const SizedBox(height: 12),
        Text(
          '"${candidate.visi ?? "Mewujudkan organisasi yang inklusif, transparan, dan berorientasi pada kemajuan bersama melalui inovasi berkelanjutan."}"',
          style: AppTypography.bodyText.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              fontSize: 15),
        ),
        const SizedBox(height: 24),
        Text('Misi', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
        const SizedBox(height: 12),
        if (candidate.misi != null && candidate.misi!.isNotEmpty)
          ...candidate.misi!
              .split('\n')
              .where((s) => s.trim().isNotEmpty)
              .map((item) => _buildBulletPoint(item.trim()))
        else ...[
          _buildBulletPoint('Digitalisasi seluruh layanan administrasi kemahasiswaan untuk efisiensi waktu.'),
          _buildBulletPoint('Membangun transparansi anggaran organisasi kemahasiswaan yang dapat diakses publik.'),
          _buildBulletPoint('Meningkatkan partisipasi aktif mahasiswa dalam perumusan kebijakan kampus.'),
        ],
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.goldDark,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyText
                  .copyWith(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackRecordTab(Candidate candidate) {
    if (candidate.trackRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Belum ada data riwayat organisasi.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      itemCount: candidate.trackRecords.length,
      itemBuilder: (context, index) {
        final record = candidate.trackRecords[index];
        return _buildTimelineItem(
          year: (record['year'] ?? '2024').toString(),
          title: (record['title'] ?? 'Pengalaman Organisasi').toString(),
          description: (record['description'] ?? '').toString(),
          isFirst: index == 0,
          isLast: index == candidate.trackRecords.length - 1,
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFirst
                          ? AppColors.goldDark
                          : AppColors.outlineVariant,
                      width: 4,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year,
                    style: AppTypography.captionBold.copyWith(
                      color: isFirst ? AppColors.goldDark : AppColors.outline,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTypography.bodyText,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramKerjaTab(Candidate candidate) {
    if (candidate.programs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Belum ada data program kerja.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      itemCount: candidate.programs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final prog = candidate.programs[index];
        return _buildProgramCard(
          title: (prog['title'] ?? 'Program Kerja ${index + 1}').toString(),
          description: (prog['description'] ?? '').toString(),
        );
      },
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F1F3D),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border:
                Border(left: BorderSide(color: AppColors.goldDark, width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.itemTitle.copyWith(fontSize: 16)),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(description, style: AppTypography.bodyText),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistikTab(Candidate candidate) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Circular Chart
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.82,
                      backgroundColor: Color(0xFFFEEFC3), // Light gold
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.goldMid),
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '82%',
                            style: AppTypography.displayHeading
                                .copyWith(fontSize: 40),
                          ),
                          Text(
                            'Sentimen Positif',
                            style: AppTypography.captionBold
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Dukungan',
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('4,203',
                          style: AppTypography.screenTitle
                              .copyWith(color: AppColors.goldDark)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Partisipasi',
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('12k', style: AppTypography.screenTitle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, Candidate candidate) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background,
            AppColors.background,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: GoldButton(
        label: 'Pilih ${candidate.fullName}',
        icon: Icons.how_to_vote,
        onPressed: () {
          ref.read(voteExecutionProvider.notifier).setSelectedCandidate(
                candidateId: candidate.id,
                candidateName: candidate.fullName,
                electionId: widget.electionId,
              );
          context.pushNamed('election-vote', pathParameters: {'id': widget.electionId});
        },
      ),
    );
  }
}
