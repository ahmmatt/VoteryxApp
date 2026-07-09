// lib/features/admin/delegate_management/presentation/screens/admin_delegate_applications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_application_provider.dart';

class AdminDelegateApplicationsScreen extends ConsumerWidget {
  const AdminDelegateApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(delegateApplicationProvider);
    final pendingCount = applications.where((app) => app.status == DelegateApplicationStatus.pending).length;
    final approvedCount = applications.where((app) => app.status == DelegateApplicationStatus.approved).length;
    final rejectedCount = applications.where((app) => app.status == DelegateApplicationStatus.rejected).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        title: Text(
          'Pengajuan Delegasi ($pendingCount)',
          style: AppTypography.screenTitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat Ulang Data Database',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(delegateApplicationProvider.notifier).fetchFromDb();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menyinkronkan data pengajuan dari cloud Supabase...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.goldMid,
        onRefresh: () async {
          await ref.read(delegateApplicationProvider.notifier).fetchFromDb();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Daftar Calon Delegator',
              style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900),
            ),
              const SizedBox(height: 4),
              Text(
                'Tinjau, verifikasi kredensial akademik (NIM), dan setujui mandat delegasi (Liquid Democracy) pengguna.',
                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Stat Summary Cards
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Menunggu', '$pendingCount', Colors.orange),
                    Container(width: 1, height: 36, color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                    _buildStatItem('Disetujui', '$approvedCount', AppColors.successTeal),
                    Container(width: 1, height: 36, color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                    _buildStatItem('Ditolak', '$rejectedCount', AppColors.errorRed),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // List of Applications or Empty State
              if (applications.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary800.withValues(alpha: 0.06),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.assignment_outlined, size: 56, color: AppColors.goldDark),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum Ada Pengajuan Delegasi',
                          style: AppTypography.bodyBold.copyWith(fontSize: 18, color: AppColors.primary900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Saat ini tidak ada pendaftaran delegator di dalam sistem.',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => ref.read(delegateApplicationProvider.notifier).fetchFromDb(),
                          icon: const Icon(Icons.sync, color: Colors.white, size: 18),
                          label: Text('SINKRONISASI ULANG', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary800,
                            minimumSize: const Size(0, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...applications.map((app) => _buildApplicationCard(context, app)),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      );
    }

  Widget _buildStatItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: AppTypography.displayHeading.copyWith(fontSize: 20, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(BuildContext context, DelegateApplication app) {
    final isPending = app.status == DelegateApplicationStatus.pending;
    final isApproved = app.status == DelegateApplicationStatus.approved;

    Color statusColor = Colors.orange;
    String statusText = 'Menunggu Review';
    if (isApproved) {
      statusColor = AppColors.successTeal;
      statusText = 'Disetujui (Mandat Aktif)';
    } else if (app.status == DelegateApplicationStatus.rejected) {
      statusColor = AppColors.errorRed;
      statusText = 'Pengajuan Ditolak';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isPending
              ? AppColors.goldMid.withValues(alpha: 0.4)
              : AppColors.outlineVariant.withValues(alpha: 0.5),
          width: isPending ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: AppTypography.captionBold.copyWith(color: statusColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (app.isStudent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary800.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary800.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school, size: 13, color: AppColors.primary800),
                      const SizedBox(width: 5),
                      Text(
                        app.nim.isNotEmpty ? 'NIM: ${app.nim}' : 'Mahasiswa Terverifikasi',
                        style: AppTypography.captionBold.copyWith(color: AppColors.primary800, fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Delegator Name
          Text(
            app.name,
            style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900),
          ),
          const SizedBox(height: 4),

          // Expertise Tag Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.goldMid.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Keahlian: ${app.expertise}',
              style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Bio / Vision preview
          Text(
            app.bio.isNotEmpty ? app.bio : 'Kandidat delegasi siap menerima mandat suara dari pemilih FST.',
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 14),

          // Action Button or Status Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  app.trackRecord.isNotEmpty
                      ? 'Track Record: ${app.trackRecord}'
                      : 'Riwayat Organisasi Aktif',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              if (isPending)
                ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed('admin-delegate-review', pathParameters: {'id': app.id});
                  },
                  icon: const Icon(Icons.rate_review_outlined, size: 16, color: Colors.white),
                  label: Text('TINJAU & VERIFIKASI', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldDark,
                    minimumSize: const Size(0, 38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    elevation: 0,
                  ),
                )
              else if (isApproved)
                Row(
                  children: [
                    const Icon(Icons.verified, color: AppColors.successTeal, size: 18),
                    const SizedBox(width: 4),
                    Text('Aktif di Hub', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal)),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: AppColors.errorRed, size: 18),
                    const SizedBox(width: 4),
                    Text('Ditolak', style: AppTypography.captionBold.copyWith(color: AppColors.errorRed)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
