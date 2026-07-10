// lib/core/utils/avatar_utils.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';

class AvatarUtils {
  AvatarUtils._();

  /// Mengembalikan ImageProvider (NetworkImage, MemoryImage untuk Base64, atau FileImage untuk lokal).
  static ImageProvider? getImageProvider(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final clean = url.trim();

    if (clean.startsWith('data:image')) {
      try {
        final base64String = clean.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (_) {
        return null;
      }
    } else if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return NetworkImage(clean);
    } else {
      try {
        final file = File(clean);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } catch (_) {}
      return null;
    }
  }

  /// Menampilkan widget gambar foto profil dengan penanganan error dan support semua format URL/File/Base64.
  static Widget buildAvatarImage(
    String? url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? fallback,
    String? name,
  }) {
    final provider = getImageProvider(url);
    if (provider == null) {
      return fallback ?? _buildDefaultFallback(width, height, name);
    }

    return Image(
      image: provider,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          fallback ?? _buildDefaultFallback(width, height, name),
    );
  }

  static Widget _buildDefaultFallback(double? width, double? height, String? name) {
    return Container(
      width: width,
      height: height,
      color: AppColors.primary800,
      child: Center(
        child: name != null && name.trim().isNotEmpty
            ? Text(
                name.trim()[0].toUpperCase(),
                style: AppTypography.displayHeading.copyWith(
                  color: Colors.white,
                  fontSize: (width ?? 40) * 0.4,
                ),
              )
            : Icon(
                Icons.person,
                color: AppColors.goldMid,
                size: (width ?? 40) * 0.5,
              ),
      ),
    );
  }
}
