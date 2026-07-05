// lib/core/constants/app_radius.dart

/// Design tokens — border radius constants untuk Voteryx.
abstract final class AppRadius {
  /// 16px — card radius (glass cards, election cards)
  static const double card = 12;

  /// 12px — inner card, banner, info box
  static const double cardInner = 10;

  /// 9999px — full pill (tombol CTA, status badge, chip)
  static const double button = 9999;

  /// 8px — input field, dropdown
  static const double input = 8;

  /// 20px — chip yang lebih lebar dari pill kecil
  static const double chip = 20;

  /// 44px — sudut phone frame / avatar besar
  static const double phoneFull = 32;
}
