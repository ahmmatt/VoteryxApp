import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/status_badge.dart';

class ElectionListScreen extends StatelessWidget {
  const ElectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Header(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePad,
                AppSpacing.lg,
                AppSpacing.pagePad,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: const [
                  _SectionTitle(
                    title: 'Sedang Aktif',
                    subtitle: 'Pemilihan yang masih bisa Anda ikuti.',
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _ElectionCard(
                    id: '1',
                    title: 'Pemilihan Ketua BEM 2026',
                    organization: 'Badan Eksekutif Mahasiswa',
                    period: 'Berakhir 2 hari lagi',
                    participation: 0.62,
                    voterCount: '12,402 / 20,000',
                    candidates: '4 Kandidat',
                    delegates: '3 Delegasi Aktif',
                    status: ElectionStatus.live,
                    actionLabel: 'Pilih Sekarang',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ElectionCard(
                    id: '2',
                    title: 'Pemilihan Ketua HIMA TI',
                    organization: 'Himpunan Mahasiswa Teknik Informatika',
                    period: 'Berakhir 6 jam lagi',
                    participation: 0.74,
                    voterCount: '1,628 / 2,200',
                    candidates: '3 Kandidat',
                    delegates: '1 Delegasi Aktif',
                    status: ElectionStatus.live,
                    actionLabel: 'Pilih Sekarang',
                  ),
                  SizedBox(height: AppSpacing.xl),
                  _SectionTitle(
                    title: 'Sudah Berakhir',
                    subtitle: 'Arsip hasil pemilihan yang telah selesai.',
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _ElectionCard(
                    id: '3',
                    title: 'Pemilihan Senat Mahasiswa',
                    organization: 'Senat Mahasiswa Universitas',
                    period: 'Selesai 12 Okt 2025',
                    participation: 0.88,
                    voterCount: '17,620 / 20,000',
                    candidates: '2 Kandidat',
                    delegates: '5 Delegasi Tercatat',
                    status: ElectionStatus.completed,
                    actionLabel: 'Lihat Hasil',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ElectionCard(
                    id: '4',
                    title: 'Pemilihan Ketua UKM Riset',
                    organization: 'Unit Kegiatan Mahasiswa Riset',
                    period: 'Selesai 20 Sep 2025',
                    participation: 0.69,
                    voterCount: '418 / 610',
                    candidates: '3 Kandidat',
                    delegates: '2 Delegasi Tercatat',
                    status: ElectionStatus.completed,
                    actionLabel: 'Lihat Hasil',
                  ),
                ],
              ),
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
                style: AppTypography.headerTitle.copyWith(fontSize: 18),
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
  const _ElectionCard({
    required this.id,
    required this.title,
    required this.organization,
    required this.period,
    required this.participation,
    required this.voterCount,
    required this.candidates,
    required this.delegates,
    required this.status,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String organization;
  final String period;
  final double participation;
  final String voterCount;
  final String candidates;
  final String delegates;
  final ElectionStatus status;
  final String actionLabel;

  bool get _isCompleted => status == ElectionStatus.completed;

  @override
  Widget build(BuildContext context) {
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
              StatusBadge(status: status),
              const Spacer(),
              Icon(
                _isCompleted
                    ? Icons.verified_outlined
                    : Icons.how_to_vote_outlined,
                size: 19,
                color:
                    _isCompleted ? AppColors.textSecondary : AppColors.goldDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.primary800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(organization, style: AppTypography.caption),
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
                  period,
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
                '${(participation * 100).round()}%',
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
              value: participation,
              minHeight: 5,
              backgroundColor: AppColors.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _isCompleted ? AppColors.primary800 : AppColors.goldMid,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(voterCount, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.person_outline,
                  label: candidates,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _InfoPill(
                  icon: Icons.groups_outlined,
                  label: delegates,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton(
              onPressed: () {
                context.pushNamed('election', pathParameters: {'id': id});
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    _isCompleted ? AppColors.primary800 : AppColors.goldDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                actionLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
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
