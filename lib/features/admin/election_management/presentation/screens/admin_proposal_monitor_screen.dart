import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/admin/dashboard/presentation/providers/admin_dashboard_provider.dart';

class AdminProposalMonitorScreen extends ConsumerWidget {
  const AdminProposalMonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Semua Pemilihan & Usulan',
          style: AppTypography.screenTitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(adminDashboardProvider.notifier).fetchRealDashboardData(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Pemilihan Aktif & Terjadwal',
                style: AppTypography.displayHeading
                    .copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Kelola, pantau real-count, atau verifikasi seluruh pemilihan dan proposal dari database secara real-time.',
              style: AppTypography.bodyText
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (stats.activeElections.isNotEmpty) ...[
              Text('Pemilihan Aktif (Live)',
                  style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...stats.activeElections.map((item) => _buildElectionCard(
                    context: context,
                    item: item,
                    isActive: true,
                  )),
              const SizedBox(height: AppSpacing.lg),
            ],

            if (stats.upcomingElections.isNotEmpty) ...[
              Text('Pemilihan Terjadwal & Usulan',
                  style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...stats.upcomingElections.map((item) => _buildElectionCard(
                    context: context,
                    item: item,
                    isActive: false,
                  )),
              const SizedBox(height: AppSpacing.lg),
            ],

            if (stats.activeElections.isEmpty && stats.upcomingElections.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text('Belum Ada Pemilihan Terdaftar',
                        style: AppTypography.cardTitle.copyWith(color: AppColors.primary900)),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildElectionCard({
    required BuildContext context,
    required Map<String, dynamic> item,
    required bool isActive,
  }) {
    final title = item['title']?.toString() ?? 'Pemilihan Voteryx';
    final id = item['id']?.toString() ?? '1';
    final shortId = id.length > 8 ? '${id.substring(0, 8)}...' : id;
    final subtitle = isActive
        ? (item['ends_in']?.toString() ?? 'Ends in 4h 20m')
        : (item['scheduled']?.toString() ?? 'Menunggu Verifikasi');
    final rate = (item['percentage'] as num?)?.toDouble() ?? 50.0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFDF9F0) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isActive
              ? AppColors.goldMid.withValues(alpha: 0.4)
              : AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
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
                  color: isActive ? const Color(0xFFE6FFF4) : const Color(0xFFF0F4FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.schedule,
                      color: isActive ? AppColors.successTeal : AppColors.navy600,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? 'Live di Sistem' : 'Terjadwal / Verifikasi',
                      style: AppTypography.captionBold.copyWith(
                        color: isActive ? AppColors.successTeal : AppColors.navy600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'ID: $shortId',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title,
              style: AppTypography.displayHeading
                  .copyWith(fontSize: 18, color: AppColors.primary900)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isActive ? Icons.timer_outlined : Icons.calendar_today_outlined,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tingkat Partisipasi',
                    style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                Text('$rate%', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 6,
              width: double.infinity,
              child: LinearProgressIndicator(
                value: (rate / 100).clamp(0.0, 1.0),
                backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary900),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                if (isActive) {
                  context.pushNamed(
                    'admin-election-live',
                    pathParameters: {'id': id},
                    extra: item,
                  );
                } else {
                  // Admin review proposal
                  context.pushNamed(
                    'admin-proposal-track',
                    pathParameters: {'id': id},
                    extra: item,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? AppColors.primary900 : AppColors.goldMid,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      isActive ? 'Lihat & Kelola Detail Pemilihan' : 'Lihat Detail Usulan',
                      style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
