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
  static const String _supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String _anonKey = 'YOUR_ANON_KEY';

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
