// lib/core/constants/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Design tokens — tipografi Voteryx.
///
/// Dua font family:
/// - **Plus Jakarta Sans** (700) — heading, title, nilai statistik
/// - **DM Sans** (400/500/600/700) — body, label, helper text
abstract final class AppTypography {
  // ── Plus Jakarta Sans ─────────────────────────────────────

  /// 28px Bold — digunakan di halaman utama / splash heading.
  static TextStyle get displayHeading => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  /// 24px Bold — judul halaman utama.
  static TextStyle get screenTitle => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// 18px Bold — judul di header bar.
  static TextStyle get headerTitle => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.2,
      );

  /// 16px Bold — judul card / section.
  static TextStyle get cardTitle => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  /// 14px Bold — nama kandidat / judul pemilihan dalam list.
  static TextStyle get itemTitle => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // ── DM Sans ───────────────────────────────────────────────

  /// 14px Regular — teks isi / deskripsi umum.
  static TextStyle get bodyText => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  /// 14px Medium — label tombol, info penting.
  static TextStyle get labelLarge => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// 13px SemiBold — subinfo, nilai dalam card.
  static TextStyle get bodyMedium => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// 12px Bold Uppercase — section label (gold).
  static TextStyle get labelSmall => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.goldDark,
        letterSpacing: 0.08 * 12,
        height: 1.3,
      );

  /// 11px Regular — helper text, timestamp, hint.
  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.outline,
        height: 1.5,
      );

  /// 10px Bold Uppercase — sub-label di section header.
  static TextStyle get captionBold => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.outline,
        letterSpacing: 0.06 * 10,
        height: 1.3,
      );
}
