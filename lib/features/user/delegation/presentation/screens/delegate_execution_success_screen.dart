import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';
import 'package:voteryxapp/features/user/delegation/presentation/providers/delegation_provider.dart';
import 'package:voteryxapp/features/user/election/presentation/providers/election_provider.dart';

class DelegateExecutionSuccessScreen extends ConsumerWidget {
  final String electionId;
  const DelegateExecutionSuccessScreen({super.key, required this.electionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voteExecutionProvider);
    final transactionHash = state.transactionHash ?? 'MANDAT-EXEC-404';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePad,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back Button (Optional) & Title
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => context.goNamed('dashboard'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Success Icon & Badge
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.successTeal, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.successTeal,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.goldMid),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: AppColors.goldDark, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'DELEGATE PORTAL',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.goldDark,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'Seluruh Mandat Berhasil Dikunci!',
                textAlign: TextAlign.center,
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Suara Anda dan seluruh delegator telah berhasil dikunci ke dalam database secara anonim.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Transaction Info Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction Hash',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Icon(Icons.shield_outlined,
                            size: 16, color: AppColors.goldDark),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transactionHash,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary800,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(color: AppColors.outlineVariant, height: 1),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Simpan Transaction Hash ini jika diperlukan untuk proses audit.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              OutlinedButton.icon(
                onPressed: () {
                  // Implement share functionality or copy to clipboard
                },
                icon: const Icon(Icons.download_rounded, color: AppColors.primary800),
                label: Text(
                  'Unduh Tanda Terima',
                  style: AppTypography.buttonText.copyWith(color: AppColors.primary800),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GoldButton(
                label: 'Kembali ke Dashboard',
                onPressed: () {
                  // Clear provider state
                  ref.invalidate(delegationActionProvider);
                  ref.invalidate(dashboardProvider);
                  context.goNamed('dashboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
