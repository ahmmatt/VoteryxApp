// lib/features/admin/audit_log/presentation/screens/admin_kyc_dispute_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminKycDisputeScreen extends StatefulWidget {
  const AdminKycDisputeScreen({super.key});

  @override
  State<AdminKycDisputeScreen> createState() => _AdminKycDisputeScreenState();
}

class _AdminKycDisputeScreenState extends State<AdminKycDisputeScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning banner
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildWarningBanner(),
            ),
            // User card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildUserCard(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Issue indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildIssueChip(),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Attempt info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildAttemptInfo(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Photo comparison
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildPhotoComparison(),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Audit note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildAuditNote(),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildActionButtons(context),
            ),
            const SizedBox(height: AppSpacing.md),
            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: _buildFooter(context),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text('Sengketa KYC', style: AppTypography.headerTitle),
      actions: [
        // Pending badge
        Container(
          margin: const EdgeInsets.only(right: AppSpacing.md),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.errorRed,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          alignment: Alignment.center,
          child: Text(
            '3 Pending',
            style: AppTypography.captionBold.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ── Warning Banner ────────────────────────────────────────────────────────
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppRadius.cardInner),
        border: Border.all(color: AppColors.warningAmber.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.goldDark, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Anda hanya dapat melihat status verifikasi, bukan pilihan suara pengguna. Hak akses audit terbatas pada identitas resmi.',
              style: AppTypography.bodyText.copyWith(
                color: AppColors.primary900,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── User Card ─────────────────────────────────────────────────────────────
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/150?img=47',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maya Putri Lestari',
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.primary900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'NIM: 2023008812',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Issue Chip ────────────────────────────────────────────────────────────
  Widget _buildIssueChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.face_retouching_natural,
              color: AppColors.errorRed, size: 18),
          const SizedBox(width: 8),
          Text(
            'Wajah tidak cocok dengan foto KTP',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.errorRed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Attempt Info ──────────────────────────────────────────────────────────
  Widget _buildAttemptInfo() {
    return Row(
      children: [
        const Icon(Icons.history, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '3 percobaan gagal · Terakhir: 10 menit lalu',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ── Photo Comparison ──────────────────────────────────────────────────────
  Widget _buildPhotoComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foto KTP',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPhotoBox(
                    imageUrl: 'https://picsum.photos/200/130?random=10',
                    isKtp: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Liveness',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPhotoBox(
                    imageUrl: 'https://picsum.photos/200/130?random=20',
                    isKtp: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoBox({required String imageUrl, required bool isKtp}) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(AppRadius.cardInner),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1A1A2E),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      color: Colors.white54, size: 32),
                ),
              ),
            ),
          ),
          // Overlay for liveness with face scan circle
          if (!isKtp)
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Audit Note ────────────────────────────────────────────────────────────
  Widget _buildAuditNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Audit Decision Note',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _noteController,
          maxLines: 4,
          style: AppTypography.bodyText.copyWith(
            color: AppColors.primary900,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Catatan audit (wajib diisi)...',
            hintStyle: AppTypography.bodyText.copyWith(
              color: AppColors.outline,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.cardInner),
              borderSide: BorderSide(
                  color: AppColors.outlineVariant.withOpacity(0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.cardInner),
              borderSide: BorderSide(
                  color: AppColors.outlineVariant.withOpacity(0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.cardInner),
              borderSide: const BorderSide(color: AppColors.goldMid),
            ),
          ),
        ),
      ],
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.errorRed, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.cardInner),
                ),
              ),
              child: Text(
                'TOLAK',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary900,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.cardInner),
                ),
              ),
              icon: const Icon(Icons.verified_user_outlined,
                  color: Colors.white, size: 20),
              label: Text(
                'APPROVE\nMANUAL',
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Text(
          'CASE ID: VTYX-8812-DL',
          style: AppTypography.captionBold.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'Lihat Riwayat Audit',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.primary900,
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.open_in_new,
                  size: 12, color: AppColors.primary900),
            ],
          ),
        ),
      ],
    );
  }
}
