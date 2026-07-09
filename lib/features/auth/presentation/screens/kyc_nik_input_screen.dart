// lib/features/auth/presentation/screens/kyc_nik_input_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

import '../providers/auth_provider.dart';

class KycNikInputScreen extends ConsumerStatefulWidget {
  const KycNikInputScreen({super.key});

  @override
  ConsumerState<KycNikInputScreen> createState() => _KycNikInputScreenState();
}

class _KycNikInputScreenState extends ConsumerState<KycNikInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isChecking = false;

  // Password strength (0-4)
  int _passwordStrength = 0;

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength;
  }

  String _strengthLabel(int strength) {
    switch (strength) {
      case 1:
        return 'Lemah';
      case 2:
        return 'Cukup';
      case 3:
        return 'Kuat';
      case 4:
        return 'Sangat Kuat';
      default:
        return '';
    }
  }

  Color _strengthColor(int strength) {
    switch (strength) {
      case 1:
        return AppColors.errorRed;
      case 2:
        return AppColors.warningAmber;
      case 3:
        return AppColors.successTeal;
      case 4:
        return const Color(0xFF00B894);
      default:
        return AppColors.outlineVariant;
    }
  }

  Future<void> _handleNext() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isChecking = true);

    try {
      final nik = _nikController.text.trim();
      final password = _passwordController.text;

      // Cek duplikasi NIK
      final isDuplicate = await ref
          .read(registrationProvider.notifier)
          .checkNikDuplicate(nik);

      if (!mounted) return;

      if (isDuplicate) {
        AppSnackBar.showError(
          context,
          'NIK ini sudah terdaftar. Silakan masuk.',
        );
        setState(() => _isChecking = false);
        return;
      }

      // Simpan data akun sementara
      ref.read(registrationProvider.notifier).setAccountData(
            nik: nik,
            password: password,
          );

      // Lanjut ke pemilihan metode verifikasi e-KTP (NFC atau Foto Manual)
      if (mounted) {
        context.push('/kyc/method-select');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Gagal memeriksa NIK. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

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
              context.go(AppRoutes.login);
            }
          },
        ),
        title: Text(
          'Buat Akun',
          style: AppTypography.headerTitle.copyWith(color: AppColors.primary900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),

              // Step Indicator
              _buildStepIndicator(currentStep: 0),
              const SizedBox(height: AppSpacing.xl),

              // Section title
              Text(
                'DATA AKUN',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'NIK kamu digunakan sebagai identitas unik yang terenkripsi. Tidak ada yang bisa membaca nilai aslinya.',
                style: AppTypography.bodyText.copyWith(fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.lg),

              // NIK Input
              _buildFieldLabel('NOMOR INDUK KEPENDUDUKAN (NIK)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nikController,
                keyboardType: TextInputType.number,
                maxLength: 16,
                style: AppTypography.bodyText.copyWith(color: AppColors.primary900),
                decoration: _inputDeco(
                  hint: '16 digit NIK kamu',
                  icon: Icons.badge_outlined,
                  counterText: '',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'NIK wajib diisi';
                  if (v.trim().length != 16) return 'NIK harus 16 digit';
                  if (!RegExp(r'^\d+$').hasMatch(v.trim())) {
                    return 'NIK hanya boleh berisi angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Password Input
              _buildFieldLabel('KATA SANDI'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onChanged: (v) {
                  setState(() => _passwordStrength = _calculatePasswordStrength(v));
                },
                decoration: _inputDeco(
                  hint: 'Minimal 8 karakter',
                  icon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                  if (v.length < 8) return 'Minimal 8 karakter';
                  return null;
                },
              ),

              // Password Strength
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _passwordStrength / 4,
                          minHeight: 5,
                          backgroundColor: AppColors.outlineVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _strengthColor(_passwordStrength),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _strengthLabel(_passwordStrength),
                      style: AppTypography.captionBold.copyWith(
                        color: _strengthColor(_passwordStrength),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),

              // Confirm Password
              _buildFieldLabel('KONFIRMASI KATA SANDI'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: _inputDeco(
                  hint: 'Ulangi kata sandi',
                  icon: Icons.lock_reset_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi kata sandi wajib diisi';
                  if (v != _passwordController.text) {
                    return 'Kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Info Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warningAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.warningAmber,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'NIK hanya akan disimpan dalam bentuk hash terenkripsi. Voteryx tidak pernah menyimpan NIK aslimu.',
                        style: AppTypography.bodyText.copyWith(
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Next Button
              GoldButton(
                label: 'Lanjutkan',
                icon: Icons.arrow_forward_rounded,
                isLoading: _isChecking,
                onPressed: _isChecking ? null : _handleNext,
              ),
              const SizedBox(height: AppSpacing.md),

              // Login link
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: AppTypography.bodyText.copyWith(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Text(
                        'Masuk di sini',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTypography.captionBold.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    String? counterText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.outline.withValues(alpha: 0.55),
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
      suffixIcon: suffixIcon,
      counterText: counterText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary800, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildStepIndicator({required int currentStep}) {
    const steps = ['Akun', 'KTP', 'Wajah', 'Selesai'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Divider
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
            color: isActive
                ? AppColors.goldDark
                : isDone
                    ? AppColors.goldDark
                    : AppColors.outline,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
