// lib/features/profile/presentation/screens/delegate_notifications_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ─────────────────── Model ─────────────────────────────────────────────────

class _NotifItem {
  final IconData icon;
  final String title;
  final String subtitle;
  bool isEnabled;

  _NotifItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });
}

// ─────────────────── Screen ────────────────────────────────────────────────

/// Layar Preferensi Notifikasi delegate.
/// Setiap toggle dapat diaktifkan / dinonaktifkan secara independen.
class DelegateNotificationsScreen extends StatefulWidget {
  const DelegateNotificationsScreen({super.key});

  @override
  State<DelegateNotificationsScreen> createState() =>
      _DelegateNotificationsScreenState();
}

class _DelegateNotificationsScreenState
    extends State<DelegateNotificationsScreen> {
  // ── State ──────────────────────────────────────────────────────────
  final List<_NotifItem> _items = [
    _NotifItem(
      icon: Icons.person_add_outlined,
      title: 'Mandat Baru',
      subtitle: 'Dapatkan info saat delegasi baru diterima.',
      isEnabled: true,
    ),
    _NotifItem(
      icon: Icons.person_remove_outlined,
      title: 'Pencabutan Mandat',
      subtitle: 'Notifikasi jika pemberi mandat menarik hak suara.',
      isEnabled: true,
    ),
    _NotifItem(
      icon: Icons.assignment_late_outlined,
      title: 'Pengingat Eksekusi',
      subtitle: 'Alert 24 jam sebelum batas waktu voting berakhir.',
      isEnabled: true,
    ),
    _NotifItem(
      icon: Icons.system_update_outlined,
      title: 'Update Sistem',
      subtitle: 'Informasi pemeliharaan dan fitur baru portal.',
      isEnabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon + Page Heading ──────────────────────────────────
            _buildPageHeader(),
            const SizedBox(height: AppSpacing.xl),

            // ── Section Label ─────────────────────────────────────────
            Text(
              'PENGATURAN ALERT',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // ── Notification Toggles ──────────────────────────────────
            _buildTogglesCard(),
            const SizedBox(height: AppSpacing.xl),

            // ── Security Banner ───────────────────────────────────────
            _buildSecurityBanner(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── AppBar ──────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Notifikasi',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─────────────────── Page Header ─────────────────────────────────
  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Mail icon in gold-gradient circle
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.goldMid.withValues(alpha: 0.30),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.mail_outline_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferensi Notifikasi',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 20,
                  color: AppColors.primary900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kelola bagaimana Anda menerima pembaruan mandat.',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────── Toggle Card ─────────────────────────────────
  Widget _buildTogglesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_items.length, (i) {
          final isLast = i == _items.length - 1;
          return Column(
            children: [
              _NotifTile(
                item: _items[i],
                onChanged: (val) => setState(() => _items[i].isEnabled = val),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 58,
                  color: Color(0xFFF0F1F5),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────── Security Banner ─────────────────────────────
  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keamanan Terjamin',
                style: AppTypography.cardTitle.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Setiap notifikasi dienkripsi secara end-to-end untuk menjaga integritas data Anda.',
                style: AppTypography.bodyText.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
          // Decorative shield icon
          Positioned(
            right: 0,
            bottom: -4,
            child: Icon(
              Icons.security_rounded,
              size: 72,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Notification Tile ───────────────────────────────────

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item, required this.onChanged});
  final _NotifItem item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: AppColors.primary900,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Toggle
          Switch(
            value: item.isEnabled,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.goldDark,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.outlineVariant,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
