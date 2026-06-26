import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateApprovedScreen extends StatelessWidget {
  const DelegateApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 16, left: 24, right: 24),
            color: AppColors.primary900,
            child: Text(
              'Portal Delegasi',
              style: AppTypography.headerTitle.copyWith(color: Colors.white),
            ),
          ),
          
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.pageGradient,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Approved Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldMid, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldMid.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.verified, color: AppColors.goldDark, size: 40),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Text(
                      'Akun Delegat Disetujui!',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayHeading.copyWith(fontSize: 24, height: 1.2, color: AppColors.primary900),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Identitas Anda telah diverifikasi oleh sistem universitas secara transparan.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Credentials Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AKSES PORTAL BARU',
                            style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, letterSpacing: 1.0),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Username Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.outlineVariant),
                              borderRadius: BorderRadius.circular(AppRadius.input),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Username', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                      const SizedBox(height: 4),
                                      Text('DEL-8829', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.content_copy, color: AppColors.textSecondary, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          
                          // Password Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.outlineVariant),
                              borderRadius: BorderRadius.circular(AppRadius.input),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Password', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('********', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900, letterSpacing: 4.0)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.visibility_outlined, color: AppColors.goldDark, size: 18),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.content_copy, color: AppColors.textSecondary, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Warning info
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFDF5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFDEBB2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info, color: AppColors.goldDark, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Gunakan kredensial ini untuk masuk ke Portal Delegat. Anda akan diminta untuk mengganti kata sandi sementara saat pertama kali masuk.',
                                    style: AppTypography.caption.copyWith(color: AppColors.goldDark, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldDark.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Link to home
                            context.pushNamed('delegate-home');
                          },
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Masuk ke Portal', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                             const SizedBox(width: 8),
                             const Icon(Icons.login, color: Colors.white, size: 18),
                           ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Sesi Anda dilindungi oleh enkripsi Civic Glass.',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
