// lib/features/delegation/presentation/screens/delegate_vote_processing_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Layar animasi pemrosesan / enkripsi suara.
/// Menampilkan hash latar, progress step, dan badge batch ID.
/// Otomatis navigate ke halaman sukses setelah 3 detik.
class DelegateVoteProcessingScreen extends StatefulWidget {
  const DelegateVoteProcessingScreen({super.key});

  @override
  State<DelegateVoteProcessingScreen> createState() =>
      _DelegateVoteProcessingScreenState();
}

class _DelegateVoteProcessingScreenState
    extends State<DelegateVoteProcessingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    // Slow outer ring rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Progress bar animation (65% over 2.5 s)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    // Navigate to success after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.pushReplacementNamed('delegate-vote-success');
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cryptographic hash background
          _buildHashBackground(),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Animated lock icon
                  _buildAnimatedLock(),
                  const SizedBox(height: 40),
                  // Title
                  Text(
                    'Mengamankan Mandat',
                    style: AppTypography.displayHeading.copyWith(
                      fontSize: 24,
                      color: AppColors.primary900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Suara sedang diproses melalui\nlapisan enkripsi asimetris.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Progress steps card
                  _buildProgressCard(),
                  const Spacer(),
                  // Batch hash footer
                  _buildBatchHashFooter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Hash Background ───────────────────────────
  Widget _buildHashBackground() {
    final rng = Random(42); // Seed tetap agar tidak berubah saat rebuild
    final hashes = List.generate(
      60,
      (_) => List.generate(
        8,
        (_) => '0123456789ABCDEF'[rng.nextInt(16)],
      ).join(),
    );

    return Positioned.fill(
      child: Opacity(
        opacity: 0.055,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.5,
          ),
          itemCount: hashes.length,
          itemBuilder: (_, i) => Center(
            child: Text(
              hashes[i],
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: AppColors.primary900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────── Animated Lock Icon ────────────────────────
  Widget _buildAnimatedLock() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating dashed ring
          AnimatedBuilder(
            animation: _rotateController,
            builder: (_, __) => Transform.rotate(
              angle: _rotateController.value * 2 * pi,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.6),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // Inner static ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.outlineVariant.withOpacity(0.4),
                width: 1,
              ),
            ),
          ),
          // Lock circle
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary900,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary900.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(Icons.lock, color: Colors.white, size: 32),
              ),
              // ×47 badge
              Transform.translate(
                offset: const Offset(12, -6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldMid,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '×47',
                    style: AppTypography.captionBold.copyWith(
                      color: AppColors.primary900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────── Progress Steps Card ───────────────────────
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step 1 — done
          _buildStep(
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFD1FAE5),
            title: 'Menganonimkan 47 identitas...',
            subtitle: 'Berhasil',
            subtitleColor: const Color(0xFF10B981),
            isDone: true,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 20),
          // Step 2 — in progress
          _buildProgressStep(),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 20),
          // Step 3 — pending
          _buildStep(
            icon: Icons.cloud_upload_outlined,
            iconColor: AppColors.outline,
            iconBg: AppColors.outlineVariant.withOpacity(0.3),
            title: 'Mengirim ke jaringan...',
            isDone: false,
            isPending: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    required bool isDone,
    bool isPending = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isPending ? AppColors.outline : AppColors.primary900,
                  fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: subtitleColor ?? AppColors.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressStep() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.goldMid.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.vpn_key_rounded,
            color: AppColors.goldDark,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mengenkripsi 47 suara...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              // Animated progress bar
              AnimatedBuilder(
                animation: _progressController,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progressController.value * 0.65,
                    minHeight: 5,
                    backgroundColor: AppColors.outlineVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.goldDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────── Batch Hash Footer ─────────────────────────
  Widget _buildBatchHashFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            'BATCH HASH ID',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'BATCH-e3b0c482...×47',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.goldDark,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
