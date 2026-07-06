// lib/features/admin/election_management/presentation/screens/admin_review_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ── Local model ───────────────────────────────────────────────────────────────
enum _CandidateStatus { eligible, manualReview }

class _CandidateItem {
  const _CandidateItem({
    required this.initials,
    required this.name,
    required this.nim,
    required this.status,
    this.errorMessage,
    required this.avatarColor,
  });

  final String initials;
  final String name;
  final String nim;
  final _CandidateStatus status;
  final String? errorMessage;
  final Color avatarColor;
}

// ── Screen ────────────────────────────────────────────────────────────────────
class AdminReviewDetailScreen extends StatelessWidget {
  const AdminReviewDetailScreen({super.key});

  static const List<_CandidateItem> _candidates = [
    _CandidateItem(
      initials: 'AP',
      name: 'Arjuna Pratama',
      nim: 'NIM: 2021001234',
      status: _CandidateStatus.eligible,
      avatarColor: Color(0xFF7986CB),
    ),
    _CandidateItem(
      initials: 'BR',
      name: 'Bima Rahardian',
      nim: 'NIM: 2021008899',
      status: _CandidateStatus.manualReview,
      errorMessage: 'Status: NIM tidak ditemukan di database',
      avatarColor: Color(0xFFE57373),
    ),
    _CandidateItem(
      initials: 'CP',
      name: 'Citra Putri',
      nim: 'NIM: 2021005678',
      status: _CandidateStatus.eligible,
      avatarColor: Color(0xFF81C784),
    ),
    _CandidateItem(
      initials: 'DW',
      name: 'Deni Wijaya',
      nim: 'NIM: 2021009988',
      status: _CandidateStatus.eligible,
      avatarColor: Color(0xFF64B5F6),
    ),
    _CandidateItem(
      initials: 'ES',
      name: 'Eka Saputra',
      nim: 'NIM: 2021004321',
      status: _CandidateStatus.eligible,
      avatarColor: Color(0xFFBA68C8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Submitter card (light blue bg)
                  _buildSubmitterCard(),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Informasi pemilihan section
                        _buildInfoPemilihanCard(),
                        const SizedBox(height: AppSpacing.md),
                        // Warning box
                        _buildWarningBox(),
                        const SizedBox(height: AppSpacing.lg),
                        // Daftar kandidat
                        Text(
                          'Daftar Kandidat (${_candidates.length})',
                          style: AppTypography.cardTitle.copyWith(
                            color: AppColors.primary900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ..._candidates.map(_buildCandidateItem),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
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
      title: Text('Inbox Usulan', style: AppTypography.headerTitle),
    );
  }

  // ── Submitter Card ────────────────────────────────────────────────────────
  Widget _buildSubmitterCard() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEFF2FA),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Avatar with org icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=33',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary900,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DIAJUKAN OLEH:',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.outline,
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Rizky Anggara',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.account_balance_outlined,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'HIMA Teknik Informatika',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Info Pemilihan Card ───────────────────────────────────────────────────
  Widget _buildInfoPemilihanCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary900,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'INFORMASI PEMILIHAN',
                  style: AppTypography.captionBold.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          // Info rows
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildInfoTableRow('Nama', 'Pemilihan Ketua HIMA TI 2026',
                    valueBold: true),
                _buildDivider(),
                _buildInfoTableRow('Jenis', 'Ketua Organisasi'),
                _buildDivider(),
                _buildInfoTableRow(
                  'Tujuan',
                  'Regenerasi kepemimpinan untuk periode 2026/2027 serta penguatan visi misi organisasi.',
                ),
                _buildDivider(),
                _buildInfoTableRow(
                  'Periode',
                  '15 – 17 Jun 2026',
                  prefixIcon: Icons.calendar_today_outlined,
                  valueBold: true,
                ),
                _buildDivider(),
                _buildInfoTableRow('Estimasi', '1,240 Mahasiswa',
                    valueBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTableRow(
    String label,
    String value, {
    bool valueBold = false,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.primary900,
                      fontWeight: valueBold ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.outlineVariant.withOpacity(0.3),
      );

  // ── Warning Box ───────────────────────────────────────────────────────────
  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppRadius.cardInner),
        border: Border.all(
          color: AppColors.warningAmber.withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.goldDark, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '1 dari 5 kandidat memerlukan verifikasi manual karena data tidak sinkron dengan database pusat.',
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

  // ── Candidate Item ────────────────────────────────────────────────────────
  Widget _buildCandidateItem(_CandidateItem c) {
    final isManualReview = c.status == _CandidateStatus.manualReview;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.cardInner),
          border: isManualReview
              ? Border.all(color: AppColors.errorRed.withOpacity(0.3))
              : Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  // Avatar initials
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.avatarColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: c.avatarColor.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      c.initials,
                      style: AppTypography.bodyMedium.copyWith(
                        color: c.avatarColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          c.nim,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  _buildStatusBadge(c.status),
                ],
              ),
            ),
            // Error message for manual review
            if (isManualReview && c.errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 13, color: AppColors.errorRed),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        c.errorMessage!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.errorRed,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(_CandidateStatus status) {
    if (status == _CandidateStatus.eligible) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.successBg,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: AppColors.successTeal.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.successTeal, size: 12),
            const SizedBox(width: 4),
            Text(
              'ELIGIBLE',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.successTeal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Text(
        'MANUAL REVIEW',
        style: AppTypography.captionBold.copyWith(
          color: AppColors.errorRed,
          fontSize: 10,
        ),
      ),
    );
  }

  // ── Bottom Action Bar ─────────────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Tolak button
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.cardInner),
                    ),
                  ),
                  child: Text(
                    'Tolak Usulan',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Setujui & Buat Draft button
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldMid,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.cardInner),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note_outlined,
                      color: Colors.white, size: 18),
                  label: Text(
                    'Setujui & Buat Draft',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
