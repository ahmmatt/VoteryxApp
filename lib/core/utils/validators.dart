// lib/core/utils/validators.dart

/// Kumpulan fungsi validasi form untuk Voteryx.
///
/// Semua fungsi mengembalikan `null` jika valid,
/// atau `String` pesan error jika tidak valid.
/// Kompatibel langsung dengan [TextFormField.validator].
abstract final class Validators {
  // ── Umum ─────────────────────────────────────────────────

  /// Wajib diisi — tidak boleh kosong.
  static String? required(String? value, {String field = 'Field ini'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi.';
    }
    return null;
  }

  /// Minimal panjang karakter.
  static String? minLength(String? value, int min, {String field = 'Field'}) {
    if (value == null || value.trim().length < min) {
      return '$field minimal $min karakter.';
    }
    return null;
  }

  /// Maksimal panjang karakter.
  static String? maxLength(String? value, int max, {String field = 'Field'}) {
    if (value != null && value.length > max) {
      return '$field maksimal $max karakter.';
    }
    return null;
  }

  // ── Akademik ──────────────────────────────────────────────

  /// Validasi NIM (Nomor Induk Mahasiswa):
  /// hanya angka, panjang 8–12 digit.
  static String? nim(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM wajib diisi.';
    }
    final cleaned = value.trim();
    if (!RegExp(r'^\d{8,12}$').hasMatch(cleaned)) {
      return 'NIM harus berupa 8–12 digit angka.';
    }
    return null;
  }

  /// Validasi NIM untuk login — harus tepat 10 digit angka.
  static String? nimLogin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM wajib diisi.';
    }
    final cleaned = value.trim();
    if (!RegExp(r'^\d{10}$').hasMatch(cleaned)) {
      return 'NIM harus tepat 10 digit angka.';
    }
    return null;
  }

  /// Validasi password login — minimal 8 karakter.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    return null;
  }

  /// Validasi NIK (Nomor Induk Kependudukan):
  /// harus tepat 16 digit angka.
  static String? nik(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIK wajib diisi.';
    }
    final cleaned = value.trim();
    if (!RegExp(r'^\d{16}$').hasMatch(cleaned)) {
      return 'NIK harus tepat 16 digit angka.';
    }
    return null;
  }

  // ── Kontak ────────────────────────────────────────────────

  /// Validasi nomor WhatsApp Indonesia:
  /// dimulai dengan 08, 628, +628; panjang 10–14 digit.
  static String? phoneId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi.';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(\+?62|0)8\d{8,13}$').hasMatch(cleaned)) {
      return 'Format nomor HP tidak valid (e.g., 08xxxxxxxxxx).';
    }
    return null;
  }

  // ── Pemilihan ─────────────────────────────────────────────

  /// Validasi estimasi jumlah pemilih — angka positif.
  static String? voterCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Estimasi pemilih wajib diisi.';
    }
    final n = int.tryParse(value.trim());
    if (n == null || n <= 0) {
      return 'Masukkan angka positif yang valid.';
    }
    if (n > 100000) {
      return 'Jumlah pemilih terlalu besar (maks 100.000).';
    }
    return null;
  }

  /// Validasi judul pemilihan — min 5, maks 100 karakter.
  static String? electionTitle(String? value) {
    final req = required(value, field: 'Nama pemilihan');
    if (req != null) return req;
    final min = minLength(value, 5, field: 'Nama pemilihan');
    if (min != null) return min;
    return maxLength(value, 100, field: 'Nama pemilihan');
  }

  /// Validasi tujuan/deskripsi — min 20, maks 300 karakter.
  static String? purposeText(String? value) {
    final req = required(value, field: 'Tujuan pengajuan');
    if (req != null) return req;
    return minLength(value, 20, field: 'Tujuan pengajuan');
  }
}
