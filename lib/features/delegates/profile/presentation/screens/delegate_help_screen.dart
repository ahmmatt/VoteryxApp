// lib/features/profile/presentation/screens/delegate_help_screen.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Layar Panduan Delegate — pusat bantuan khusus untuk delegate.
/// Berisi pencarian, kategori populer, FAQ interaktif,
/// dan banner untuk menghubungi dukungan.
class DelegateHelpScreen extends StatefulWidget {
  const DelegateHelpScreen({super.key});

  @override
  State<DelegateHelpScreen> createState() => _DelegateHelpScreenState();
}

class _DelegateHelpScreenState extends State<DelegateHelpScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: AppSpacing.xl),

            // Kategori Populer
            Text(
              'Kategori Populer',
              style: AppTypography.displayHeading.copyWith(
                fontSize: 18,
                color: AppColors.primary900,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCategoryCard(
              icon: Icons.menu_book_rounded,
              title: 'Cara Eksekusi',
              subtitle:
                  'Langkah demi langkah dalam menjalankan tugas delegasi secara efisien.',
            ),
            _buildCategoryCard(
              icon: Icons.contact_mail_rounded,
              title: 'Manajemen Mandator',
              subtitle:
                  'Panduan mengelola data dan komunikasi dengan pemberi mandat.',
            ),
            _buildCategoryCard(
              icon: Icons.security_rounded,
              title: 'Keamanan Data',
              subtitle:
                  'Protokol privasi dan standar keamanan dalam portal delegasi.',
            ),
            const SizedBox(height: AppSpacing.xl),

            // Pertanyaan Umum (FAQ)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pertanyaan Umum',
                  style: AppTypography.displayHeading.copyWith(
                    fontSize: 18,
                    color: AppColors.primary900,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.goldDark,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.open_in_new_rounded,
                      color: AppColors.goldDark,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildFaqItem('Bagaimana cara verifikasi identitas mandator?'),
            _buildFaqItem('Apa yang harus dilakukan jika terjadi kegagalan sistem?'),
            _buildFaqItem('Apakah riwayat delegasi dapat diunduh?'),
            const SizedBox(height: AppSpacing.xl),

            // Support Banner
            _buildSupportBanner(),
            const SizedBox(height: AppSpacing.xl),

            // Image Placeholders
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=500&q=80'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=500&q=80'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
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
        'Panduan Delegate',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  // ─────────────────── Search Bar ────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTypography.bodyText.copyWith(
          color: AppColors.primary900,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Cari bantuan atau FAQ...',
          hintStyle: AppTypography.bodyText.copyWith(
            color: AppColors.outline,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ─────────────────── Category Card ─────────────────────────────
  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary900,
              borderRadius: BorderRadius.circular(AppRadius.cardInner),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.displayHeading.copyWith(
              fontSize: 16,
              color: AppColors.primary900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.bodyText.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── FAQ Item ──────────────────────────────────
  Widget _buildFaqItem(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            question,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary900,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: Text(
                'Jawaban untuk pertanyaan tersebut akan dimuat di sini. Ini adalah teks placeholder.',
                style: AppTypography.bodyText.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── Support Banner ────────────────────────────
  Widget _buildSupportBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary900,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masih butuh bantuan?',
            style: AppTypography.displayHeading.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tim support kami siap membantu\nAnda 24/7 untuk memastikan\noperasional portal berjalan lancar.',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.support_agent_rounded, size: 18),
              label: Text(
                'Hubungi Support Agent',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
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
        ],
      ),
    );
  }
}
