import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../user/profile/presentation/providers/profile_provider.dart';

class DelegatePortalLoginScreen extends ConsumerStatefulWidget {
  const DelegatePortalLoginScreen({super.key});

  @override
  ConsumerState<DelegatePortalLoginScreen> createState() => _DelegatePortalLoginScreenState();
}

class _DelegatePortalLoginScreenState extends ConsumerState<DelegatePortalLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(userProfileProvider);
    final profile = profileState.valueOrNull;
    if (profile != null) {
      final idStr = profile.id.replaceAll('-', '');
      final shortId = idStr.length >= 4 ? idStr.substring(0, 4).toUpperCase() : '8829';
      _usernameController.text = 'DEL-$shortId';
    } else {
      _usernameController.text = 'DEL-8829';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Portal Delegasi', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFDEBB2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, color: AppColors.goldDark, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'DELEGATE ACCESS',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.goldDark,
                        letterSpacing: 1.0,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Welcome Title & Subtitle
              Text(
                'Welcome, Delegate',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 26,
                  color: AppColors.primary900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please authenticate to access the university legislative chambers.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username Delegat',
                      style: AppTypography.captionBold.copyWith(color: AppColors.navyMid),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your delegate ID',
                          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Password',
                      style: AppTypography.captionBold.copyWith(color: AppColors.navyMid),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (val) {
                                  setState(() {
                                    _rememberMe = val ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tautan reset kata sandi delegat telah dikirim ke email.')),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldDark.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.pushNamed('delegate-dashboard');
                          },
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masuk sebagai Delegat',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Bukan Delegat? Masuk Reguler
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Bukan Delegat? ',
                                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, fontSize: 13),
                              ),
                              Text(
                                'Masuk Reguler ',
                                style: AppTypography.captionBold.copyWith(color: AppColors.primary900, fontSize: 13),
                              ),
                              const Icon(Icons.open_in_new, color: AppColors.primary900, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Footer Security Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.textSecondary.withValues(alpha: 0.6), size: 24),
                  const SizedBox(width: 16),
                  Icon(Icons.gavel_outlined, color: AppColors.textSecondary.withValues(alpha: 0.6), size: 24),
                  const SizedBox(width: 16),
                  Icon(Icons.military_tech_outlined, color: AppColors.textSecondary.withValues(alpha: 0.6), size: 24),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Secured by Civic Glass™ Institutional Grade\nEncryption Protocol. All legislative sessions\nare recorded for transparency.',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
