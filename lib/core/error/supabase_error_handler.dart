// lib/core/error/supabase_error_handler.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Extension untuk menerjemahkan exception Supabase ke pesan bahasa Indonesia
/// yang ramah pengguna. Digunakan di semua provider dan repository.
extension AuthExceptionMessage on AuthException {
  /// Kembalikan pesan error yang dapat ditampilkan ke user.
  String get userFriendlyMessage {
    // Cek berdasarkan status code dan message
    final msg = message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return 'NIK atau kata sandi salah. Silakan coba lagi.';
    }
    if (msg.contains('email not confirmed') ||
        msg.contains('email_not_confirmed')) {
      return 'Akun belum diverifikasi. Silakan hubungi admin.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('user_already_exists')) {
      return 'NIK ini sudah terdaftar. Silakan masuk.';
    }
    if (msg.contains('password should be at least')) {
      return 'Kata sandi minimal 8 karakter.';
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Periksa koneksi internet kamu dan coba lagi.';
    }
    if (msg.contains('too many requests') || msg.contains('rate_limit')) {
      return 'Terlalu banyak percobaan. Tunggu beberapa menit.';
    }
    if (msg.contains('weak_password')) {
      return 'Kata sandi terlalu lemah. Gunakan kombinasi huruf dan angka.';
    }
    // Fallback: tampilkan pesan asli tapi lebih bersih
    debugPrint('[AuthException] $message');
    return 'Terjadi kesalahan autentikasi. Coba lagi.';
  }
}

extension PostgrestExceptionMessage on PostgrestException {
  /// Kembalikan pesan error yang dapat ditampilkan ke user.
  String get userFriendlyMessage {
    final code = this.code ?? '';
    final msg = message.toLowerCase();

    // 23505 = unique_violation (duplicate data)
    if (code == '23505' || msg.contains('unique') || msg.contains('duplicate')) {
      return 'Data sudah ada. Periksa kembali inputan kamu.';
    }
    // 42501 = insufficient_privilege (RLS policy)
    if (code == '42501' || msg.contains('permission denied')) {
      return 'Akses ditolak. Kamu tidak memiliki izin untuk aksi ini.';
    }
    // 23503 = foreign_key_violation
    if (code == '23503') {
      return 'Data referensi tidak ditemukan. Coba muat ulang halaman.';
    }
    // 42P01 = undefined_table
    if (code == '42P01') {
      debugPrint('[PostgrestException] Table not found: $message');
      return 'Terjadi kesalahan sistem. Silakan hubungi admin.';
    }
    // PGRST204 / 42703 = missing column in schema cache or table
    if (code == 'PGRST204' || code == '42703' || msg.contains('column') || msg.contains('schema cache')) {
      debugPrint('[PostgrestException] Column/Schema error: $message');
      return 'Kolom database belum lengkap ($message). Pastikan Anda telah menjalankan script migrasi SQL terbaru di Supabase.';
    }
    // Network / connection
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Periksa koneksi internet kamu dan coba lagi.';
    }

    debugPrint('[PostgrestException] code=$code msg=$message');
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}

/// Helper untuk mengekstrak pesan ramah dari exception apapun.
String extractUserFriendlyError(Object error) {
  if (error is AuthException) return error.userFriendlyMessage;
  if (error is PostgrestException) return error.userFriendlyMessage;
  final msg = error.toString().toLowerCase();
  if (msg.contains('network') ||
      msg.contains('socket') ||
      msg.contains('connection') ||
      msg.contains('timeout')) {
    return 'Periksa koneksi internet kamu dan coba lagi.';
  }
  debugPrint('[UnknownError] $error');
  return 'Terjadi kesalahan yang tidak terduga. Coba lagi.';
}
