import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

class KycLivenessFailedScreen extends StatelessWidget {
  const KycLivenessFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Darker background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            
            // Header
            Text(
              'Verifikasi Wajah Gagal',
              style: AppTypography.headerTitle.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'LANGKAH 2 DARI 3',
              style: AppTypography.captionBold.copyWith(
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 1.2,
              ),
            ),
            
            const Spacer(),
            
            // Face Frame (Solid Red-ish Outline)
            Center(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(250, 350)),
                  border: Border.all(color: AppColors.goldMid.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldMid.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE02424).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE02424).withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.close, color: AppColors.goldMid, size: 40),
                  ),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Error Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.goldMid),
                      const SizedBox(width: 8),
                      Text(
                        'Wajah Tidak Terdeteksi',
                        style: AppTypography.cardTitle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Pastikan wajah Anda terlihat jelas dan ikuti petunjuk berikut:',
                    style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildErrorTip('Posisikan wajah tepat di dalam bingkai'),
                  _buildErrorTip('Pastikan pencahayaan cukup (tidak terlalu gelap/terang)'),
                  _buildErrorTip('Lepaskan masker, kacamata hitam, atau topi'),
                  _buildErrorTip('Jangan bergerak saat proses pemindaian'),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  GoldButton(
                    label: 'Coba Lagi',
                    icon: Icons.refresh,
                    onPressed: () => context.pop(), // Go back to liveness
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Butuh Bantuan?',
                        style: AppTypography.buttonText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Bottom Stepper
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallStep(AppColors.goldMid, Icons.check),
                  _buildSmallLine(AppColors.goldMid),
                  _buildSmallStep(const Color(0xFFE02424), Icons.close, isError: true),
                  _buildSmallLine(Colors.white.withOpacity(0.2)),
                  _buildSmallStep(Colors.white.withOpacity(0.2), Icons.circle, isEmpty: true),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            Text(
              'Data biometrik Anda aman dan terenkripsi.',
              style: AppTypography.captionBold.copyWith(
                color: Colors.white.withOpacity(0.3),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.goldMid, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStep(Color color, IconData icon, {bool isError = false, bool isEmpty = false}) {
    return Container(
      padding: EdgeInsets.all(isEmpty ? 4 : 2),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.transparent : color,
        shape: BoxShape.circle,
        border: isEmpty ? Border.all(color: color) : (isError ? Border.all(color: color.withOpacity(0.3), width: 3) : null),
      ),
      child: Icon(icon, color: isEmpty ? color : Colors.white, size: 12),
    );
  }

  Widget _buildSmallLine(Color color) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: color,
    );
  }
}
