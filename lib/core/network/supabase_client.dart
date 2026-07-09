// lib/core/network/supabase_client.dart
// TODO(setup): Inisialisasi Supabase akan ditambahkan di prompt
// terpisah setelah project Supabase siap.
//
// Saat ini file ini hanya menyediakan placeholder client dan
// konstanta URL/AnonKey yang akan diisi nanti.
//
// Cara penggunaan nanti (di main.dart):
// ```dart
// await SupabaseConfig.initialize();
// ```
//
// Dan di repository:
// ```dart
// final client = SupabaseConfig.client;
// ```

import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseConfig {
  // TODO: Ganti dengan URL dan AnonKey dari Supabase Dashboard.
  static const String _supabaseUrl =
      'https://rxkzazdgjijykenfjpbl.supabase.co';
  static const String _anonKey ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4a3phemRnamlqeWtlbmZqcGJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4OTU0ODcsImV4cCI6MjA5NzQ3MTQ4N30.q70o5zp3BIogxoBHB88JId6O4GiB7H3BkGrLft-pKQU';

  /// Inisialisasi Supabase. Panggil di [main()] sebelum [runApp()].
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: _anonKey,
    );
  }

  /// Singleton client — gunakan untuk semua query Supabase.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shortcut ke GoTrue auth client.
  static GoTrueClient get auth => client.auth;
}
