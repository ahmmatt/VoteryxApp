// lib/core/widgets/gold_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';

/// Tombol CTA utama dengan gold gradient — digunakan untuk
/// aksi utama di setiap halaman (Submit, Lanjut, Kirim, dll).
///
/// Contoh penggunaan:
/// ```dart
/// GoldButton(
///   label: 'Kirim Usulan →',
///   onPressed: _handleSubmit,
/// )
///
/// // Dengan icon
/// GoldButton(
///   label: 'Buat Pemilihan Baru',
///   icon: Icons.add_box_outlined,
///   onPressed: _openForm,
/// )
///
/// // State loading
/// GoldButton(
///   label: 'Memproses...',
///   isLoading: true,
///   onPressed: null,
/// )
/// ```
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 48,
  });

  /// Teks label tombol.
  final String label;

  /// Callback aksi. Set `null` untuk state disabled.
  final VoidCallback? onPressed;

  /// Icon opsional di kiri label.
  final IconData? icon;

  /// Menampilkan [CircularProgressIndicator] putih di tengah tombol.
  final bool isLoading;

  /// Jika `true`, tombol mengisi lebar penuh parent.
  final bool isFullWidth;

  /// Tinggi tombol. Default 48px.
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? const LinearGradient(
                  colors: [Color(0xFFBCBEC7), Color(0xFF9EA0A8)],
                )
              : AppColors.goldGradient,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.goldMid.withValues(alpha: 0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
