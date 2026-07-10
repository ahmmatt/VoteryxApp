// lib/features/auth/presentation/screens/kyc_camera_screen.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import 'package:voteryxapp/features/auth/data/mock/mock_ktp_database.dart';
import '../providers/auth_provider.dart';

class KycCameraScreen extends ConsumerStatefulWidget {
  const KycCameraScreen({super.key});

  @override
  ConsumerState<KycCameraScreen> createState() => _KycCameraScreenState();
}

class _KycCameraScreenState extends ConsumerState<KycCameraScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Cari kamera belakang (back camera) untuk foto KTP
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
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

  Future<void> _takePhoto() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      String? imagePath;
      if (_isCameraInitialized && _cameraController != null) {
        final xFile = await _cameraController!.takePicture();
        imagePath = xFile.path;
      }

      if (!mounted) return;

      final nik = ref.read(registrationProvider).nik ?? '7307052504070001';
      
      // Gunakan MockKtpDatabase untuk menarik data asli dari NIK
      final ktpData = MockKtpDatabase.lookupByNik(nik, ktpImagePath: imagePath);

      // Simpan data ke dalam registrationProvider
      ref.read(registrationProvider.notifier).setKtpData(ktpData);

      context.push('/kyc/photo-review');
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Gagal mengambil foto. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.kycMethodSelect);
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
                  _buildIconButton(Icons.arrow_back, _handleBack),
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
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Text(
                'Posisikan e-KTP di dalam bingkai kuning',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
            
            const Spacer(),
            
            // Camera Viewfinder (Real Camera Feed + Frame Overlay)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AspectRatio(
                aspectRatio: 1.6, // Typical ID card aspect ratio
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Camera Preview or Fallback Loading/Simulation
                      if (_isCameraInitialized && _cameraController != null)
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 100,
                            height: 100 / _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          ),
                        )
                      else
                        Container(
                          color: Colors.white.withValues(alpha: 0.05),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(color: AppColors.goldMid),
                                const SizedBox(height: 12),
                                Text(
                                  'Menyiapkan Kamera...',
                                  style: AppTypography.captionBold.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // Card Overlay Silhouette
                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: _isCameraInitialized ? 0.2 : 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 24),
                            // Text Line Silhouettes (Kiri - NIK, Nama, TTL, Alamat dll)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSkeletonLine(double.infinity),
                                  _buildSkeletonLine(120),
                                  _buildSkeletonLine(80),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Photo Silhouette (Kanan - Pasfoto Warga)
                            Container(
                              width: 70,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Icon(Icons.person, color: Colors.white.withValues(alpha: 0.4), size: 40),
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                      ),
                      
                      // Yellow Corner Brackets
                      const Positioned(top: 0, left: 0, child: _CornerBracket(angle: 0)),
                      const Positioned(top: 0, right: 0, child: _CornerBracket(angle: 1.5708)),
                      const Positioned(bottom: 0, right: 0, child: _CornerBracket(angle: 3.14159)),
                      const Positioned(bottom: 0, left: 0, child: _CornerBracket(angle: 4.71239)),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Sub Instruction
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 2, height: 12, color: AppColors.goldMid),
                const SizedBox(width: 8),
                Text(
                  'Pastikan e-KTP rata, jelas, dan terkena cahaya cukup',
                  style: AppTypography.captionBold.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 2, height: 12, color: AppColors.goldMid),
              ],
            ),
            
            const Spacer(),
            
            // Privacy Note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: Colors.white.withValues(alpha: 0.5), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Foto hanya diproses secara lokal di perangkat, tidak diunggah sembarangan',
                      style: AppTypography.captionBold.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
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
                  // Gallery / Error Demo
                  _buildIconButton(Icons.image_outlined, () {
                    context.push('/kyc/photo-error');
                  }),
                  
                  // Capture Button
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                      ),
                      child: Center(
                        child: _isCapturing
                            ? const CircularProgressIndicator(color: AppColors.goldMid)
                            : Container(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  color: AppColors.goldMid,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                              ),
                      ),
                    ),
                  ),
                  
                  // Flip Camera
                  _buildIconButton(Icons.cameraswitch_outlined, () {
                    _initializeCamera();
                  }),
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
          color: Colors.white.withValues(alpha: 0.1),
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
        color: Colors.white.withValues(alpha: 0.1),
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
