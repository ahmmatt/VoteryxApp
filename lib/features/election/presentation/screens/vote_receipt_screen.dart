import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/gold_button.dart';
import '../../../../core/widgets/ghost_button.dart';

class VoteReceiptScreen extends StatelessWidget {
  const VoteReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'E-Receipt',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldMid.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.goldDark,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Suara Berhasil Dicatat!',
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilihan Anda telah dienkripsi secara end-to-end dan diamankan secara permanen dalam jaringan blockchain.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F1F3D),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'E-RECEIPT OFFICIAL',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BUKTI PEMILIHAN',
                      style: AppTypography.headerTitle.copyWith(
                        color: AppColors.primary800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Transaction Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TRANSACTION ID',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '0x7f4e...9b2c8a1e3f5d7c9b0a',
                                style: AppTypography.caption.copyWith(
                                  fontFamily: 'Courier',
                                  color: AppColors.primary800,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.copy, color: AppColors.outline, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Key Values
                    _buildReceiptRow('Waktu', '24 Okt 2023, 14:32:01 WIB'),
                    const SizedBox(height: AppSpacing.md),
                    _buildReceiptRow('Pemilihan', 'Ketua BEM UI 2024'),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock, color: AppColors.goldDark, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'TERENKRIPSI',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.goldDark,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // QR Code Placeholder
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.primary800,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x330F1F3D),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.qr_code_2, size: 64, color: AppColors.primary800),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'SCAN UNTUK\nMEMVALIDASI INTEGRITAS\nSUARA DI JARINGAN',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Anonymity Note
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0E6), // very light beige/grey
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.goldMid.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.visibility_off_outlined,
                      color: AppColors.goldDark,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Suara Anda sepenuhnya anonim. Sistem tidak menyimpan kaitan antara identitas pengguna dan data pilihan yang telah dienkripsi.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.goldDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              GoldButton(
                label: 'Simpan Struk ke Galeri',
                icon: Icons.download,
                onPressed: () {},
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              GhostButton(
                label: 'Kembali ke Beranda',
                icon: Icons.home_outlined,
                onPressed: () {
                  context.go('/dashboard');
                },
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
