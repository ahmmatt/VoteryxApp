import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/admin/dashboard/presentation/providers/admin_dashboard_provider.dart';

class AdminElectionDraftDetailScreen extends ConsumerWidget {
  const AdminElectionDraftDetailScreen({super.key});

  Future<void> _checkAndAccElection(BuildContext context, WidgetRef ref) async {
    try {
      // Cek jumlah kandidat yang terdaftar dan terverifikasi untuk pemilihan ini
      final candidatesResp = await SupabaseConfig.client
          .from('candidates')
          .select('id, is_verified')
          .eq('election_id', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');
      
      final List candidates = candidatesResp as List;
      
      if (candidates.length < 2) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 28),
                const SizedBox(width: 10),
                Expanded(child: Text('Gagal Meng-ACC Pemilihan', style: AppTypography.cardTitle)),
              ],
            ),
            content: Text(
              'Pemilihan belum bisa di-ACC dan ditampilkan di Halaman User karena jumlah paslon kandidat yang terdaftar di database masih kurang dari 2 paslon.\n\nSilakan lengkapi data minimal 2 kandidat terlebih dahulu!',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Mengerti', style: TextStyle(color: AppColors.primary800, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
        return;
      }

      // Update status pemilihan menjadi 'live'
      await SupabaseConfig.client
          .from('elections')
          .update({'status': 'live'})
          .eq('id', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');

      ref.invalidate(adminDashboardProvider);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemilihan berhasil di-ACC dan terbit ke Halaman User!'),
          backgroundColor: AppColors.successTeal,
        ),
      );
      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e'), backgroundColor: AppColors.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: Text('Detail Pemilihan', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Elections > Detail Pemilihan 2024', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Pemilihan Ketua\nBEM Universitas',
                          style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900, height: 1.2),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6E5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.goldMid, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('SETUP DRAFT', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.pushNamed('admin-candidate-verification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lanjutkan Input & Verifikasi Kandidat', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _checkAndAccElection(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldMid,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('Terbitkan & ACC ke Halaman User (Live)', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Progress Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Progres\nPersiapan', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900, height: 1.2)),
                            const SizedBox(height: 8),
                            Text('Selesaikan langkah-langkah berikut untuk memulai pemilihan.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: 0.65,
                              backgroundColor: AppColors.outlineVariant.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldMid),
                              strokeWidth: 8,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('65%', style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
                              Text('Siap Diluncurkan', style: AppTypography.captionBold.copyWith(fontSize: 6, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Stepper
                  _buildStepItem(
                    isCompleted: true,
                    isActive: false,
                    isLocked: false,
                    title: 'Informasi Dasar',
                    subtitle: 'Selesai',
                  ),
                  _buildStepDivider(isActive: true),
                  _buildStepItem(
                    isCompleted: false,
                    isActive: true,
                    isLocked: false,
                    title: 'Input Kandidat',
                    subtitle: 'Dalam Proses',
                  ),
                  _buildStepDivider(isActive: false),
                  _buildStepItem(
                    isCompleted: false,
                    isActive: false,
                    isLocked: true,
                    title: 'Daftar Pemilih',
                    subtitle: 'Terkunci',
                  ),
                  _buildStepDivider(isActive: false),
                  _buildStepItem(
                    isCompleted: false,
                    isActive: false,
                    isLocked: true,
                    title: 'Pengaturan Keamanan',
                    subtitle: 'Terkunci',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Review Keamanan Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary900,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Review Keamanan', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text('Pastikan parameter keamanan sudah sesuai sebelum pemilihan dimulai.', style: AppTypography.caption.copyWith(color: AppColors.outlineVariant, fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2 / 4 Syarat Terpenuhi', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
                            Text('50%', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 6,
                          child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSecurityCheck(true, 'Kontrak Smart Contract'),
                        const SizedBox(height: 12),
                        _buildSecurityCheck(true, 'Node Validator Aktif'),
                        const SizedBox(height: 12),
                        _buildSecurityCheck(false, '2FA Admin'),
                        const SizedBox(height: 12),
                        _buildSecurityCheck(false, 'Enkripsi Database'),
                      ],
                    ),
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

  Widget _buildStepItem({
    required bool isCompleted,
    required bool isActive,
    required bool isLocked,
    required String title,
    required String subtitle,
  }) {
    Color iconBgColor;
    Color iconColor;
    IconData iconData;
    Color titleColor;
    
    if (isCompleted) {
      iconBgColor = const Color(0xFFE6FFF4);
      iconColor = AppColors.successTeal;
      iconData = Icons.check_circle_outline;
      titleColor = AppColors.primary900;
    } else if (isActive) {
      iconBgColor = const Color(0xFFE5EEFF);
      iconColor = const Color(0xFF1E50FF); // primary blue
      iconData = Icons.circle_outlined;
      titleColor = const Color(0xFF1E50FF);
    } else {
      iconBgColor = AppColors.outlineVariant.withOpacity(0.3);
      iconColor = AppColors.textSecondary;
      iconData = Icons.lock_outline;
      titleColor = AppColors.textSecondary;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.bodyMedium.copyWith(color: titleColor, fontWeight: FontWeight.bold)),
            Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildStepDivider({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(left: 17, top: 4, bottom: 4), // 8(padding) + 10(half icon size) - 1(half width) = 17
      width: 2,
      height: 30,
      color: isActive ? const Color(0xFF1E50FF) : AppColors.outlineVariant.withOpacity(0.5),
    );
  }

  Widget _buildSecurityCheck(bool isChecked, String label) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.circle_outlined,
          color: isChecked ? AppColors.successTeal : Colors.white.withOpacity(0.5),
          size: 16,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isChecked ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
