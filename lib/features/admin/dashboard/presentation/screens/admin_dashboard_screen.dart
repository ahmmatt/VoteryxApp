// lib/features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/features/admin/dashboard/presentation/providers/admin_dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminDashboardProvider);
    final numberFormat = NumberFormat('#,###', 'id_ID');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Admin Voteryx',
          style: AppTypography.screenTitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat Ulang Data Database',
            icon: stats.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: AppColors.goldMid, strokeWidth: 2),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(adminDashboardProvider.notifier).fetchRealDashboardData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menyinkronkan data pemilu dan suara dari cloud Supabase...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.goldMid,
        onRefresh: () async {
          await ref.read(adminDashboardProvider.notifier).fetchRealDashboardData();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            // Status Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusBadge('Server: Online', AppColors.successTeal),
                  _buildStatusBadge('Blockchain: Sinkron', AppColors.successTeal),
                  _buildStatusBadge('KYC database: Aktif', AppColors.successTeal),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik Hari Ini (Live Database)',
                    style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Grid Statistik
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Suara',
                          value: numberFormat.format(stats.totalVotes),
                          subtitle: '+12% vs last hour',
                          subtitleColor: AppColors.successTeal,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Partisipasi',
                          value: '${stats.participationRate}%',
                          subtitle: 'Dari Total User Terdaftar',
                          subtitleColor: AppColors.successTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Delegasi Aktif',
                          value: numberFormat.format(stats.activeDelegates),
                          subtitle: 'Node Terverifikasi',
                          subtitleColor: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total DPT',
                          value: numberFormat.format(stats.totalDpt),
                          subtitle: 'Total User Terdaftar',
                          subtitleColor: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Pemilihan Aktif Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pemilihan Aktif', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontSize: 16)),
                      InkWell(
                        onTap: () => context.pushNamed('admin-proposals'),
                        child: Text('Lihat Semua', style: AppTypography.captionBold.copyWith(color: AppColors.navy600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Active Election Cards
                  ...stats.activeElections.map((election) {
                    final title = election['title']?.toString() ?? 'Pemilihan Voteryx';
                    final endsIn = election['ends_in']?.toString() ?? 'Ends in 4h 20m';
                    final rate = (election['percentage'] as num?)?.toDouble() ?? stats.participationRate;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: const Color(0xFFFDF9F0),
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: InkWell(
                          onTap: () => context.pushNamed(
                            'admin-election-live',
                            pathParameters: {'id': election['id']?.toString() ?? '1'},
                            extra: election,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.goldMid.withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.how_to_vote, color: AppColors.primary900, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('LIVE', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal, fontSize: 10)),
                                          const SizedBox(width: 8),
                                          Text(endsIn, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('$rate%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900)),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 60,
                                      height: 4,
                                      child: LinearProgressIndicator(
                                        value: (rate / 100).clamp(0.0, 1.0),
                                        backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.5),
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary900),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Upcoming Election Cards
                  ...stats.upcomingElections.map((up) {
                    final title = up['title']?.toString() ?? 'Pemilihan Terjadwal';
                    final scheduled = up['scheduled']?.toString() ?? 'Terjadwal: Besok, 08:00';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: InkWell(
                          onTap: () => context.pushNamed(
                            'admin-election-live',
                            pathParameters: {'id': up['id']?.toString() ?? '1'},
                            extra: up,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(scheduled, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Aksi Cepat
                  Text('Aksi Cepat', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontSize: 16)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: AppColors.goldMid,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed('proposal-create');
                            },
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              child: Column(
                                children: [
                                  const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
                                  const SizedBox(height: 8),
                                  Text('Buat Pemilihan Baru', style: AppTypography.captionBold.copyWith(color: Colors.white), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: AppColors.primary800,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed('admin-candidate-verification');
                                },
                                borderRadius: BorderRadius.circular(AppRadius.card),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Icon(Icons.verified_user_outlined, color: Colors.white, size: 28),
                                      const SizedBox(height: 8),
                                      Text('Verifikasi Kandidat', style: AppTypography.captionBold.copyWith(color: Colors.white), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (stats.pendingCandidateCount > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorRed,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Text(
                                    '${stats.pendingCandidateCount}',
                                    style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10, height: 1),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required String subtitle, required Color subtitleColor}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.caption.copyWith(color: subtitleColor, fontSize: 9)),
        ],
      ),
    );
  }
}
