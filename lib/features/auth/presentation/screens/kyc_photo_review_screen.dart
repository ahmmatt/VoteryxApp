// lib/features/auth/presentation/screens/kyc_photo_review_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/features/auth/data/mock/mock_ktp_database.dart';
import '../providers/auth_provider.dart';

class KycPhotoReviewScreen extends ConsumerStatefulWidget {
  const KycPhotoReviewScreen({super.key});

  @override
  ConsumerState<KycPhotoReviewScreen> createState() => _KycPhotoReviewScreenState();
}

class _KycPhotoReviewScreenState extends ConsumerState<KycPhotoReviewScreen> {
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Ambil data hasil pemindaian OCR/NFC atau lookup ke MockKtpDatabase
    final currentNik = ref.read(registrationProvider).nik ?? '7307052504070001';
    final ktp = ref.read(registrationProvider).ktpData ?? MockKtpDatabase.lookupByNik(currentNik);

    _nameController = TextEditingController(text: ktp.fullName);
    _birthDateController = TextEditingController(
        text: ktp.birthDate ?? '${ktp.birthPlace ?? "SINJAI"}, 15 Mei 2003 (21 Tahun)');
    _genderController = TextEditingController(text: ktp.gender ?? 'Laki-laki');
    _addressController = TextEditingController(text: ktp.address ?? 'JL. JENDERAL SUDIRMAN NO. 1, BALANGNIPA, SINJAI UTARA');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _confirmAndProceed() {
    final nik = ref.read(registrationProvider).nik ?? '7307052504070001';
    final fullName = _nameController.text.trim().isEmpty ? 'WARGA SINJAI' : _nameController.text.trim();
    final currentPath = ref.read(registrationProvider).ktpData?.ktpImagePath;
    final currentKtp = ref.read(registrationProvider).ktpData;

    // Simpan data KTP yang telah dikonfirmasi ke registrationProvider (tanpa fakultas, karena diisikan pas login di profil)
    ref.read(registrationProvider.notifier).setKtpData(
          KtpData(
            nik: nik,
            fullName: fullName,
            birthPlace: currentKtp?.birthPlace ?? 'SINJAI',
            birthDate: _birthDateController.text.trim(),
            gender: _genderController.text.trim(),
            address: _addressController.text.trim(),
            ktpImagePath: currentPath,
          ),
        );

    // Lanjut ke langkah verifikasi wajah (Step 3)
    context.push(AppRoutes.kycLiveness);
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.kycMethodSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nik = ref.watch(registrationProvider).nik ?? '3273 0101 0190 0001';
    final ktpImagePath = ref.watch(registrationProvider).ktpData?.ktpImagePath;

    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F8),
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleBack,
        ),
        title: Text(
          'Konfirmasi Data KTP',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator (Step 2 -> KTP)
            _buildStepIndicator(currentStep: 1),
            const SizedBox(height: AppSpacing.xl),

            Text(
              'HASIL PEMINDAIAN e-KTP',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Periksa kembali data yang terdeteksi dari e-KTP kamu. Kamu bisa memperbaiki teks jika ada yang salah baca.',
              style: AppTypography.bodyText.copyWith(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.md),

            // Photo Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ktpImagePath != null && File(ktpImagePath).existsSync()
                        ? Image.file(
                            File(ktpImagePath),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            'https://images.unsplash.com/photo-1633409361618-c73427e4e206?q=80&w=800&auto=format&fit=crop',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPill('Terbaca Jelas'),
                      const SizedBox(width: 8),
                      _buildPill('NFC / OCR Valid'),
                      const SizedBox(width: 8),
                      _buildPill('Pencahayaan OK'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'DATA IDENTITAS TERDETEKSI',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Data Card (Editable Form Preview)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataPreviewField('NOMOR INDUK KEPENDUDUKAN (NIK)', nik, isReadOnly: true),
                  const SizedBox(height: AppSpacing.md),
                  _buildEditableField('NAMA LENGKAP', _nameController, Icons.person_outline),
                  const SizedBox(height: AppSpacing.md),
                  _buildEditableField('TEMPAT, TANGGAL LAHIR (UMUR)', _birthDateController, Icons.calendar_today_outlined),
                  const SizedBox(height: AppSpacing.md),
                  _buildEditableField('JENIS KELAMIN', _genderController, Icons.wc_outlined),
                  const SizedBox(height: AppSpacing.md),
                  _buildEditableField('ALAMAT / DOMISILI', _addressController, Icons.location_on_outlined),

                  const SizedBox(height: AppSpacing.lg),

                  // Security Note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline, color: AppColors.goldDark, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Data identitas disinkronisasikan secara aman dan terenkripsi untuk kebutuhan verifikasi suara mahasiswa.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.goldDark,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Buttons
            GoldButton(
              label: 'Konfirmasi Data & Lanjutkan',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _confirmAndProceed,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primary900),
                label: Text(
                  'Ulangi Pemindaian',
                  style: AppTypography.buttonText.copyWith(color: AppColors.primary900),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.outline.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDEF7EC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF31C48D).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF057A55), size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.captionBold.copyWith(
              color: const Color(0xFF057A55),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPreviewField(String label, String value, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(
            value,
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.primary900,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: AppTypography.bodyText.copyWith(color: AppColors.primary900, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary800, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
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
