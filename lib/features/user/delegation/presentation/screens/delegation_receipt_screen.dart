import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/core/widgets/ghost_button.dart';

class DelegationReceiptScreen extends StatelessWidget {
  const DelegationReceiptScreen({super.key});

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
        title: Text('E-Receipt', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: ClipOval(
              child: Image.network(
                'https://ui-avatars.com/api/?name=User&background=random',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: AppColors.goldMid,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            _buildSuccessHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildReceiptCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildInfoBox(),
            const SizedBox(height: AppSpacing.xl),
            GoldButton(
              label: 'Simpan Bukti ke Galeri',
              icon: Icons.download,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            GhostButton(
              label: 'Kembali ke Beranda',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.goldGradient,
          ),
          child: const Center(
            child: Icon(Icons.people, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Delegasi Berhasil!', style: AppTypography.screenTitle),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Suara Anda telah didelegasikan secara aman kepada perwakilan tepercaya dalam ekosistem Voteryx.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('E-RECEIPT OFFICIAL', style: AppTypography.captionBold.copyWith(color: AppColors.outlineVariant)),
          const SizedBox(height: 4),
          Text('BUKTI DELEGASI', style: AppTypography.screenTitle.copyWith(color: AppColors.navyMid)),
          const SizedBox(height: AppSpacing.xl),
          
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TRANSACTION HASH', style: AppTypography.caption),
                      Text('0x7f4e...9b2c8a1e3f5d7c9b0a', style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.copy, size: 20, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          _buildReceiptRow('Waktu', '24 Okt 2023, 14:32:01 WIB'),
          const SizedBox(height: AppSpacing.md),
          _buildReceiptRow('Pemilihan', 'Ketua BEM UI 2024', isBold: true),
          const SizedBox(height: AppSpacing.md),
          _buildReceiptRowWithAvatar('Didelegasikan ke', 'Ahmad Rizki'),
          const SizedBox(height: AppSpacing.md),
          _buildReceiptStatusRow('Status', 'AKTIF DELEGASI'),
          
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: 120,
            height: 120,
            color: AppColors.primary800, // Placeholder for QR code
            child: Center(
              child: Icon(Icons.qr_code_2, color: Colors.white, size: 80),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'SCAN UNTUK\nMEMVALIDASI\nINTEGRITAS DELEGASI DI\nJARINGAN',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: AppColors.outline, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
        Text(
          value,
          style: isBold 
              ? AppTypography.bodyMedium.copyWith(fontSize: 14) 
              : AppTypography.bodyText.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildReceiptRowWithAvatar(String label, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldMid,
              ),
              child: Center(
                child: Text('A', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(name, style: AppTypography.bodyMedium.copyWith(fontSize: 14)),
          ],
        )
      ],
    );
  }

  Widget _buildReceiptStatusRow(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: AppTypography.labelSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE8DE), // Slightly darker beige
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: AppColors.goldDark, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Delegasi ini bersifat transparan namun privasi identitas tetap terjaga. Anda dapat sewaktu-waktu dibatalkan melalui menu pengaturan pemilihan sebelum periode berakhir.',
              style: AppTypography.bodyText.copyWith(fontSize: 13, color: const Color(0xFF8C6615)),
            ),
          ),
        ],
      ),
    );
  }
}
