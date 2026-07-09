// lib/features/auth/presentation/screens/kyc_method_select_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';

class KycMethodSelectScreen extends StatelessWidget {
  const KycMethodSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.kycNikInput);
            }
          },
        ),
        title: Text(
          'Verifikasi e-KTP',
          style: AppTypography.headerTitle.copyWith(color: AppColors.primary900),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator (Step 1 -> KTP)
              _buildStepIndicator(currentStep: 1),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'PILIH METODE PEMINDAIAN',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pindai e-KTP kamu untuk mengambil data identitas (Nama Lengkap, Umur, Alamat, dll) secara otomatis dan akurat.',
                style: AppTypography.bodyText.copyWith(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Opsi 1: NFC Scan (Rekomendasi)
              _buildOptionCard(
                context: context,
                icon: Icons.nfc_rounded,
                iconColor: AppColors.goldMid,
                title: 'Scan NFC e-KTP (Rekomendasi)',
                description:
                    'Tempelkan e-KTP ke belakang HP. Data terbaca instan dalam 3 detik, terenkripsi, dan 100% akurat.',
                badgeText: 'INSTAN & AMAN',
                badgeColor: AppColors.goldMid,
                onTap: () => context.push('/kyc/nfc-scan'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Opsi 2: Foto Kamera
              _buildOptionCard(
                context: context,
                icon: Icons.camera_alt_outlined,
                iconColor: AppColors.primary800,
                title: 'Foto e-KTP dengan Kamera',
                description:
                    'Ambil foto fisik e-KTP menggunakan kamera HP jika sensor NFC di ponselmu tidak tersedia.',
                badgeText: 'ALTERNATIF',
                badgeColor: AppColors.navy600,
                onTap: () => context.push('/kyc/camera'),
              ),

              const Spacer(),

              // Security Note
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, color: AppColors.successTeal, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Data KTP dipindai secara lokal di perangkat ini dan langsung dicocokkan dengan NIK yang kamu masukkan.',
                        style: AppTypography.bodyText.copyWith(fontSize: 11, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.cardTitle.copyWith(
                            color: AppColors.primary900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: AppTypography.captionBold.copyWith(
                            color: badgeColor,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.outline, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required int currentStep}) {
    const steps = ['Akun', 'KTP', 'Wajah', 'Selesai'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = (index - 1) ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: stepIndex < currentStep
                  ? AppColors.goldMid
                  : AppColors.outlineVariant,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentStep;
        final isDone = stepIndex < currentStep;
        return _StepDot(
          label: steps[stepIndex],
          isActive: isActive,
          isDone: isDone,
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  final String label;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.goldMid
                : isDone
                    ? AppColors.goldDark
                    : AppColors.outlineVariant.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : isActive
                  ? const Icon(Icons.edit, color: Colors.white, size: 14)
                  : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: isActive || isDone
                ? AppColors.goldDark
                : AppColors.outline,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
