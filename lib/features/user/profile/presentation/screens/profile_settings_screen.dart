import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Pengaturan Profil', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil disimpan.')),
              );
              Navigator.of(context).pop();
            },
            child: Text(
              'Simpan',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: AppSpacing.xxl),
            _buildEditableField(
              label: 'Nama Lengkap',
              initialValue: 'Budi Santoso',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildEditableField(
              label: 'Nomor Telepon',
              initialValue: '+62 812 3456 7890',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildEditableField(
              label: 'Alamat Email',
              initialValue: 'budi.santoso@univ.ac.id',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLockedField(
              label: 'NIK Terverifikasi',
              value: '**** **** **** 8901',
              icon: Icons.badge_outlined,
              helperText: 'NIK disimpan aman dan tidak ditampilkan penuh.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildEditableField(
              label: 'NIM Mahasiswa (Opsional)',
              initialValue: '1202190045',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildEditableField(
              label: 'Institusi/Fakultas (Opsional)',
              initialValue: 'Fakultas Ilmu Komputer',
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary900,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'B',
                style: AppTypography.displayHeading.copyWith(color: Colors.white, fontSize: 40),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.goldMid,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 3),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'GANTI FOTO PROFIL',
          style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.captionBold),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.input),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: initialValue,
            style: AppTypography.bodyText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedField({
    required String label,
    required String value,
    required IconData icon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        // Custom Dashed Border Container
        CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.outlineVariant,
            radius: AppRadius.input,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    // A simple way to draw dashed path
    // For a robust dashed path, normally we'd use path_drawing package,
    // but here we can manually approximate it or just draw solid if it's too complex.
    // Given the constraints, let's use a solid border but with opacity to look subtle,
    // OR implement a basic dash loop.
    
    // Fallback to solid border with lighter color for simplicity and performance
    // without external dependencies.
    // If you strictly want dashed, you'd calculate path metrics.
    // I'll implement a basic dash using PathMetrics:
    
    Path dashedPath = Path();
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
      distance = 0.0; // Reset for next subpath if any
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

