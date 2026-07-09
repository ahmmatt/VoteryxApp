// lib/features/user/election_proposal/presentation/screens/my_election_proposals_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/user/election_proposal/domain/entities/election_proposal.dart';
import 'package:voteryxapp/features/user/election_proposal/presentation/providers/election_proposal_provider.dart';

class MyElectionProposalsScreen extends ConsumerWidget {
  const MyElectionProposalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(myProposalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Usulan Pemilihan Saya', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(myProposalsProvider),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Segarkan Usulan',
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(myProposalsProvider),
          color: AppColors.goldMid,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Monitor Usulan Pemilihan',
                style: AppTypography.displayHeading.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                'Status real-time dari proposal pemilihan yang Anda ajukan ke database.',
                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Button Ajukan Baru
              _buildNewProposalButton(context),
              const SizedBox(height: AppSpacing.xl),

              // Daftar Proposal Real dari Database
              proposalsAsync.when(
                data: (proposals) {
                  if (proposals.isEmpty) {
                    return _buildEmptyState();
                  }
                  return Column(
                    children: proposals.map((p) => _buildProposalCard(context, p)).toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.goldMid),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.errorRed, size: 48),
                        const SizedBox(height: 12),
                        Text('Gagal Memuat Usulan dari Database', style: AppTypography.cardTitle),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(myProposalsProvider),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary800),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary800.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_outlined, size: 48, color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Text('Belum Ada Usulan Pemilihan', style: AppTypography.cardTitle),
          const SizedBox(height: 8),
          Text(
            'Anda belum mengajukan proposal pemilihan baru ke dalam sistem. Klik tombol "Ajukan Pemilihan Baru" di atas untuk memulai.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNewProposalButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary800.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed('proposal-create');
          },
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ajukan Pemilihan Baru',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProposalCard(BuildContext context, ElectionProposal proposal) {
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    switch (proposal.status) {
      case 'approved':
        badgeColor = AppColors.successTeal;
        statusText = 'Disetujui (Aktif)';
        statusIcon = Icons.check_circle_outline;
        break;
      case 'rejected':
        badgeColor = AppColors.errorRed;
        statusText = 'Ditolak';
        statusIcon = Icons.cancel_outlined;
        break;
      case 'pending':
      default:
        badgeColor = AppColors.warningAmber;
        statusText = 'Dalam Peninjauan';
        statusIcon = Icons.pending_outlined;
        break;
    }

    final dateStr = proposal.createdAt != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(proposal.createdAt!)
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: badgeColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: AppTypography.captionBold.copyWith(color: badgeColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                dateStr,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            proposal.title,
            style: AppTypography.cardTitle.copyWith(fontSize: 16),
          ),
          if (proposal.organization != null && proposal.organization!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Organisasi: ${proposal.organization}',
              style: AppTypography.captionBold.copyWith(color: AppColors.primary800),
            ),
          ],
          if (proposal.purpose != null && proposal.purpose!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              proposal.purpose!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
            ),
          ],
          if (proposal.estimatedVoters != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Perkiraan Pemilih: ${proposal.estimatedVoters} orang',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
          if (proposal.adminNote != null && proposal.adminNote!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: proposal.status == 'rejected'
                    ? AppColors.errorRed.withValues(alpha: 0.08)
                    : AppColors.successTeal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan Verifikator Admin:',
                    style: AppTypography.captionBold.copyWith(
                      color: proposal.status == 'rejected' ? AppColors.errorRed : AppColors.successTeal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    proposal.adminNote!,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
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
