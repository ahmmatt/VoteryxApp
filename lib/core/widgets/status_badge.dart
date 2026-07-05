// lib/core/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

/// Enum semua status pemilihan dan proposal di Voteryx.
enum ElectionStatus {
  /// Pemilihan sedang berjalan (Live).
  live,

  /// Masih berupa draft, belum dipublikasi.
  draft,

  /// Dijadwalkan untuk masa mendatang.
  scheduled,

  /// Pemilihan sudah selesai.
  completed,

  /// Usulan sudah disetujui admin.
  approved,

  /// Usulan ditolak admin.
  rejected,

  /// Sedang dalam proses review oleh admin.
  pending,

  /// Sudah diajukan, menunggu review.
  submitted,
}

/// Badge pill berwarna yang menampilkan status pemilihan/proposal.
///
/// Warna dan label ditentukan otomatis dari [status].
///
/// Contoh penggunaan:
/// ```dart
/// StatusBadge(status: ElectionStatus.live)
/// StatusBadge(status: ElectionStatus.draft)
/// ```
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ElectionStatus status;

  @override
  Widget build(BuildContext context) {
    final config = _StatusConfig.of(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ElectionStatus.live)
            _PulsingDot(color: config.textColor)
          else if (status == ElectionStatus.pending)
            _PulsingDot(color: config.textColor)
          else if (config.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(config.icon, size: 11, color: config.textColor),
            ),
          if (status == ElectionStatus.live || status == ElectionStatus.pending)
            const SizedBox(width: 4),
          Text(
            config.label,
            style: AppTypography.caption.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 9.5,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot animasi untuk status Live/Pending.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 4 * _scale.value,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Konfigurasi internal per status.
class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });

  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  static _StatusConfig of(ElectionStatus status) {
    return switch (status) {
      ElectionStatus.live => _StatusConfig(
          label: 'Live',
          bgColor: AppColors.errorBg,
          textColor: AppColors.errorRed,
        ),
      ElectionStatus.draft => _StatusConfig(
          label: 'Draft',
          bgColor: const Color(0x14152A52),
          textColor: AppColors.textSecondary,
        ),
      ElectionStatus.scheduled => _StatusConfig(
          label: 'Terjadwal',
          bgColor: AppColors.warningBg,
          textColor: AppColors.goldDark,
          icon: Icons.schedule,
        ),
      ElectionStatus.completed => _StatusConfig(
          label: 'Selesai',
          bgColor: AppColors.successBg,
          textColor: const Color(0xFF0F6E56),
          icon: Icons.check_circle_outline,
        ),
      ElectionStatus.approved => _StatusConfig(
          label: 'Disetujui',
          bgColor: AppColors.successBg,
          textColor: const Color(0xFF0F6E56),
          icon: Icons.check_circle,
        ),
      ElectionStatus.rejected => _StatusConfig(
          label: 'Ditolak',
          bgColor: AppColors.errorBg,
          textColor: AppColors.errorRed,
          icon: Icons.cancel,
        ),
      ElectionStatus.pending => _StatusConfig(
          label: 'Direview',
          bgColor: AppColors.warningBg,
          textColor: AppColors.goldDark,
        ),
      ElectionStatus.submitted => _StatusConfig(
          label: 'Diajukan',
          bgColor: const Color(0x14152A52),
          textColor: AppColors.navy600,
          icon: Icons.radio_button_unchecked,
        ),
    };
  }
}
