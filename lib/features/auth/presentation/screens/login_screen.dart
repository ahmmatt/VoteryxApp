// lib/features/auth/presentation/screens/login_screen.dart
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nikController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final nik = _nikController.text.trim();
    final password = _passController.text;

    await ref.read(loginNotifierProvider.notifier).login(
          nik: nik,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen untuk navigasi atau tampil error
    ref.listen<LoginState>(loginNotifierProvider, (_, next) {
      if (next.error != null) {
        AppSnackBar.showError(context, next.error!);
        ref.read(loginNotifierProvider.notifier).clearError();
      }
      if (next.isSuccess) {
        final role = next.userRole ?? 'voter';
        if (role == 'admin') {
          context.go(AppRoutes.adminDashboard);
        } else {
          context.go(AppRoutes.dashboard);
        }
        ref.read(loginNotifierProvider.notifier).reset();
      }
    });

    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xxl),

                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary900,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary900.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.how_to_vote_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  'Voteryx',
                  style: AppTypography.displayHeading.copyWith(
                    color: AppColors.primary900,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Portal Pemilihan Digital Kampus',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Login Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang 👋',
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Masuk dengan NIK untuk mulai memilih.',
                        style: AppTypography.bodyText.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // NIK Field
                      Text(
                        'NOMOR INDUK KEPENDUDUKAN (NIK)',
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nikController,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        enabled: !isLoading,
                        decoration: _inputDecoration(
                          hint: 'Contoh: 3271234567890001',
                          prefixIcon: Icons.badge_outlined,
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'NIK tidak boleh kosong';
                          }
                          if (value.trim().length != 16) {
                            return 'NIK harus 16 digit';
                          }
                          if (!RegExp(r'^\d{16}$').hasMatch(value.trim())) {
                            return 'NIK hanya boleh berisi angka';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Password Field
                      Text(
                        'KATA SANDI',
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePassword,
                        enabled: !isLoading,
                        decoration: _inputDecoration(
                          hint: 'Minimal 8 karakter',
                          prefixIcon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.outline,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi tidak boleh kosong';
                          }
                          if (value.length < 8) {
                            return 'Kata sandi minimal 8 karakter';
                          }
                          return null;
                        },
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : () {
                            AppSnackBar.showInfo(
                              context,
                              'Fitur lupa kata sandi akan segera hadir.',
                            );
                          },
                          child: Text(
                            'Lupa Kata Sandi?',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.goldDark,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Login Button
                      GoldButton(
                        label: 'Masuk Sekarang',
                        icon: Icons.login_rounded,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _handleLogin,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Register link
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => context.push(AppRoutes.kycNikInput),
                              child: Text(
                                'Daftar di sini',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary900,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Security Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EDF7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        color: AppColors.primary800,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secured by Voteryx · End-to-End Encrypted',
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.primary900,
                          letterSpacing: 0.3,
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    String? counterText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.outline.withValues(alpha: 0.6),
        fontSize: 13,
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.outline, size: 20),
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
      fillColor: const Color(0xFFFAFBFE),
    );
  }
}
