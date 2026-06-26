import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateLoginScreen extends StatelessWidget {
  const DelegateLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
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
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              // Login Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDF5),
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 14, color: AppColors.goldDark),
                            const SizedBox(width: 6),
                            Text(
                              'DELEGATE ACCESS',
                              style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 10, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    Text('Welcome, Delegate', style: AppTypography.displayHeading.copyWith(fontSize: 22)),
                    const SizedBox(height: 8),
                    Text(
                      'Please authenticate to access the university legislative chambers.',
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Username Field
                    Text('Username Delegat', style: AppTypography.captionBold.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.xs),
                    _buildInputField(hint: 'Enter your delegate ID', prefixIcon: Icons.person_outline),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Password Field
                    Text('Password', style: AppTypography.captionBold.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.xs),
                    _buildInputField(hint: '••••••••', prefixIcon: Icons.lock_outline, suffixIcon: Icons.visibility_outlined, obscureText: true),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Remember & Forgot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: false,
                                onChanged: (v) {},
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        Text('Forgot password?', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Bypass directly to registration form for testing
                            context.pushNamed('delegate-registration');
                          },
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Masuk sebagai Delegat', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                             const SizedBox(width: 8),
                             const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                           ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    const Divider(color: AppColors.outlineVariant, thickness: 0.5),
                    const SizedBox(height: AppSpacing.lg),
                    
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Bukan Delegat? ',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: 'Masuk Reguler ',
                              style: AppTypography.captionBold.copyWith(color: AppColors.primary900),
                            ),
                            const WidgetSpan(
                              child: Icon(Icons.open_in_new, size: 12, color: AppColors.primary900),
                              alignment: PlaceholderAlignment.middle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.outline, size: 24),
                  const SizedBox(width: 16),
                  const Icon(Icons.gavel_outlined, color: AppColors.outline, size: 24),
                  const SizedBox(width: 16),
                  const Icon(Icons.verified_user_outlined, color: AppColors.outline, size: 24),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Secured by Civic Glass™ Institutional Grade\nEncryption Protocol. All legislative sessions\nare recorded for transparency.',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.outline),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String hint, required IconData prefixIcon, IconData? suffixIcon, bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
          prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textSecondary, size: 20) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
