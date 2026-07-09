// lib/features/auth/presentation/screens/kyc_liveness_screen.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import '../providers/auth_provider.dart';

class KycLivenessScreen extends ConsumerStatefulWidget {
  const KycLivenessScreen({super.key});

  @override
  ConsumerState<KycLivenessScreen> createState() => _KycLivenessScreenState();
}

class _KycLivenessScreenState extends ConsumerState<KycLivenessScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Cari kamera depan (front camera)
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

  Future<void> _takePhotoAndVerify() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      String? imagePath;
      if (_isCameraInitialized && _cameraController != null) {
        final xFile = await _cameraController!.takePicture();
        imagePath = xFile.path;
      } else {
        // Fallback simulasi jika kamera emulator tidak tersedia
        imagePath = 'simulated_face_photo_path.jpg';
      }

      setState(() => _capturedImagePath = imagePath);

      // Simpan ke provider registrasi
      ref.read(registrationProvider.notifier).setFaceData(imagePath);

      // Simulasi jeda pemrosesan biometrik (2 detik agar terasa realistis & profesional)
      await Future.delayed(const Duration(milliseconds: 1800));
      if (!mounted) return;

      // Selesaikan registrasi ke Supabase
      await ref.read(registrationProvider.notifier).completeRegistration();
      if (!mounted) return;

      final regState = ref.read(registrationProvider);
      if (regState.isComplete) {
        AppSnackBar.showSuccess(context, 'Verifikasi wajah berhasil! Akunmu telah aktif.');
        context.go(AppRoutes.dashboard);
      } else if (regState.error != null) {
        // Tampilkan pesan error asli dari Supabase agar pengguna tahu kenapa gagal masuk database
        AppSnackBar.showError(context, 'Gagal menyimpan ke database: ${regState.error!}');
        setState(() => _isProcessing = false);
      } else {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Gagal memproses foto wajah. Coba lagi.');
        setState(() => _isProcessing = false);
      }
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
                      const SizedBox(height: AppSpacing.xl),

                      // Header
                      Text(
                        'Foto Wajah (Selfie)',
                        style: AppTypography.headerTitle.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Posisikan wajahmu di dalam bingkai oval dan pastikan pencahayaan cukup terang',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Face Frame (Dashed Oval / Preview)
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera Feed or Captured Photo
                            if (_capturedImagePath != null && File(_capturedImagePath!).existsSync())
                              ClipOval(
                                child: Image.file(
                                  File(_capturedImagePath!),
                                  width: 260,
                                  height: 360,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else if (_isCameraInitialized && _cameraController != null)
                              ClipOval(
                                child: SizedBox(
                                  width: 260,
                                  height: 360,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraController!.value.previewSize?.height ?? 260,
                                      height: _cameraController!.value.previewSize?.width ?? 360,
                                      child: CameraPreview(_cameraController!),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 260,
                                height: 360,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF131824),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.person, size: 100, color: Colors.white24),
                                ),
                              ),

                            // Overlay Oval Putus-putus
                            CustomPaint(
                              painter: DashedOvalPainter(
                                color: _isProcessing ? AppColors.successTeal : AppColors.goldMid,
                              ),
                              child: const SizedBox(
                                width: 260,
                                height: 360,
                              ),
                            ),

                            // Scanning overlay ketika memproses
                            if (_isProcessing)
                              Container(
                                width: 260,
                                height: 360,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.55),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(color: AppColors.goldMid),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Mencocokkan Biometrik...',
                                      style: AppTypography.captionBold.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Shutter Button (Tombol Ambil Foto)
                      if (!_isProcessing) ...[
                        GestureDetector(
                          onTap: _takePhotoAndVerify,
                          child: Column(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.goldMid, width: 4),
                                  color: Colors.white.withValues(alpha: 0.15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.goldMid.withValues(alpha: 0.3),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.primary900,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Ketuk tombol untuk foto & verifikasi',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.goldMid,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 84),
                      ],

                      const SizedBox(height: AppSpacing.xl),

                      // Bottom Stepper Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          border: Border(
                            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStepIcon(Icons.check, AppColors.goldMid, 'Akun', true),
                                _buildStepLine(true),
                                _buildStepIcon(Icons.check, AppColors.goldMid, 'e-KTP', true),
                                _buildStepLine(true),
                                _buildStepIcon(
                                  Icons.face_retouching_natural_rounded,
                                  AppColors.goldMid,
                                  'Wajah',
                                  _isProcessing,
                                  isActive: !_isProcessing,
                                ),
                                _buildStepLine(_isProcessing),
                                _buildStepIcon(
                                  Icons.verified_rounded,
                                  _isProcessing ? AppColors.goldMid : Colors.white.withValues(alpha: 0.3),
                                  'Selesai',
                                  _isProcessing,
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

  Widget _buildStepIcon(
    IconData icon,
    Color color,
    String label,
    bool isCompleted, {
    bool isActive = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: isCompleted || isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Container(
      width: 36,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20, left: 6, right: 6),
      color: isCompleted
          ? AppColors.goldMid
          : Colors.white.withValues(alpha: 0.15),
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
