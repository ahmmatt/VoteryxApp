import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/features/auth/data/mock/mock_ktp_database.dart';
import '../providers/auth_provider.dart';

class KycNfcScanScreen extends ConsumerWidget {
  const KycNfcScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/kyc/method-select');
            }
          },
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
                  final nik = ref.read(registrationProvider).nik ?? '7307052504070001';
                  final ktpData = MockKtpDatabase.lookupByNik(nik);
                  ref.read(registrationProvider.notifier).setKtpData(ktpData);
                  context.push('/kyc/photo-review');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // FALLBACK BUTTON (UX Fix)
              TextButton(
                onPressed: () {
                  // Fallback ke foto manual jika NFC gagal
                  context.push('/kyc/camera');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Beralih ke mode foto kamera manual.'),
                      backgroundColor: AppColors.navy600,
                    ),
                  );
                },
                child: Text(
                  'NFC bermasalah? Beralih ke Foto Kamera Manual',
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
