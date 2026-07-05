import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

class KycPhotoReviewScreen extends StatelessWidget {
  const KycPhotoReviewScreen({super.key});

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
          'Foto e-KTP',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HASIL FOTO',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.goldDark,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // Photo Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Mock captured photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1633409361618-c73427e4e206?q=80&w=800&auto=format&fit=crop', // ID card placeholder
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Verification Pills
                  Row(
                    children: [
                      _buildPill('Terbaca'),
                      const SizedBox(width: 8),
                      _buildPill('Tidak Buram'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPill('Pencahayaan OK'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            Text(
              'DATA TERDETEKSI',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.goldDark,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // Data Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataField('NIK', '3273 0101 0190 0001'),
                  const SizedBox(height: AppSpacing.md),
                  _buildDataField('NAMA', 'BUDI SANTOSO'),
                  const SizedBox(height: AppSpacing.md),
                  _buildDataField('TEMPAT, TANGGAL LAHIR', 'JAKARTA, 01-01-1990'),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Security Note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6), // Light gold tint
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline, color: AppColors.goldDark, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Data hanya dibaca di perangkat ini. Tidak tersimpan di server.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.goldDark,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Buttons
            GoldButton(
              label: 'Gunakan Foto Ini',
              icon: Icons.arrow_forward,
              onPressed: () {
                context.go(AppRoutes.kycLiveness);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary900),
                label: Text(
                  'Foto Ulang',
                  style: AppTypography.buttonText.copyWith(color: AppColors.primary900),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.outline.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDEF7EC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF31C48D).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF057A55), size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.captionBold.copyWith(
              color: const Color(0xFF057A55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: AppColors.outline,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.cardTitle.copyWith(
            color: AppColors.primary900,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
