// lib/core/widgets/ghost_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';

/// Tombol secondary/ghost — border tipis, background transparan.
///
/// Digunakan berpasangan dengan [GoldButton] untuk aksi sekunder
/// (e.g., "← Kembali" di samping "Lanjut →").
///
/// Contoh penggunaan:
/// ```dart
/// GhostButton(
///   label: '← Kembali',
///   onPressed: () => context.pop(),
/// )
/// ```
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.height = 44,
    this.borderColor,
    this.textColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final double height;

  /// Override warna border. Default: hitam 20% opacity.
  final Color? borderColor;

  /// Override warna teks. Default: [AppColors.textPrimary].
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? AppColors.textPrimary.withValues(alpha: 0.20);
    final effectiveTextColor = textColor ?? AppColors.textPrimary;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: effectiveTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
