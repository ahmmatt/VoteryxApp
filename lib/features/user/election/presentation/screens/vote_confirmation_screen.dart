import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/slide_to_confirm.dart';

class VoteConfirmationScreen extends StatelessWidget {
  const VoteConfirmationScreen({super.key});

  // MOCK: Toggle untuk simulasi pemilihan tingkat rendah yang tidak memerlukan animasi panjang
  final bool isFastTrack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Konfirmasi Pilihan',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Secure Session Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE6), // Soft beige
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.goldDark,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Koneksi terenkripsi · Sesi aman',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.goldDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Weight & Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight 1',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEB), // Light red
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFFD32F2F),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '01h : 42m',
                          style: AppTypography.captionBold.copyWith(
                            color: const Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Candidate Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.goldMid.withValues(alpha: 0.5),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F1F3D),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar with Badge
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE5E7EB),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 36,
                                  color: AppColors.outline,
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary800,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '02',
                                      style: AppTypography.captionBold.copyWith(
                                        color: AppColors.goldDark,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PILIHAN ANDA',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Arjuna Pratama',
                                style: AppTypography.headerTitle.copyWith(
                                  color: AppColors.primary800,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pemilihan Ketua BEM 2026',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.goldDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Divider(height: 1, color: AppColors.outlineVariant),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visi Misi',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Digitalisasi Inovatif',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Status',
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'TERVERIFIKASI',
                                  style: AppTypography.captionBold.copyWith(
                                    color: const Color(0xFF10B981),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8), // Light red bg
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(
                      color: Color(0xFFD32F2F),
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFD32F2F),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Setelah dienkripsi, pilihan ini bersifat final dan tidak dapat diubah kembali demi menjaga integritas kotak suara digital.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFFB91C1C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Footer Text
              Center(
                child: Text(
                  isFastTrack 
                      ? 'Mode Fast-Track Aktif. Transaksi Instan.'
                      : 'Suaramu dienkripsi dengan standar kriptografi end-to-end',
                  style: AppTypography.captionBold.copyWith(
                    color: isFastTrack ? AppColors.successTeal : AppColors.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Slide to Confirm
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F1F3D),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SlideToConfirm(
                  onConfirm: () {
                    if (isFastTrack) {
                      // Langsung ke receipt jika fast-track aktif
                      context.goNamed('election-receipt',
                          pathParameters: {'id': '1'});
                    } else {
                      // Masuk ke proses enkripsi jika normal
                      context.goNamed('election-processing',
                          pathParameters: {'id': '1'});
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
