import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Bantuan', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: AppSpacing.lg),
            _buildBanner(),
            const SizedBox(height: AppSpacing.xl),
            
            _buildSectionTitle(Icons.info_outline, 'TENTANG VOTERYX'),
            _buildFaqItem('Apa itu liquid democracy?'),
            _buildFaqItem('Bagaimana voting blockchain bekerja?'),
            const SizedBox(height: AppSpacing.md),
            
            _buildSectionTitle(Icons.verified_user_outlined, 'KEAMANAN'),
            _buildFaqItem('Bagaimana data saya dilindungi?'),
            _buildFaqItem('Apakah pilihan saya anonim?'),
            const SizedBox(height: AppSpacing.md),
            
            _buildSectionTitle(Icons.people_outline, 'DELEGASI'),
            _buildFaqItem('Bagaimana cara menarik delegasi?'),
            _buildFaqItem('Siapa saja yang bisa menjadi ahli?'),
            const SizedBox(height: AppSpacing.xl),
            
            _buildSupportCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.input),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari bantuan atau FAQ...',
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outlineVariant),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: const LinearGradient(
          colors: [Color(0xFFB1C4D9), Color(0xFFE2EAF4)], // Approximate grayish-blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Placeholder for the 3D graphics in the banner
          Positioned(
            left: -20,
            bottom: -20,
            child: Icon(Icons.inventory_2, size: 100, color: Colors.white.withOpacity(0.4)),
          ),
          Positioned(
            right: 20,
            top: 10,
            child: Icon(Icons.phone_android, size: 80, color: Colors.black.withOpacity(0.1)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                'Ada yang bisa kami bantu?',
                style: AppTypography.cardTitle.copyWith(color: AppColors.primary900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary900),
          const SizedBox(width: AppSpacing.sm),
          Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: AppColors.textPrimary,
            collapsedIconColor: AppColors.textPrimary,
            title: Text(title, style: AppTypography.itemTitle.copyWith(fontSize: 13)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                child: Text(
                  'Penjelasan lengkap mengenai "$title" akan tampil di sini. Fitur ini dirancang untuk transparan dan aman.',
                  style: AppTypography.bodyText.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary900,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.goldDark.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent, color: AppColors.goldMid, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Masih butuh bantuan?',
            style: AppTypography.cardTitle.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tim admin kami siap membantu Anda 24/7.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyText.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.xl),
          GoldButton(
            label: 'Chat dengan Admin',
            icon: Icons.chat_bubble_outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
