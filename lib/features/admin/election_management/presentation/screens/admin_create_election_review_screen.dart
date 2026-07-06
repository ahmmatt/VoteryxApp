import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminCreateElectionReviewScreen extends StatelessWidget {
  const AdminCreateElectionReviewScreen({super.key});

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
          onPressed: () => context.pop(),
        ),
        title: Text('Buat Pemilihan Baru', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: AppSpacing.xxl),
            
            // Ringkasan Proposal
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDF9F0), Color(0xFFF4ECE1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(Icons.verified_user_outlined, color: AppColors.goldMid.withOpacity(0.1), size: 80),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ringkasan Proposal', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900)),
                      const SizedBox(height: AppSpacing.lg),
                      
                      _buildSummaryItem('Nama Pemilihan', 'Pemilihan Ketua Dewan Perwakilan\nRakyat 2024'),
                      const SizedBox(height: 12),
                      _buildSummaryItem('Jenis', 'Pemilihan Umum Tertutup'),
                      const SizedBox(height: 12),
                      _buildSummaryItemWithBadge('Pengusul', 'Sekretariat Negara', 'VERIFIED'),
                      const SizedBox(height: 12),
                      _buildSummaryItem('Periode', '12 Okt - 15 Okt 2024'),
                      const SizedBox(height: 12),
                      _buildSummaryItem('Estimasi Pemilih', '2,450 Anggota Terdaftar'),
                      const SizedBox(height: 12),
                      _buildSummaryItem('Tujuan', 'Rotasi Kepemimpinan Legislatif'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Daftar Kandidat
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar\nKandidat', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900, height: 1.2)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('3 Kandidat\nTerdaftar', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10, height: 1.2), textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  _buildCandidateItem('AP', 'Arjuna Pratama', 'NIP: 198804012012011002 • Fraksi G-A'),
                  const SizedBox(height: 16),
                  _buildCandidateItem('SB', 'Siti Bahari', 'NIP: 199102142015032001 • Fraksi G-B'),
                  const SizedBox(height: 16),
                  _buildCandidateItem('DR', 'Dodi Rustandi', 'NIP: 198505222010011005 • Fraksi G-C'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Informasi Proses
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.goldMid.withOpacity(0.6),
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.access_time_filled, color: AppColors.primary900, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Informasi Proses', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'Proposal Anda akan melalui tahap verifikasi teknis oleh tim pusat dalam waktu estimasi 1-2 hari kerja.',
                          style: AppTypography.caption.copyWith(color: AppColors.primary900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Publish Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: false,
                          onChanged: (val) {},
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Saya menyatakan bahwa data yang diberikan benar dan telah disetujui oleh pimpinan lembaga berwenang sesuai regulasi yang berlaku.',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Publish action
                        context.goNamed('admin-dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Publish', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.send, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, color: AppColors.textSecondary, size: 16),
                        const SizedBox(width: 8),
                        Text('Edit', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.successTeal, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('Sistem Siap Mengirim', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Footer ID
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary900.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('ID Proposal Sementara: #PR-2024-0012', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepNode(isActive: true),
          _buildStepLine(isActive: true),
          _buildStepNode(isActive: true),
          _buildStepLine(isActive: true),
          _buildStepNode(isActive: true),
        ],
      ),
    );
  }

  Widget _buildStepNode({required bool isActive}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.goldMid,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.goldMid),
      ),
      child: const Center(
        child: Icon(Icons.check, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: AppColors.outlineVariant,
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, height: 1.2)),
      ],
    );
  }

  Widget _buildSummaryItemWithBadge(String label, String value, String badgeText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(value, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary900,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badgeText, style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCandidateItem(String initials, String name, String details) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primary900,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(initials, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              Text(details, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 9)),
            ],
          ),
        ),
        const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
      ],
    );
  }
}
