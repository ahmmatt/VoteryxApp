import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';

class KycPhotoErrorScreen extends StatelessWidget {
  const KycPhotoErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Verifikasi Identitas',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Status Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusPill('Buram', false),
                const SizedBox(width: 8),
                _buildStatusPill('Terpotong', false),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatusPill('Pencahayaan OK', true),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Blurred Image Box
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF8B4B4), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Mock blurred card content
                  Opacity(
                    opacity: 0.3,
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        Container(
                          width: 50,
                          height: 70,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 8, width: double.infinity, color: Colors.grey),
                              const SizedBox(height: 12),
                              Container(height: 8, width: 120, color: Colors.grey),
                              const SizedBox(height: 12),
                              Container(height: 8, width: 80, color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                  
                  // Alert Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Color(0xFFE02424),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Error Message Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE8E8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFE02424), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foto Tidak Dapat\nDibaca',
                          style: AppTypography.headerTitle.copyWith(
                            color: AppColors.primary900,
                            fontSize: 20,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Foto e-KTP kamu kurang jelas. Pastikan data terlihat dengan gamblang.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Checklist
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pastikan:',
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.primary900,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildChecklistItem('e-KTP berada di dalam bingkai emas sepenuhnya'),
            _buildChecklistItem('Kamera tidak goyang'),
            _buildChecklistItem('Pencahayaan cukup'),
            _buildChecklistItem('Permukaan KTP bersih'),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop(); // Go back to camera
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Coba Lagi',
                      style: AppTypography.buttonText.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {},
              child: Text(
                'Pilih dari Galeri',
                style: AppTypography.buttonText.copyWith(
                  color: AppColors.goldDark,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String text, bool isSuccess) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFFDEF7EC) : const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSuccess ? const Color(0xFF31C48D) : const Color(0xFFF8B4B4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check : Icons.close,
            color: isSuccess ? const Color(0xFF057A55) : const Color(0xFFE02424),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.captionBold.copyWith(
              color: isSuccess ? const Color(0xFF057A55) : const Color(0xFFE02424),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.goldMid, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
