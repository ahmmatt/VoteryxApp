import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class AdminCandidateDocumentsScreen extends StatelessWidget {
  const AdminCandidateDocumentsScreen({super.key});

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
            onPressed: () => context.pop()),
        title: Text('Berkas Kandidat',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildCandidateHeader(),
            const SizedBox(height: AppSpacing.xl),
            Text('Dokumen Pengajuan',
                style: AppTypography.screenTitle.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),
            _buildDocumentTile('Formulir Pendaftaran', 'PDF • 1.2 MB',
                Icons.description_outlined, true),
            const SizedBox(height: AppSpacing.sm),
            _buildDocumentTile('Kartu Tanda Mahasiswa', 'JPG • 860 KB',
                Icons.badge_outlined, true),
            const SizedBox(height: AppSpacing.sm),
            _buildDocumentTile('Surat Rekomendasi', 'PDF • 980 KB',
                Icons.verified_outlined, true),
            const SizedBox(height: AppSpacing.sm),
            _buildDocumentTile('Visi & Misi Kandidat', 'PDF • 740 KB',
                Icons.campaign_outlined, false),
            const SizedBox(height: AppSpacing.xl),
            _buildNoteCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
              color: AppColors.navy600.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.person,
              color: AppColors.textSecondary, size: 30),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Arjuna Pratama',
              style: AppTypography.itemTitle
                  .copyWith(color: AppColors.primary900)),
          const SizedBox(height: 4),
          Text('Fakultas Teknik • 2021001234',
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: AppColors.goldMid.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldMid.withOpacity(0.3))),
          child: Text('4 Berkas',
              style: AppTypography.captionBold
                  .copyWith(color: AppColors.goldDark, fontSize: 10)),
        ),
      ]),
    );
  }

  Widget _buildDocumentTile(
      String title, String meta, IconData icon, bool verified) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  verified ? const Color(0xFFE8F6F2) : const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon,
              color: verified ? AppColors.successTeal : AppColors.warningAmber,
              size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(meta,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
        ])),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined,
                color: AppColors.primary800)),
      ]),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.goldMid.withOpacity(0.35))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline, color: AppColors.goldDark, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                'Pastikan semua berkas sesuai sebelum menekan tombol tinjau pada halaman verifikasi kandidat.',
                style: AppTypography.caption
                    .copyWith(color: AppColors.primary900, height: 1.45))),
      ]),
    );
  }
}
