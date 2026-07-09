import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class DelegateReviewScreen extends StatelessWidget {
  const DelegateReviewScreen({super.key});

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
                    
                    // Illustration
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 200,
                          height: 240,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.edit_document, size: 64, color: AppColors.outlineVariant),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(3))),
                                      const SizedBox(height: 8),
                                      Container(height: 6, width: 120, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(3))),
                                      const SizedBox(height: 8),
                                      Container(height: 6, width: 80, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(3))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Floating Icon Badge
                        Transform.translate(
                          offset: const Offset(10, 10),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6C85F),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF6C85F).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.history, color: AppColors.primary900, size: 28),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    Text(
                      'Permohonan Sedang Ditinjau',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayHeading.copyWith(fontSize: 24, height: 1.2, color: AppColors.primary900),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tim admin kami sedang memverifikasi data Anda. Proses ini memakan waktu 1-2 hari kerja.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
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
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6EFFF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.info_outline, color: AppColors.navyMid, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Apa selanjutnya?', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Anda akan menerima notifikasi melalui email universitas setelah status permohonan diperbarui.',
                                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nomor Referensi:', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
                              Text('#REQ-20240502-092', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Progress Bar (Tahap 3/3)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1D5DB),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD54F), Color(0xFFF57F17)],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'TAHAP 3/3',
                          style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldDark.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.goNamed('dashboard');
                          },
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                             const SizedBox(width: 8),
                             Text('Kembali ke Beranda', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                           ],
                          ),
                        ),
                      ),
                    ),
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
