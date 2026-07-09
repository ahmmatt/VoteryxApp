import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_application_provider.dart';

class AdminDelegateReviewScreen extends ConsumerWidget {
  final String id;
  const AdminDelegateReviewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(delegateApplicationProvider);
    final app = applications.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception('Pengajuan delegasi tidak ditemukan'),
    );

    final isPending = app.status == DelegateApplicationStatus.pending;
    final isApproved = app.status == DelegateApplicationStatus.approved;
    final isRejected = app.status == DelegateApplicationStatus.rejected;

    Color statusColor = Colors.orange;
    String statusText = 'Menunggu Review';
    IconData statusIcon = Icons.hourglass_empty_rounded;
    if (isApproved) {
      statusColor = AppColors.successTeal;
      statusText = 'Disetujui (Mandat Aktif)';
      statusIcon = Icons.check_circle_rounded;
    } else if (isRejected) {
      statusColor = AppColors.errorRed;
      statusText = 'Pengajuan Ditolak';
      statusIcon = Icons.cancel_rounded;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Review & Verifikasi Pengajuan',
          style: AppTypography.screenTitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primary800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top Profile Banner ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: isPending
                      ? AppColors.goldMid.withValues(alpha: 0.5)
                      : AppColors.outlineVariant.withValues(alpha: 0.5),
                  width: isPending ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary800,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary800.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.goldDark, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.name,
                              style: AppTypography.displayHeading.copyWith(
                                fontSize: 20,
                                color: AppColors.primary900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    app.isStudent ? 'NIM: ${app.nim}' : 'Non-Mahasiswa / Umum',
                                    style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),

                  // Status Badge Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Pengajuan Delegasi',
                                style: AppTypography.caption.copyWith(color: statusColor.withValues(alpha: 0.8), fontSize: 11),
                              ),
                              Text(
                                statusText,
                                style: AppTypography.bodyBold.copyWith(color: statusColor, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Section 1: Kualifikasi & Aspirasi ───────────────────────────
            _buildSectionCard(
              icon: Icons.psychology_outlined,
              title: 'Kualifikasi & Aspirasi Delegasi',
              children: [
                _buildDetailBox(
                  icon: Icons.lightbulb_outline_rounded,
                  label: 'Keahlian Utama (Expertise)',
                  value: app.expertise.isNotEmpty ? app.expertise : 'Belum dicantumkan',
                ),
                const SizedBox(height: 14),
                _buildDetailBox(
                  icon: Icons.format_quote_rounded,
                  label: 'Ringkasan Bio & Visi Mandat',
                  value: app.bio.isNotEmpty ? app.bio : 'Belum dicantumkan',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── Section 2: Rekam Jejak & Portofolio ─────────────────────────
            _buildSectionCard(
              icon: Icons.military_tech_outlined,
              title: 'Rekam Jejak & Bukti Prestasi',
              children: [
                _buildDetailBox(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Riwayat Pencapaian / Track Record',
                  value: app.trackRecord.isNotEmpty ? app.trackRecord : 'Belum dicantumkan',
                ),
                const SizedBox(height: 14),
                _buildPortfolioBox(
                  icon: Icons.link_rounded,
                  label: 'Tautan Portofolio / LinkedIn',
                  url: app.portfolioUrl.isNotEmpty ? app.portfolioUrl : '-',
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: isPending
              ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(delegateApplicationProvider.notifier).reject(app.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('❌ Pengajuan dari ${app.name} telah ditolak.')),
                          );
                          context.pop();
                        },
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        label: Text('Tolak', style: AppTypography.bodyBold.copyWith(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(delegateApplicationProvider.notifier).approve(app.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('✅ Pengajuan dari ${app.name} berhasil disetujui & diverifikasi!')),
                          );
                          context.pop();
                        },
                        icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        label: Text('Setujui', style: AppTypography.bodyBold.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Ubah kembali ke pending atau review ulang jika diperlukan
                          if (isApproved) {
                            ref.read(delegateApplicationProvider.notifier).reject(app.id);
                          } else {
                            ref.read(delegateApplicationProvider.notifier).approve(app.id);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Status pengajuan ${app.name} berhasil diperbarui.')),
                          );
                          context.pop();
                        },
                        icon: Icon(isApproved ? Icons.cancel_outlined : Icons.check_circle_outline, color: Colors.white, size: 18),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApproved ? AppColors.errorRed : AppColors.successTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        label: Text(
                          isApproved ? 'Batalkan Persetujuan (Tolak)' : 'Verifikasi & Setujui Sekarang',
                          style: AppTypography.bodyBold.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── BUILD HELPERS ─────────────────────────────────────────────────────────

  Widget _buildSectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary900, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.displayHeading.copyWith(fontSize: 17, color: AppColors.primary900),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailBox({required IconData icon, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioBox({required IconData icon, required String label, required String url}) {
    final hasUrl = url != '-' && url.isNotEmpty && (url.startsWith('http') || url.startsWith('www'));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasUrl ? const Color(0xFFF0F7FF) : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hasUrl ? const Color(0xFFCCE4FF) : AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: hasUrl ? const Color(0xFF0066CC) : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.captionBold.copyWith(
                  color: hasUrl ? const Color(0xFF0066CC) : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  url,
                  style: AppTypography.bodyMedium.copyWith(
                    color: hasUrl ? const Color(0xFF0066CC) : AppColors.primary900,
                    fontWeight: hasUrl ? FontWeight.w600 : FontWeight.normal,
                    decoration: hasUrl ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
              if (hasUrl) const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF0066CC)),
            ],
          ),
        ],
      ),
    );
  }
}
