// lib/core/constants/app_spacing.dart

/// Design tokens — spacing constants untuk Voteryx.
///
/// Gunakan class ini untuk semua padding, margin, dan gap
/// agar konsisten di seluruh aplikasi.
abstract final class AppSpacing {
  /// 4px — jarak sangat kecil, e.g. antara icon & label
  static const double xs = 4;

  /// 8px — jarak kecil, e.g. dalam chip, antara baris info
  static const double sm = 8;

  /// 12px — jarak sedang-kecil, e.g. padding internal card
  static const double mdSm = 12;

  /// 16px — jarak standar / default page padding
  static const double md = 16;

  /// 20px — padding halaman utama (left/right)
  static const double pagePad = 20;

  /// 24px — jarak besar, e.g. antar section
  static const double lg = 24;

  /// 32px — jarak sangat besar
  static const double xl = 32;

  /// 48px — untuk bottom nav clearance, spacer besar
  static const double xxl = 48;
}
