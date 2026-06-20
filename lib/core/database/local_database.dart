// lib/core/database/local_database.dart
// TODO(setup): Konfigurasi lengkap Drift database akan ditambahkan
// saat fitur offline/local-first diimplementasi.
//
// Saat ini file ini adalah placeholder — Drift @DriftDatabase
// annotation dan code generation (build_runner) akan diaktifkan
// nanti ketika tabel pertama didefinisikan.
//
// Cara penggunaan nanti:
// ```dart
// // Di main.dart
// final db = LocalDatabase();
//
// // Di provider (Riverpod)
// final localDatabaseProvider = Provider((ref) => LocalDatabase());
// ```

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// ── Tabel-tabel akan didefinisikan di sini ─────────────────────────────
// TODO: Uncomment dan tambahkan tabel saat fitur offline dibutuhkan.
// Contoh:
//
// class CachedElections extends Table {
//   TextColumn get id => text()();
//   TextColumn get title => text()();
//   DateTimeColumn get syncedAt => dateTime()();
// }

// ── Database class ────────────────────────────────────────────────────

/// Buka koneksi ke file SQLite di storage lokal device.
QueryExecutor openLocalDbConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'voteryx.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// TODO: Uncomment setelah tabel pertama didefinisikan dan
// menjalankan: flutter pub run build_runner build
//
// @DriftDatabase(tables: [...])
// class LocalDatabase extends _$LocalDatabase {
//   LocalDatabase() : super(openLocalDbConnection());
//
//   @override
//   int get schemaVersion => 1;
// }
