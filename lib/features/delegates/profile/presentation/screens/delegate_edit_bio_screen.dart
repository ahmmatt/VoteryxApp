// lib/features/profile/presentation/screens/delegate_edit_bio_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Layar Edit Bio & Visi — form untuk mengedit profil publik delegate.
/// Menampilkan field bio singkat dengan counter karakter, field visi,
/// dan preview publik sebelum menyimpan perubahan.
class DelegateEditBioScreen extends StatefulWidget {
  const DelegateEditBioScreen({super.key});

  @override
  State<DelegateEditBioScreen> createState() => _DelegateEditBioScreenState();
}

class _DelegateEditBioScreenState extends State<DelegateEditBioScreen> {
  static const int _maxBioChars = 150;

  late final TextEditingController _bioController;
  late final TextEditingController _visiController;
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _visiFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(
      text:
          'Saya adalah delegasi yang berkomitmen untuk mewujudkan transparansi dalam setiap pengambilan kebijakan kampus melalui teknologi digital.',
    );
    _visiController = TextEditingController(
      text:
          '1. Meningkatkan partisipasi mahasiswa dalam forum terbuka universitas hingga 40%.\n'
          '2. Menginisiasi portal aspirasi digital yang terintegrasi langsung dengan birokrasi fakultas.\n'
          '3. Menjamin keterbukaan alokasi anggaran kegiatan mahasiswa melalui laporan transparan.',
    );
    _bioController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bioController.dispose();
    _visiController.dispose();
    _bioFocus.dispose();
    _visiFocus.dispose();
    super.dispose();
  }

  int get _bioLength => _bioController.text.length;
  bool get _isOverLimit => _bioLength > _maxBioChars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  _buildPublicProfileHeader(),
                  const SizedBox(height: AppSpacing.md),

                  // Bio Singkat
                  _buildBioSection(),
                  const SizedBox(height: AppSpacing.md),

                  // Visi Delegasi
                  _buildVisiSection(),
                  const SizedBox(height: AppSpacing.md),

                  // Pratinjau Publik
                  _buildPublicPreviewBanner(),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          // Pinned save button
          _buildSaveButton(context),
        ],
      ),
    );
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Edit Bio & Visi',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  // ─────────────────── Public Profile Header ──────────────────────
  Widget _buildPublicProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary800,
            borderRadius: BorderRadius.circular(AppRadius.cardInner),
          ),
          child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil Publik',
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.primary900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Informasi ini akan ditampilkan kepada seluruh pemilih.',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────── Bio Singkat Section ────────────────────────
  Widget _buildBioSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              const Icon(Icons.person_outlined, color: AppColors.goldDark, size: 18),
              const SizedBox(width: 6),
              Text(
                'Bio Singkat',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Text field
          Stack(
            children: [
              TextField(
                controller: _bioController,
                focusNode: _bioFocus,
                maxLines: 5,
                minLines: 4,
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.primary900,
                  fontSize: 14,
                  height: 1.55,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    borderSide: const BorderSide(color: AppColors.goldMid, width: 1.5),
                  ),
                  hintText: 'Tulis bio singkat Anda...',
                ),
              ),
              // Character counter
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isOverLimit
                        ? Colors.red.withValues(alpha: 0.9)
                        : AppColors.primary800.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$_bioLength/$_maxBioChars',
                    style: AppTypography.captionBold.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Hint text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.outline, size: 13),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Gunakan bahasa yang profesional dan mudah dimengerti.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.outline,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────── Visi Delegasi Section ──────────────────────
  Widget _buildVisiSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              const Icon(Icons.remove_red_eye_outlined, color: AppColors.goldDark, size: 18),
              const SizedBox(width: 6),
              Text(
                'Visi Delegasi',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _visiController,
            focusNode: _visiFocus,
            maxLines: 8,
            minLines: 5,
            style: AppTypography.bodyText.copyWith(
              color: AppColors.primary900,
              fontSize: 14,
              height: 1.55,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: AppColors.goldMid, width: 1.5),
              ),
              hintText: 'Tuliskan visi Anda sebagai delegate...',
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Public Preview Banner ──────────────────────
  Widget _buildPublicPreviewBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.remove_red_eye_outlined,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pratinjau Publik',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tampilan ini akan muncul di kartu kandidat saat proses voting berlangsung. Pastikan semua data sudah benar.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.outline,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Save Button ───────────────────────────────
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      color: AppColors.background,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _isOverLimit ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.save_outlined, size: 18),
          label: Text(
            'Simpan Perubahan',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldDark,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.outlineVariant,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
        ),
      ),
    );
  }
}
