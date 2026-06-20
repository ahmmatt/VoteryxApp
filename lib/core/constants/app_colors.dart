// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

/// Design tokens — warna dari Voteryx design system.
/// Semua warna didefinisikan sebagai [static const] untuk
/// penggunaan yang konsisten di seluruh aplikasi.
abstract final class AppColors {
  // ── Navy Palette ──────────────────────────────────────────
  static const Color primary900 = Color(0xFF00071B);
  static const Color primary800 = Color(0xFF0F1F3D);
  static const Color navyMid    = Color(0xFF1A3260);
  static const Color navy600    = Color(0xFF1E3D70);

  // ── Gold Palette ──────────────────────────────────────────
  static const Color goldDark   = Color(0xFF9C7523);
  static const Color goldMid    = Color(0xFFD4A030);

  /// Gold gradient: digunakan untuk tombol CTA, icon aktif,
  /// progress bar, dll.
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldMid, goldDark],
  );

  // ── Semantic Colors ───────────────────────────────────────
  static const Color successTeal = Color(0xFF139971);
  static const Color successBg   = Color(0x1A139971); // 10% opacity
  static const Color errorRed    = Color(0xFFBA1A1A);
  static const Color errorBg     = Color(0xFFFFDAD6);

  // ── Neutral / Text ────────────────────────────────────────
  static const Color textPrimary     = Color(0xFF00071B);
  static const Color textSecondary   = Color(0xFF45474E);
  static const Color outline         = Color(0xFF75777E);
  static const Color outlineVariant  = Color(0xFFC5C6CE);
  static const Color background      = Color(0xFFF7F9FD);

  // ── Page Gradient (background) ────────────────────────────
  /// Gradient latar: dari putih-biru (#f7f9fd) ke biru muda (#d8e2ff).
  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7F9FD), Color(0xFFD8E2FF)],
  );

  // ── Glass Morphism ────────────────────────────────────────
  /// Putih semi-transparan untuk frosted glass cards (62% opacity).
  static const Color glassWhite  = Color(0x9EFFFFFF);
  /// Border untuk glass cards (88% opacity putih).
  static const Color glassBorder = Color(0xE0FFFFFF);
  /// Versi glass dengan border gold untuk card aktif/live.
  static const Color glassBorderGold = Color(0x59D4A030); // 35% opacity

  // ── Header Bar ────────────────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [navyMid, primary800],
  );

  // ── Warning / Amber ───────────────────────────────────────
  static const Color warningAmber = Color(0xFFD4A030);
  static const Color warningBg    = Color(0x1AD4A030); // 10% opacity
}
