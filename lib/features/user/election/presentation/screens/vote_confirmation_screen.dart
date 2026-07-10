// lib/features/user/election/presentation/screens/vote_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import '../providers/election_provider.dart';
import '../../../../../core/widgets/slide_to_confirm.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';

class VoteConfirmationScreen extends ConsumerWidget {
  const VoteConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen untuk navigasi / error
    ref.listen<VoteExecutionState>(voteExecutionProvider, (_, next) {
      if (next.error != null) {
        AppSnackBar.showError(context, next.error!);
        ref.read(voteExecutionProvider.notifier).clearError();
      }
      if (next.isSuccess) {
        // Ambil electionId dari state atau GoRouter extra
        final electionId = next.electionId ?? '1';
        context.goNamed('election-receipt', pathParameters: {'id': electionId});
      }
    });

    final voteState = ref.watch(voteExecutionProvider);
    final candidateName = voteState.selectedCandidateName ?? 'Kandidat Pilihan';
    final electionId = voteState.electionId ?? '1';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Konfirmasi Pilihan',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Secure Session Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.goldDark,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Koneksi terenkripsi · Sesi aman',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.goldDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Candidate Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.goldMid.withValues(alpha: 0.5),
                  ),
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
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE5E7EB),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 34,
                            color: AppColors.outline,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PILIHAN ANDA',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                candidateName,
                                style: AppTypography.headerTitle.copyWith(
                                  color: AppColors.primary800,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.successTeal,
                          size: 22,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(color: Color(0xFFD32F2F), width: 4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFD32F2F),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Setelah dienkripsi, pilihan ini bersifat final dan tidak dapat diubah kembali demi menjaga integritas kotak suara digital.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFFB91C1C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Footer
              Center(
                child: Text(
                  'Suaramu dienkripsi dengan standar kriptografi end-to-end',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Slide to Confirm
              if (voteState.isProcessing)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.goldMid),
                )
              else
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x080F1F3D),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SlideToConfirm(
                    onConfirm: () async {
                      // Cek apakah user adalah delegate untuk pemilihan ini
                      final dData = ref.read(dashboardProvider).valueOrNull;
                      final isDelegate = dData?.mandateElectionIds.contains(electionId) ?? false;
                      
                      if (isDelegate) {
                        context.goNamed(
                          'delegate-execution-loading',
                          pathParameters: {'id': electionId},
                        );
                      } else {
                        context.goNamed(
                          'election-processing',
                          pathParameters: {'id': electionId},
                        );
                      }
                      
                      await ref
                          .read(voteExecutionProvider.notifier)
                          .executeVote();
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
