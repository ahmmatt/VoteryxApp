import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';
import '../providers/election_provider.dart';
import '../widgets/election_summary_white_card.dart';

class ElectionInfoScreen extends ConsumerWidget {
  const ElectionInfoScreen({super.key, required this.electionId});

  final String electionId;

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(electionDetailProvider(electionId));

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
        title: Text('Detail Pemilihan', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(electionDetailProvider(electionId)),
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
                  'Gagal memuat data pemilihan.',
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
                  onPressed: () => ref.invalidate(electionDetailProvider(electionId)),
                ),
              ],
            ),
          ),
        ),
        data: (detailData) {
          final election = detailData.election;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Election Summary White Card
                ElectionSummaryWhiteCard(
                  title: election.title,
                  participationPercentage: election.participationRate,
                  votersCountText: '${election.voteCount} dari ${election.estimatedVoters > 0 ? election.estimatedVoters : 100}\npemilih',
                  countdownText: election.timeRemainingFormatted,
                ),
                const SizedBox(height: AppSpacing.xl),

                // 2. Deskripsi Pemilihan
                Text(
                  'Deskripsi Pemilihan',
                  style: AppTypography.itemTitle.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Text(
                    election.description ??
                        'Pemilihan resmi yang diselenggarakan oleh ${election.organization ?? "Panitia Pemilihan"}. Gunakan hak suara Anda secara langsung atau melalui delegasi untuk menentukan arah kebijakan ke depan.',
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 3. Informasi Penting
                Text(
                  'Informasi Penting',
                  style: AppTypography.itemTitle.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Timeline',
                  value: '${_formatDate(election.startDate)} – ${_formatDate(election.endDate)}',
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoCard(
                  icon: Icons.account_balance_outlined,
                  title: 'Penyelenggara',
                  value: election.organization ?? 'Panitia Pemilihan Resmi',
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoCard(
                  icon: Icons.account_tree_outlined,
                  title: 'Metode & Tipe',
                  value: election.electionType ?? 'Liquid Democracy (Direct + Delegation)',
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Aturan & Prosedur
                Text(
                  'Aturan & Prosedur',
                  style: AppTypography.itemTitle.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: const Column(
                    children: [
                      _RuleItem(
                        icon: Icons.verified_user_outlined,
                        text: 'Keamanan data terjamin melalui sistem audit independen.',
                      ),
                      Divider(height: 24, color: AppColors.outlineVariant),
                      _RuleItem(
                        icon: Icons.lock_outline,
                        text: 'Enkripsi end-to-end untuk menjaga kerahasiaan pilihan Anda.',
                      ),
                      Divider(height: 24, color: AppColors.outlineVariant),
                      _RuleItem(
                        icon: Icons.person_outline,
                        text: 'Prinsip 1-Voter-1-Vote berlaku ketat melalui sistem otentikasi NIK.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // 5. Button
                GoldButton(
                  label: detailData.hasVoted ? 'Anda Sudah Memilih' : 'Pilih Kandidat Sekarang',
                  icon: detailData.hasVoted ? Icons.check : Icons.chevron_right,
                  onPressed: detailData.hasVoted
                      ? null
                      : () {
                          context.pushNamed('election', pathParameters: {'id': electionId});
                        },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary800, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary800,
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

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.goldDark, size: 18),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
