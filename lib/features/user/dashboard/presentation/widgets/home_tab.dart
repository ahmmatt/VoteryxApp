import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/gold_button.dart';
import '../../../../../core/widgets/status_badge.dart';

/// Tab Home untuk Dashboard User.
/// Berisi header profil, ringkasan bobot suara, pemilihan aktif, dan pengumuman.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      // Gunakan padding bottom agar tidak tertutup bottom nav
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header background navy dengan konten profil & bobot suara
          const _HeaderSection(),

          const SizedBox(height: AppSpacing.lg),

          // Section Pemilihan Aktif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'PEMILIHAN AKTIF',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pushNamed('elections'),
                  child: Text(
                    'Lihat Semua',
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.goldDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const _ActiveElectionCard(),

          const SizedBox(height: AppSpacing.xl),

          // Section Pengumuman
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
            child: Text(
              'PENGUMUMAN',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const _AnnouncementCard(),
        ],
      ),
    );
  }
}

// ── Sub Widgets ──────────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  // MOCK: Toggle ini menentukan apakah user saat ini aktif sebagai Delegate (punya mandat)
  final bool isDelegate = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.sm,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: Logo, Bell, Avatar
          Row(
            children: [
              Text(
                'Voteryx',
                style: AppTypography.displayHeading.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              // Bell Icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Avatar (Diubah ke Icon statis agar aman dari CORS Web)
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5C6CE),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldMid, width: 1.5),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Greeting
          Row(
            children: [
              Expanded(
                child: Text(
                  'Halo, Budi Santoso',
                  style: AppTypography.displayHeading.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // KYC Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x330F6E56),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F6E56)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF34C759),
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'KYC',
                      style: AppTypography.captionBold.copyWith(
                        color: const Color(0xFF34C759),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Selamat datang di portal pemilihan digital.',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Voting Weight Card
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.mdSm,
            ),
            decoration: BoxDecoration(
              color: const Color(0xCCB0BBCB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL BOBOT SUARA',
                        style: AppTypography.captionBold.copyWith(
                          color: AppColors.goldDark,
                          letterSpacing: 0.7,
                        ),
                      ),
                      Text(
                        '1',
                        style: AppTypography.displayHeading.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMid.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.how_to_vote_outlined,
                    color: AppColors.primary800,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // --- DELEGATE INFO CARD (Hanya Muncul Jika isDelegate == true) ---
          if (isDelegate) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.mdSm,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.delegateGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.delegateTealMid.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MANDAT DITERIMA',
                          style: AppTypography.captionBold.copyWith(
                            color: Colors.white70,
                            letterSpacing: 0.7,
                          ),
                        ),
                        Text(
                          '42 Suara',
                          style: AppTypography.displayHeading.copyWith(
                            color: Colors.white,
                            fontSize: 19,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Siap dieksekusi',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveElectionCard extends StatelessWidget {
  const _ActiveElectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F1F3D),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Badge & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StatusBadge(status: ElectionStatus.live),
              Icon(Icons.list_alt, color: AppColors.textSecondary, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title
          Text(
            'Pemilihan Ketua BEM 2026',
            style: AppTypography.cardTitle.copyWith(fontSize: 17),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Countdown
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '02 HARI : 14 JAM : 30 MENIT',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Partisipasi Pemilih',
                  style: AppTypography.bodyText.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '62%',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.goldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.62,
              backgroundColor: AppColors.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldMid),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Stats boxes
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0x1A0F1F3D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppColors.primary800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kandidat',
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text('2 Kandidat',
                                style: AppTypography.bodyText.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0x1A34C759),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.groups_outlined,
                          size: 16,
                          color: Color(0xFF34C759),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delegasi',
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text('3 Aktif',
                                style: AppTypography.bodyText.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed('election', pathParameters: {'id': '1'});
                  },
                  child: Text(
                    'Lihat Detail',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: GoldButton(
                  label: 'Pilih Sekarang',
                  icon: Icons.arrow_forward,
                  height: 42,
                  onPressed: () {
                    context.pushNamed('election', pathParameters: {'id': '1'});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          // Gambar Diganti dengan Icon Placeholder untuk Web (bebas CORS)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0x1A0F1F3D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.campaign_outlined,
                color: AppColors.primary800, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENTING',
                  style: AppTypography.captionBold.copyWith(
                    color: AppColors.goldDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sosialisasi Teknis Pemilihan Raya Digital 2026...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
