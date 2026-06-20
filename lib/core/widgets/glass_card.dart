// lib/core/widgets/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Widget glassmorphism card yang digunakan di seluruh Voteryx.
///
/// Menggunakan [BackdropFilter] dengan blur 16px untuk efek frosted glass.
///
/// Contoh penggunaan:
/// ```dart
/// GlassCard(
///   child: Text('Konten card'),
/// )
///
/// // Dengan border gold (untuk election yang sedang Live)
/// GlassCard(
///   isGoldAccent: true,
///   child: ElectionListItem(election: election),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.isGoldAccent = false,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  /// Konten di dalam card.
  final Widget child;

  /// Jika `true`, border card menggunakan warna gold (untuk item aktif/live).
  final bool isGoldAccent;

  /// Padding internal card. Default: 16px semua sisi.
  final EdgeInsetsGeometry? padding;

  /// Margin luar card.
  final EdgeInsetsGeometry? margin;

  /// Override border radius. Default: [AppRadius.card] (16px).
  final BorderRadiusGeometry? borderRadius;

  /// Callback ketika card di-tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final effectivePadding = padding ??
        const EdgeInsets.all(AppSpacing.md);

    final borderColor = isGoldAccent
        ? AppColors.glassBorderGold
        : AppColors.glassBorder;
    final borderWidth = isGoldAccent ? 1.0 : 0.5;

    Widget card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          padding: effectivePadding,
          child: child,
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius as BorderRadius?,
          child: card,
        ),
      );
    }

    return card;
  }
}
