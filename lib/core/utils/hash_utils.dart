// lib/core/utils/hash_utils.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility untuk operasi kriptografi ringan di sisi klien.
/// Digunakan untuk hashing NIK dan transaction hash voting.
abstract final class HashUtils {
  /// SHA-256 hash dari [input] string, dikembalikan sebagai hex string.
  ///
  /// Digunakan untuk:
  /// - `nik_hash` di tabel `public.users`
  /// - `transaction_hash` di tabel `votes`
  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Buat transaction hash untuk vote.
  /// Format: SHA-256("userId-electionId-candidateId-timestamp")
  static String generateVoteTransactionHash({
    required String userId,
    required String electionId,
    required String candidateId,
    required DateTime timestamp,
  }) {
    final raw = '$userId-$electionId-$candidateId-${timestamp.toIso8601String()}';
    return sha256Hash(raw);
  }
}
