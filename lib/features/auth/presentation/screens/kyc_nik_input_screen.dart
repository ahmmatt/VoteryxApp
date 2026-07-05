import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';

class KycNikInputScreen extends StatefulWidget {
  const KycNikInputScreen({super.key});

  @override
  State<KycNikInputScreen> createState() => _KycNikInputScreenState();
}

class _KycNikInputScreenState extends State<KycNikInputScreen> {
  final TextEditingController _nikController = TextEditingController();

  void _showNfcModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E9F0), // Light grayish-blue to match image
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.md),
                // Icon Circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.goldMid,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.contactless, color: Colors.white, size: 32),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Title
                Text(
                  'Menunggu e-KTP...',
                  style: AppTypography.headerTitle.copyWith(
                    color: AppColors.primary900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Description
                Text(
                  'Jangan pindahkan kartu Anda selama\nproses pemindaian berlangsung.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Loading dots (simulated)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(true),
                    const SizedBox(width: 8),
                    _buildDot(true),
                    const SizedBox(width: 8),
                    _buildDot(true),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Fallback ke liveness langsung atau layar NFC manual
                      context.go(AppRoutes.kycLiveness); 
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.outline.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Batalkan',
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.primary900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );

    // Simulate NFC read success after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context); // Close waiting modal
        _showNfcSuccessModal();
      }
    });
  }

  void _showNfcSuccessModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6), // Very light gray/white
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Success Icon
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 40),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Title
              Text(
                'Membaca Chip KTP...\nSukses!',
                textAlign: TextAlign.center,
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary900,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Description
              Text(
                'Data identitas Anda telah berhasil\ndiverifikasi secara aman melalui enkripsi\ntingkat tinggi.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Identity Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150&auto=format&fit=crop'), // Mock face
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IDENTITAS TERBACA',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SITI AMINAH ZAKARIA',
                            style: AppTypography.cardTitle.copyWith(
                              color: AppColors.primary900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified, color: Color(0xFF10B981)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.kycLiveness); // or dashboard, going to Liveness matches stepper
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldDark, // Gold button
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lanjutkan ke Surat Suara',
                        style: AppTypography.buttonText.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? AppColors.goldDark : AppColors.goldMid.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5), // Light background from design
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            
            // Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepItem('NIK', true),
                _buildStepDivider(false),
                _buildStepItem('WAJAH', false),
                _buildStepDivider(false),
                _buildStepItem('SELESAI', false),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // NIK Input Title
            Text(
              'MASUKKAN NIK',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // NIK Text Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outline.withOpacity(0.2)),
              ),
              child: TextField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                maxLength: 16,
                style: AppTypography.bodyText.copyWith(color: AppColors.primary900),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: '16 digit NIK kamu',
                  hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.outline),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (val) {
                  if (val.length == 16) {
                    // Auto show modal if 16 digits reached for demo purposes
                    FocusScope.of(context).unfocus();
                    _showNfcModal();
                  }
                },
              ),
            ),
            
            const Spacer(),
            
            // Center Illustration (Mock of phone tapping ID)
            Center(
              child: GestureDetector(
                onTap: _showNfcModal, // Manual trigger for testing
                child: Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primary900,
                    borderRadius: BorderRadius.circular(24),
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
                      // Phone screen mock
                      Positioned(
                        top: 20,
                        child: Container(
                          width: 80,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // NFC Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.goldMid, width: 2),
                        ),
                        child: const Icon(Icons.contactless_outlined, color: AppColors.goldMid, size: 32),
                      ),
                      // Mock card behind
                      Positioned(
                        right: -30,
                        bottom: 40,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: const Icon(Icons.keyboard_double_arrow_left, color: AppColors.goldDark, size: 40),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.goldMid : AppColors.outline.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTypography.captionBold.copyWith(
            color: isActive ? AppColors.goldMid : AppColors.outline,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 20),
      width: 24,
      height: 2,
      color: isActive ? AppColors.goldMid : AppColors.outline.withOpacity(0.3),
    );
  }
}
