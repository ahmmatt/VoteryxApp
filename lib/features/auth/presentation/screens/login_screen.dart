// lib/features/auth/presentation/screens/login_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gold_button.dart';

// ── Local UI state ────────────────────────────────────────────────────────────

/// State lokal untuk LoginScreen.
/// Riverpod provider terpisah agar mudah di-extend ke auth logic nantinya.
class _LoginState {
  const _LoginState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;

  _LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? errorMessage,
    bool clearError = false,
  }) {
    return _LoginState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class _LoginNotifier extends Notifier<_LoginState> {
  @override
  _LoginState build() => const _LoginState();

  void togglePassword() => state = state.copyWith(
        obscurePassword: !state.obscurePassword,
      );

  void setLoading(bool v) => state = state.copyWith(isLoading: v);

  void setError(String? msg) => state = state.copyWith(errorMessage: msg);

  void clearError() => state = state.copyWith(clearError: true);
}

final _loginProvider = NotifierProvider<_LoginNotifier, _LoginState>(
  _LoginNotifier.new,
);

// ── Screen ────────────────────────────────────────────────────────────────────

/// Halaman Login Voteryx.
///
/// Widget tree (ringkas):
/// ```
/// LoginScreen (ConsumerStatefulWidget)
///  └─ Scaffold (extendBodyBehindAppBar: true)
///      ├─ _GradientBackground          ← halaman gradient + top wave navy
///      └─ SafeArea
///          └─ LayoutBuilder
///              └─ SingleChildScrollView
///                  └─ ConstrainedBox (maxWidth 480, centered)
///                      └─ Column
///                          ├─ _LogoSection                ← logo + tagline
///                          ├─ _FormCard (GlassCard)
///                          │    ├─ AppTextField (NIM)
///                          │    ├─ AppTextField (Password)
///                          │    ├─ _ForgotPasswordLink
///                          │    ├─ _ErrorBanner (conditional)
///                          │    └─ GoldButton "Masuk"
///                          └─ _RegisterPrompt             ← link daftar
/// ```
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nimCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _nimCtrl.dispose();
    _passCtrl.dispose();
    _passFocus.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    ref.read(_loginProvider.notifier).clearError();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(_loginProvider.notifier).setLoading(true);

    // TODO(auth): Hubungkan ke Supabase auth di sini.
    // Contoh nanti:
    //   await ref.read(authRepositoryProvider).login(
    //     nim: _nimCtrl.text.trim(),
    //     password: _passCtrl.text,
    //   );
    //   context.go(AppRoutes.dashboard);

    // Simulasi delay untuk demo loading state
    await Future.delayed(const Duration(seconds: 2));

    ref.read(_loginProvider.notifier).setLoading(false);

    debugPrint('[LoginScreen] TODO: Login dengan NIM ${_nimCtrl.text.trim()}');

    // Untuk sekarang, tampilkan info bahwa belum terhubung ke backend
    ref.read(_loginProvider.notifier).setError(
          'Backend belum terhubung. '
          'Implementasi Supabase auth menyusul.',
        );
  }

  void _handleForgotPassword() {
    // TODO(auth): Navigasi ke halaman lupa password
    debugPrint('[LoginScreen] TODO: Halaman lupa password');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur lupa password segera hadir.')),
    );
  }

  void _handleRegister() {
    // TODO(auth): Navigasi ke halaman registrasi / onboarding
    debugPrint('[LoginScreen] TODO: Navigasi ke onboarding/register');
    context.go(AppRoutes.onboarding);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(_loginProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // Tidak ada AppBar — header ditangani oleh _LogoSection
        body: Stack(
          children: [
            // ── Background gradient ───────────────────────────────────
            const _GradientBackground(),

            // ── Content ───────────────────────────────────────────────
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pagePad,
                      vertical: constraints.maxHeight > 700
                          ? AppSpacing.lg
                          : AppSpacing.md,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        // Batas lebar untuk tablet/desktop
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo + tagline
                                const _LogoSection(),
                                SizedBox(
                                  height: constraints.maxHeight > 700
                                      ? AppSpacing.xl
                                      : AppSpacing.lg,
                                ),

                                // Form card
                                _FormCard(
                                  formKey: _formKey,
                                  nimCtrl: _nimCtrl,
                                  passCtrl: _passCtrl,
                                  passFocus: _passFocus,
                                  loginState: loginState,
                                  onForgotPassword: _handleForgotPassword,
                                  onLogin: _handleLogin,
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                // Link daftar
                                _RegisterPrompt(onRegister: _handleRegister),
                                const SizedBox(height: AppSpacing.xl),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// Background: gradient biru-putih + panel navy atas.
class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        // Panel navy atas dengan wave clip
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: height * 0.30,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
          ),
        ),
        // Sisa halaman: gradient biru-putih
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.pageGradient,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper untuk wave di bawah panel navy.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 32);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 42,
      size.width, size.height - 16,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

/// Logo Voteryx + tagline + universitas label.
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 700;

    return Column(
      children: [
        SizedBox(height: isCompact ? AppSpacing.md : AppSpacing.xl),

        // Logo mark — V dalam hexagon
        _LogoMark(size: isCompact ? 64 : 80),
        SizedBox(height: isCompact ? AppSpacing.sm : AppSpacing.md),

        // App name
        Text(
          'Voteryx',
          style: AppTypography.displayHeading.copyWith(
            color: Colors.white,
            fontSize: isCompact ? 26 : 32,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Tagline
        Text(
          'Sistem E-Voting Kampus Terpercaya',
          style: AppTypography.bodyText.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (!isCompact) const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// Logo mark: "V" dengan lingkaran + aksen gold.
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3D70), Color(0xFF0F1F3D)],
        ),
        border: Border.all(color: AppColors.goldMid, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldMid.withValues(alpha: 0.35),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.goldGradient.createShader(bounds),
          child: Text(
            'V',
            style: AppTypography.displayHeading.copyWith(
              fontSize: size * 0.45,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass card berisi form login.
class _FormCard extends ConsumerWidget {
  const _FormCard({
    required this.formKey,
    required this.nimCtrl,
    required this.passCtrl,
    required this.passFocus,
    required this.loginState,
    required this.onForgotPassword,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nimCtrl;
  final TextEditingController passCtrl;
  final FocusNode passFocus;
  final _LoginState loginState;
  final VoidCallback onForgotPassword;
  final Future<void> Function() onLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navyMid.withValues(alpha: 0.08),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card header
                Text(
                  'Masuk ke Akun Anda',
                  style: AppTypography.cardTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Gunakan NIM dan password yang terdaftar.',
                  style: AppTypography.bodyText,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Field NIM ────────────────────────────────────────
                AppTextField(
                  label: 'NIM',
                  hint: 'Masukkan 10 digit NIM Anda',
                  controller: nimCtrl,
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: Validators.nimLogin,
                  onChanged: (_) {
                    if (loginState.errorMessage != null) {
                      ref.read(_loginProvider.notifier).clearError();
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Field Password ────────────────────────────────────
                AppTextField(
                  label: 'PASSWORD',
                  hint: 'Minimal 8 karakter',
                  controller: passCtrl,
                  focusNode: passFocus,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: loginState.obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: Validators.loginPassword,
                  onChanged: (_) {
                    if (loginState.errorMessage != null) {
                      ref.read(_loginProvider.notifier).clearError();
                    }
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginState.obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.outline,
                    ),
                    onPressed: () =>
                        ref.read(_loginProvider.notifier).togglePassword(),
                    tooltip: loginState.obscurePassword
                        ? 'Tampilkan password'
                        : 'Sembunyikan password',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Lupa password ─────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lupa password?',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.navy600,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.navy600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Error banner ──────────────────────────────────────
                if (loginState.errorMessage != null) ...[
                  _ErrorBanner(message: loginState.errorMessage!),
                  const SizedBox(height: AppSpacing.md),
                ],

                // ── Tombol Masuk ──────────────────────────────────────
                GoldButton(
                  label: 'Masuk',
                  onPressed: loginState.isLoading ? null : onLogin,
                  isLoading: loginState.isLoading,
                  height: 52,
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Divider "atau" ────────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                      child: Text(
                        'atau',
                        style: AppTypography.caption.copyWith(fontSize: 12),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // ── SSO button ────────────────────────────────────────
                _SsoButton(
                  onTap: () => debugPrint('[LoginScreen] TODO: SSO login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Banner error merah di atas tombol Masuk.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.errorRed.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.errorRed,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(
                color: AppColors.errorRed,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol SSO (Google Workspace / kampus).
class _SsoButton extends StatelessWidget {
  const _SsoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google G ikon (sederhana, tanpa package eksternal)
              _GoogleIcon(size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Masuk dengan SSO Kampus',
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon Google (custom paint — tidak butuh package tambahan).
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GooglePainter(),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final cx = r, cy = r;

    // Lingkaran abu background
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = const Color(0xFFF2F2F2),
    );

    // Teks "G" sederhana
    final tp = TextPainter(
      text: TextSpan(
        text: 'G',
        style: TextStyle(
          color: const Color(0xFF4285F4),
          fontSize: size.width * 0.65,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(cx - tp.width / 2, cy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_GooglePainter old) => false;
}

/// Footer dengan link ke halaman registrasi.
class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({required this.onRegister});
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun? ',
          style: AppTypography.bodyText.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: onRegister,
          child: Text(
            'Daftar di sini',
            style: AppTypography.bodyText.copyWith(
              color: AppColors.goldDark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.goldDark,
            ),
          ),
        ),
      ],
    );
  }
}
