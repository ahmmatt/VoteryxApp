import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';
import 'dart:math';

class DelegateVoteProcessingScreen extends StatefulWidget {
  const DelegateVoteProcessingScreen({super.key});

  @override
  State<DelegateVoteProcessingScreen> createState() => _DelegateVoteProcessingScreenState();
}

class _DelegateVoteProcessingScreenState extends State<DelegateVoteProcessingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    
    // Simulate processing delay then navigate to success
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacementNamed('delegate-vote-success');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Hashes (Mocking the cryptographic background)
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  final randomString = List.generate(8, (index) => '0123456789ABCDEF'[Random().nextInt(16)]).join();
                  return Center(
                    child: Text(
                      randomString,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.primary900),
                    ),
                  );
                },
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Lock Icon with Concentric Circles
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated Circles
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * pi,
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outlineVariant, width: 1),
                          ),
                        ),
                        // Center Lock
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: AppColors.primary900,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.lock, color: Colors.white, size: 32),
                              ),
                            ),
                            // Badge
                            Transform.translate(
                              offset: const Offset(10, -5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldMid,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text('×47', style: AppTypography.captionBold.copyWith(color: AppColors.primary900, fontSize: 10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  Text('Mengamankan Mandat', style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
                  const SizedBox(height: 8),
                  Text(
                    'Suara sedang diproses melalui\nlapisan enkripsi asimetris.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  
                  // Progress Steps
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Step 1
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Menganonimkan 47 identitas...', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900)),
                                  const SizedBox(height: 4),
                                  Text('Berhasil', style: AppTypography.caption.copyWith(color: Colors.green)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Step 2
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.goldMid.withOpacity(0.3), shape: BoxShape.circle),
                              child: const Icon(Icons.vpn_key_outlined, color: AppColors.goldDark, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mengenkripsi 47 suara...', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.65,
                                      child: Container(decoration: BoxDecoration(color: AppColors.goldDark, borderRadius: BorderRadius.circular(2))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Step 3
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.outlineVariant.withOpacity(0.3), shape: BoxShape.circle),
                              child: const Icon(Icons.cloud_upload_outlined, color: AppColors.outline, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text('Mengirim ke jaringan...', style: AppTypography.bodyMedium.copyWith(color: AppColors.outline)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Batch Hash ID
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('BATCH HASH ID', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                        const SizedBox(height: 4),
                        Text('BATCH-e3b0c482...x47', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
