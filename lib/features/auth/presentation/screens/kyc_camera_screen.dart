import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';

class KycCameraScreen extends StatelessWidget {
  const KycCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161B22), // Very dark background
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(Icons.close, () => context.pop()),
                  Text(
                    'Foto e-KTP',
                    style: AppTypography.headerTitle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  _buildIconButton(Icons.flash_off, () {}),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Instruction Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                'Posisikan e-KTP di dalam bingkai',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
            
            const Spacer(),
            
            // Camera Viewfinder (Simulated)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AspectRatio(
                aspectRatio: 1.6, // Typical ID card aspect ratio
                child: Stack(
                  children: [
                    // Simulated Camera Feed Background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    
                    // Card Overlay Silhouette
                    Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 24),
                          // Photo Silhouette
                          Container(
                            width: 70,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.person, color: Colors.white.withOpacity(0.3), size: 40),
                          ),
                          const SizedBox(width: 24),
                          // Text Line Silhouettes
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSkeletonLine(double.infinity),
                                _buildSkeletonLine(120),
                                _buildSkeletonLine(80),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(right: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Yellow Corner Brackets
                    const Positioned(top: 0, left: 0, child: _CornerBracket(angle: 0)),
                    const Positioned(top: 0, right: 0, child: _CornerBracket(angle: 1.5708)), // 90 deg
                    const Positioned(bottom: 0, right: 0, child: _CornerBracket(angle: 3.14159)), // 180 deg
                    const Positioned(bottom: 0, left: 0, child: _CornerBracket(angle: 4.71239)), // 270 deg
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Sub Instruction
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 2, height: 12, color: AppColors.goldMid),
                const SizedBox(width: 4),
                Container(width: 2, height: 12, color: AppColors.goldMid),
                const SizedBox(width: 8),
                Text(
                  'Pastikan e-KTP rata dan tidak miring',
                  style: AppTypography.captionBold.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Privacy Note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.5), size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Foto hanya diproses di perangkat ini, tidak diunggah',
                    style: AppTypography.captionBold.copyWith(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery
                  _buildIconButton(Icons.image_outlined, () {
                    // For demo, go to error screen to show the error state
                    context.go('/kyc/photo-error');
                  }),
                  
                  // Capture Button
                  GestureDetector(
                    onTap: () {
                      context.go('/kyc/photo-review');
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                      ),
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.goldMid,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
                  
                  // Flip Camera
                  _buildIconButton(Icons.cameraswitch_outlined, () {}),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSkeletonLine(double width) {
    return Container(
      width: width,
      height: 8,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final double angle;
  
  const _CornerBracket({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.goldMid, width: 3),
            left: BorderSide(color: AppColors.goldMid, width: 3),
          ),
        ),
      ),
    );
  }
}
