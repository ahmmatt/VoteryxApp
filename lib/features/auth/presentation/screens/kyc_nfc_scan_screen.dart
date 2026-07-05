import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

class KycNfcScanScreen extends StatelessWidget {
  const KycNfcScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.goldMid, width: 2),
                ),
                child: const Icon(
                  Icons.nfc,
                  size: 80,
                  color: AppColors.goldMid,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Tempelkan e-KTP',
                style: AppTypography.displayHeading.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Dekatkan e-KTP Anda ke bagian belakang ponsel untuk memindai data secara otomatis menggunakan NFC.',
                style: AppTypography.bodyText.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              GoldButton(
                label: 'Simulasi Berhasil NFC',
                onPressed: () {
                  context.go('/kyc/liveness');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // FALLBACK BUTTON (UX Fix)
              TextButton(
                onPressed: () {
                  // Fallback ke foto manual jika NFC gagal
                  context.go('/kyc/liveness'); // Secara logika akan ke /kyc/manual-photo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Beralih ke mode foto manual.'),
                      backgroundColor: AppColors.navy600,
                    ),
                  );
                },
                child: Text(
                  'NFC bermasalah? Lewati & Gunakan Foto Manual',
                  style: AppTypography.captionBold.copyWith(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
