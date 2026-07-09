// lib/features/user/profile/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/history_provider.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(userHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Riwayat', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(userHistoryProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aktivitas Suara', style: AppTypography.cardTitle.copyWith(color: AppColors.navyMid, fontSize: 16)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Daftar partisipasi pemilihan Anda yang tercatat secara aman di blockchain.',
              style: AppTypography.bodyText,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            historyAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: CircularProgressIndicator(color: AppColors.goldDark),
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                      const SizedBox(height: 12),
                      Text('Gagal memuat riwayat suara.', style: AppTypography.cardTitle),
                    ],
                  ),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.history_toggle_off, size: 64, color: AppColors.outline.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text('Belum Ada Riwayat', style: AppTypography.cardTitle),
                          const SizedBox(height: 8),
                          Text(
                            'Suara atau delegasi yang Anda lakukan akan muncul di sini.',
                            style: AppTypography.bodyText,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: items.map((item) {
                    Widget leadingWidget;
                    if (item.leadingImageUrl != null && item.leadingImageUrl!.isNotEmpty) {
                      leadingWidget = ClipOval(
                        child: Image.network(
                          item.leadingImageUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary800,
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                        ),
                      );
                    } else if (item.type == 'delegation') {
                      leadingWidget = Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF0EBE1),
                        ),
                        child: const Icon(Icons.people, color: AppColors.goldDark, size: 20),
                      );
                    } else {
                      leadingWidget = Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE4E9F7),
                        ),
                        child: const Icon(Icons.view_list_outlined, color: AppColors.navyMid, size: 20),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildHistoryCard(
                        badgeText: item.badgeText,
                        badgeColor: item.badgeColor,
                        badgeTextColor: item.badgeTextColor,
                        date: item.dateFormatted,
                        title: item.title,
                        subtitleLabel: item.subtitleLabel,
                        subtitleValue: item.subtitleValue,
                        leadingWidget: leadingWidget,
                        actionIcon: item.actionIcon,
                        onViewProof: () {
                          final electionId = item.electionId ?? 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
                          ref.read(voteExecutionProvider.notifier).setReceiptData(
                            transactionHash: item.transactionHash ?? '0x9f8c6b4a2e1d0f8a7c6b5a4e3d2c1b0a9f8e7d6c5b4a3e2d1c0b9a8f7e6d5c4b',
                            candidateName: item.subtitleValue,
                            electionId: electionId,
                            electionTitle: item.title,
                            timestampFormatted: item.dateFormatted,
                            isDelegation: item.type == 'delegation',
                          );
                          context.pushNamed('election-receipt', pathParameters: {'id': electionId});
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String date,
    required String title,
    required String subtitleLabel,
    required String subtitleValue,
    required Widget leadingWidget,
    required IconData actionIcon,
    required VoidCallback onViewProof,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.captionBold.copyWith(color: badgeTextColor, fontSize: 12),
                ),
              ),
              Text(date, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leadingWidget,
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitleLabel, style: AppTypography.captionBold),
                    const SizedBox(height: 2),
                    Text(subtitleValue, style: AppTypography.itemTitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onViewProof,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(actionIcon, size: 16, color: AppColors.goldDark),
                    const SizedBox(width: 4),
                    Text('Lihat Bukti', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
