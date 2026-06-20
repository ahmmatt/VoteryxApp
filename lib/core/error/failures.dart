// lib/core/error/failures.dart

/// Kelas-kelas failure/exception untuk Voteryx.
///
/// Mengikuti pola Clean Architecture — domain layer hanya
/// berurusan dengan [Failure], bukan exception mentah.
///
/// Contoh penggunaan di use case:
/// ```dart
/// Future<Either<Failure, User>> call(...) async {
///   try {
///     final result = await repository.login(...);
///     return Right(result);
///   } on NetworkException {
///     return Left(NetworkFailure());
///   }
/// }
/// ```
sealed class Failure {
  const Failure({this.message});
  final String? message;
}

/// Kegagalan koneksi jaringan (timeout, no internet, dll).
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Tidak ada koneksi internet.'});
}

/// Error dari Supabase / API server.
final class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});
  final int? statusCode;
}

/// Error autentikasi (token expired, unauthorized, dll).
final class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Sesi habis. Silakan login ulang.'});
}

/// Kegagalan verifikasi KYC (liveness, NIK mismatch, dll).
final class KycFailure extends Failure {
  const KycFailure({super.message, this.attemptCount = 0});
  final int attemptCount;
}

/// Data tidak ditemukan (404-style).
final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Data tidak ditemukan.'});
}

/// Validasi input gagal.
final class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.field});
  final String? field;
}

/// Error database lokal (Drift).
final class LocalDbFailure extends Failure {
  const LocalDbFailure({super.message = 'Error database lokal.'});
}

/// Error enkripsi/dekripsi suara.
final class CryptoFailure extends Failure {
  const CryptoFailure({super.message = 'Error enkripsi data suara.'});
}

/// Error tidak diketahui.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Terjadi kesalahan tidak diketahui.'});
}
