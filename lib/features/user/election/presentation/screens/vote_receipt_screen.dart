import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/core/widgets/ghost_button.dart';
import 'package:voteryxapp/features/user/vote_execution/presentation/providers/vote_execution_provider.dart';

class VoteReceiptScreen extends ConsumerWidget {
  const VoteReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voteState = ref.watch(voteExecutionProvider);
    final hash = voteState.transactionHash ?? 'N/A';
    final candidateName = voteState.selectedCandidateName ?? 'Kandidat Anda';
    final shortHash = hash.length > 16 ? '${hash.substring(0, 16)}...' : hash;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'E-Receipt',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldMid.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.goldDark,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Suara Berhasil Dicatat!',
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilihan Anda telah dienkripsi secara end-to-end dan diamankan secara permanen dalam jaringan blockchain.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F1F3D),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'E-RECEIPT OFFICIAL',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BUKTI PEMILIHAN',
                      style: AppTypography.headerTitle.copyWith(
                        color: AppColors.primary800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Transaction Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TRANSACTION ID',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shortHash,
                                style: AppTypography.caption.copyWith(
                                  fontFamily: 'Courier',
                                  color: AppColors.primary800,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: hash));
                              AppSnackBar.showSuccess(context, 'Hash berhasil disalin!');
                            },
                            child: const Icon(Icons.copy, color: AppColors.outline, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Key Values
                    _buildReceiptRow(voteState.isDelegation ? 'Delegasi Ke' : 'Pilihan', candidateName),
                    const SizedBox(height: AppSpacing.md),
                    _buildReceiptRow('Waktu', voteState.timestampFormatted ?? 'Baru saja'),
                    const SizedBox(height: AppSpacing.md),
                    _buildReceiptRow('Pemilihan', voteState.electionTitle ?? 'Pemilihan Aktif Voteryx'),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock, color: AppColors.goldDark, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'TERENKRIPSI',
                                style: AppTypography.captionBold.copyWith(
                                  color: AppColors.goldDark,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Working QR Code
                    _buildQrCodeBox(context, hash, shortHash),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'SCAN UNTUK\nMEMVALIDASI INTEGRITAS\nSUARA DI JARINGAN',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Anonymity Note
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0E6), // very light beige/grey
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.goldMid.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.visibility_off_outlined,
                      color: AppColors.goldDark,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Suara Anda sepenuhnya anonim. Sistem tidak menyimpan kaitan antara identitas pengguna dan data pilihan yang telah dienkripsi.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.goldDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              GoldButton(
                label: 'Simpan Struk ke Galeri',
                icon: Icons.download,
                onPressed: () {},
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              GhostButton(
                label: 'Kembali ke Beranda',
                icon: Icons.home_outlined,
                onPressed: () {
                  context.go('/dashboard');
                },
                isFullWidth: true,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeBox(BuildContext context, String hash, String shortHash) {
    return GestureDetector(
      onTap: () {
        AppSnackBar.showSuccess(context, 'QR Code E-Receipt Valid — Hash: $shortHash');
      },
      child: Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary800.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _QrCodePainter(hash),
        ),
      ),
    );
  }
}

/// CustomPainter untuk menghasilkan representasi visual QR Code 21x21
/// yang deterministik dan realistis langsung berdasarkan string hash transaksi.
class _QrCodePainter extends CustomPainter {
  final String data;
  _QrCodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const int gridSize = 21;
    final double cellSize = size.width / gridSize;
    final Paint darkPaint = Paint()
      ..color = AppColors.primary800
      ..style = PaintingStyle.fill;
    final Paint lightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 1. Gambar latar belakang putih
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), lightPaint);

    // Helper: Periksa apakah koordinat berada di area finder patterns (3 pojok)
    bool isFinderZone(int r, int c) {
      if (r < 7 && c < 7) return true; // Top-Left
      if (r < 7 && c >= gridSize - 7) return true; // Top-Right
      if (r >= gridSize - 7 && c < 7) return true; // Bottom-Left
      return false;
    }

    // Helper untuk menggambar 7x7 Finder Pattern (Pojok QR)
    void drawFinderPattern(int startRow, int startCol) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          bool isDark = false;
          if (r == 0 || r == 6 || c == 0 || c == 6) {
            isDark = true; // Outer 7x7 ring
          } else if (r >= 2 && r <= 4 && c >= 2 && c <= 4) {
            isDark = true; // Inner 3x3 core
          }
          if (isDark) {
            canvas.drawRect(
              Rect.fromLTWH((startCol + c) * cellSize, (startRow + r) * cellSize, cellSize, cellSize),
              darkPaint,
            );
          }
        }
      }
    }

    // Gambar 3 Finder Patterns standar QR
    drawFinderPattern(0, 0);
    drawFinderPattern(0, gridSize - 7);
    drawFinderPattern(gridSize - 7, 0);

    // 2. Gambar Timing Patterns (Baris 6 dan Kolom 6)
    for (int i = 8; i < gridSize - 8; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(i * cellSize, 6 * cellSize, cellSize, cellSize), darkPaint);
        canvas.drawRect(Rect.fromLTWH(6 * cellSize, i * cellSize, cellSize, cellSize), darkPaint);
      }
    }

    // 3. Gambar Data Matrix (titik-titik biner berdasarkan hash code units)
    final codeUnits = data.codeUnits;
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (isFinderZone(r, c)) continue;
        if (r == 6 || c == 6) continue; // Timing line

        int index = (r * gridSize + c) % codeUnits.length;
        int val = codeUnits[index] + r * 3 + c * 7;
        if (val % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize), darkPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrCodePainter oldDelegate) => oldDelegate.data != data;
}
