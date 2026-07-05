import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

class KycNfcFailedScreen extends StatelessWidget {
  const KycNfcFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5), // Light background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Verifikasi Identitas',
          style: AppTypography.headerTitle.copyWith(color: AppColors.primary900),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                  // Red Alert Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDE8E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.nfc_outlined, // Simulated crossed icon
                      color: Color(0xFFE02424),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Title
                  Text(
                    'Gagal Membaca e-KTP',
                    style: AppTypography.displayHeading.copyWith(
                      color: AppColors.primary900,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Description
                  Text(
                    'Koneksi NFC terputus atau chip tidak terdeteksi. Silakan coba tempelkan kembali e-KTP Anda dengan benar.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Tips
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tips Memperbaiki:',
                      style: AppTypography.cardTitle.copyWith(
                        color: AppColors.primary900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTipItem('Lepas casing HP jika terlalu tebal.'),
                  _buildTipItem('Pastikan posisi e-KTP tepat di area sensor NFC (biasanya di bagian belakang atas ponsel).'),
                  _buildTipItem('Tahan posisi e-KTP dan jangan digeser selama proses pemindaian.'),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Mock Graphic of Phone
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary900,
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary800, AppColors.primary900],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary900.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Phone outline
                  Container(
                    width: 250,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.goldMid, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  // KTP Graphic
                  Transform.rotate(
                    angle: -0.1,
                    child: Container(
                      width: 180,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Container(
                            width: 30,
                            height: 40,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 6, width: double.infinity, color: Colors.grey.withOpacity(0.3)),
                                const SizedBox(height: 8),
                                Container(height: 6, width: 80, color: Colors.grey.withOpacity(0.3)),
                                const SizedBox(height: 8),
                                Container(height: 6, width: 100, color: Colors.grey.withOpacity(0.3)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Buttons
            GoldButton(
              label: 'Coba Lagi',
              onPressed: () {
                context.pop();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                context.go('/kyc/camera');
              },
              child: Text(
                'Gunakan Cara Lain',
                style: AppTypography.buttonText.copyWith(
                  color: AppColors.primary900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.goldDark, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
