// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// Input field standar Voteryx — digunakan di seluruh form.
///
/// Label ditampilkan di **atas** field (bukan floating label),
/// dengan focus state menggunakan gold border.
///
/// Contoh penggunaan:
/// ```dart
/// AppTextField(
///   label: 'NAMA PEMILIHAN',
///   hint: 'Contoh: Pemilihan Ketua HIMA TI 2026',
///   controller: _nameController,
///   prefixIcon: Icons.edit_outlined,
///   validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
/// )
///
/// // Textarea
/// AppTextField(
///   label: 'TUJUAN PENGAJUAN',
///   hint: 'Jelaskan tujuan pemilihan...',
///   controller: _reasonController,
///   maxLines: 4,
///   maxLength: 300,
/// )
/// ```
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.initialValue,
    this.focusNode,
    this.autofocus = false,
  });

  /// Label di atas field (akan dirender uppercase oleh AppTypography).
  final String label;

  /// Placeholder text dalam field kosong.
  final String hint;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  /// Material icon untuk sisi kiri field.
  final IconData? prefixIcon;

  /// Widget custom di sisi kanan field.
  final Widget? suffixIcon;

  /// Teks suffix di dalam field (e.g., "mahasiswa").
  final String? suffixText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// 1 = satu baris (default), >1 = textarea.
  final int maxLines;

  /// Batas karakter (memunculkan counter di bawah).
  final int? maxLength;

  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
            letterSpacing: 0.06 * 11,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Input field
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          enabled: enabled,
          obscureText: obscureText,
          onChanged: onChanged,
          onTap: onTap,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          autofocus: autofocus,
          style: AppTypography.bodyMedium.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.outline,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: AppColors.outline)
                : null,
            suffixIcon: suffixIcon,
            suffix: suffixText != null
                ? Text(
                    suffixText!,
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.outline,
                      fontSize: 13,
                    ),
                  )
                : null,
            filled: true,
            fillColor: enabled
                ? const Color(0xD9FFFFFF) // 85% putih
                : const Color(0x99E6E8F0), // read-only abu
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(
                color: AppColors.goldMid,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: maxLines > 1 ? AppSpacing.md : 14,
            ),
            counterStyle: AppTypography.caption,
          ),
        ),
      ],
    );
  }
}
