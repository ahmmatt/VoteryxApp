// lib/features/profile/presentation/screens/delegate_track_record_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ─────────────────── Model ─────────────────────────────────────────────────

/// Model untuk satu rekam jejak / pencapaian delegate.
class _TrackRecordItem {
  final String dateRange;
  final String title;
  final String description;
  final List<String> tags;

  const _TrackRecordItem({
    required this.dateRange,
    required this.title,
    required this.description,
    this.tags = const [],
  });
}

// ─────────────────── Screen ────────────────────────────────────────────────

/// Layar Track Record — menampilkan riwayat organisasi/kepemimpinan
/// dalam bentuk timeline interaktif dengan tombol edit/hapus.
class DelegateTrackRecordScreen extends StatelessWidget {
  const DelegateTrackRecordScreen({super.key});

  static const List<_TrackRecordItem> _records = [
    _TrackRecordItem(
      dateRange: '2023 – SEKARANG',
      title: 'Ketua Himpunan Mahasiswa',
      description:
          'Bertanggung jawab atas koordinasi 12 departemen dan 150+ anggota aktif dalam menjalankan program kerja tahunan.',
      tags: ['Leadership', 'Strategic Planning'],
    ),
    _TrackRecordItem(
      dateRange: '2022 – 2023',
      title: 'Kepala Departemen Advokasi',
      description:
          'Berhasil menegosiasikan penurunan biaya parkir kampus dan penambahan fasilitas ruang belajar terbuka.',
      tags: ['Negotiation', 'Public Policy'],
    ),
    _TrackRecordItem(
      dateRange: 'FEBRUARI 2023',
      title: 'Juara 1 Lomba Karya Tulis Nasional',
      description:
          'Menyusun riset tentang "Transparansi Dana Kampus Berbasis Blockchain" yang diadopsi oleh fakultas.',
      tags: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  _buildPageHeader(),
                  const SizedBox(height: AppSpacing.xl),

                  // Timeline
                  ...List.generate(_records.length, (i) {
                    final isLast = i == _records.length - 1;
                    return _TimelineItem(
                      item: _records[i],
                      isLast: isLast,
                    );
                  }),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),

          // Pinned Add Button
          _buildAddButton(context),
        ],
      ),
    );
  }

  // ─────────────────────────── AppBar ──────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Track Record',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  // ─────────────────── Page Header ─────────────────────────────────
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Zigzag / show-chart icon sesuai Figma
            const Icon(
              Icons.show_chart_rounded,
              color: AppColors.goldDark,
              size: 26,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Rekam Jejak Organisasi',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 22,
                  color: AppColors.primary900,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Kelola riwayat kepemimpinan dan pencapaian Anda untuk meningkatkan kepercayaan pemilih.',
          style: AppTypography.bodyText.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ─────────────────── Add Button ──────────────────────────────────
  Widget _buildAddButton(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              'Tambah Rekam Jejak',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldDark,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────── Timeline Item Widget ─────────────────────────────────

/// Satu baris timeline: dot + vertical line di kiri, card konten di kanan.
class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.item,
    required this.isLast,
  });

  final _TrackRecordItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline Graphics ──────────────────────────────────────
          SizedBox(
            width: 20,
            child: Column(
              children: [
                // Dot (dipusatkan sejajar dengan dateRange di card)
                const SizedBox(height: 22),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.goldDark,
                    shape: BoxShape.circle,
                  ),
                ),
                // Vertical line ke item berikutnya
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: AppColors.goldDark.withValues(alpha: 0.30),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // ── Content Card ───────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date + action icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.dateRange,
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.goldDark,
                              fontSize: 10,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        // Edit icon
                        GestureDetector(
                          onTap: () {},
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit_outlined,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete icon
                        GestureDetector(
                          onTap: () {},
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      item.title,
                      style: AppTypography.displayHeading.copyWith(
                        fontSize: 18,
                        color: AppColors.primary900,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      item.description,
                      style: AppTypography.bodyText.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),

                    // Tags
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.goldDark,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
