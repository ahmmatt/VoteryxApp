import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';

class KycLivenessScreen extends StatefulWidget {
  const KycLivenessScreen({super.key});

  @override
  State<KycLivenessScreen> createState() => _KycLivenessScreenState();
}

class _KycLivenessScreenState extends State<KycLivenessScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Find front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2433), // Dark elegant background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      
                      // Header
                      Text(
                        'Verifikasi Wajah',
                        style: AppTypography.headerTitle.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Posisikan wajah di dalam garis',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Face Frame (Dashed Oval)
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera Feed
                            if (_isCameraInitialized && _cameraController != null)
                              ClipOval(
                                child: SizedBox(
                                  width: 250,
                                  height: 350,
                                  // Gunakan FittedBox agar tidak ter-stretch (kamera biasanya memiliki rasio yang berbeda)
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraController!.value.previewSize?.height ?? 250,
                                      height: _cameraController!.value.previewSize?.width ?? 350,
                                      child: CameraPreview(_cameraController!),
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox(
                                width: 250,
                                height: 350,
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.goldMid),
                                ),
                              ),
                              
                            // Overlay Oval Putus-putus
                            CustomPaint(
                              painter: DashedOvalPainter(color: AppColors.goldMid),
                              child: const SizedBox(
                                width: 250,
                                height: 350,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Instruction Badge / Action Button
                      GestureDetector(
                        onTap: () {
                          // Lanjutkan ke dashboard setelah diklik
                          context.go(AppRoutes.dashboard);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.goldMid.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.goldMid),
                          ),
                          child: Text(
                            'Silakan berkedip (Ketuk di sini)',
                            style: AppTypography.buttonText.copyWith(
                              color: AppColors.goldMid,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Bottom Stepper Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepIcon(Icons.check, AppColors.goldMid, 'NIK checked', true),
                                _buildStepLine(true),
                                _buildStepIcon(Icons.face, AppColors.goldMid, 'Face pulse', true, isActive: true),
                                _buildStepLine(false),
                                _buildStepIcon(Icons.verified, Colors.white.withOpacity(0.3), 'Done', false),
                              ],
                            ),
                            
                            const SizedBox(height: AppSpacing.lg),
                            
                            // Hidden buttons for demo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => context.go('/kyc/liveness-failed'),
                                  child: Text(
                                    'Tap to simulate fail',
                                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Simulate success goes to dashboard or completion
                                    context.go(AppRoutes.dashboard);
                                  },
                                  child: Text(
                                    'Tap to simulate success',
                                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, Color color, String label, bool isCompleted, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
      color: isCompleted ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.1),
    );
  }
}

class DashedOvalPainter extends CustomPainter {
  final Color color;
  DashedOvalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Draw dashed path
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
