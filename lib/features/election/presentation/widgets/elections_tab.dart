import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';
import '../screens/election_detail_screen.dart';

class ElectionsTab extends StatelessWidget {
  const ElectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Section (Navy Background AppBar)
        _buildAppBar(context),
        
        // Body
        Expanded(
          child: Container(
            color: AppColors.background,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  'Daftar Pemilihan',
                  style: AppTypography.displayHeading.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tentukan masa depan institusi Anda hari ini.',
                  style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Live Election Card
                _buildLiveElectionCard(context),
                const SizedBox(height: AppSpacing.lg),
                
                // Completed Election Card
                _buildCompletedElectionCard(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary800,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        bottom: AppSpacing.md,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Can go back to home tab if needed, or pop if it was pushed
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Elections',
            style: AppTypography.headerTitle.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveElectionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB), // Light red
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935), // Red
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Live',
                      style: AppTypography.captionBold.copyWith(color: const Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.receipt_long_outlined, color: AppColors.navyMid, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text('Pemilihan Ketua BEM 2026', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.navyMid, size: 16),
              const SizedBox(width: 6),
              Text('02 HARI : 14 JAM : 30 MENIT', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Progress Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Partisipasi Pemilih', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              Text('62%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.goldDark)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.62,
              backgroundColor: Color(0xFFE4E9F7),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldDark),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '12,402 dari 20,000 mahasiswa sudah memilih',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Info Boxes Row
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  icon: Icons.person_outline,
                  title: 'Kandidat',
                  value: '2 Kandidat',
                  bgColor: const Color(0xFFF8F9FA),
                  iconColor: AppColors.navyMid,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildInfoBox(
                  icon: Icons.people_outline,
                  title: 'Delegasi',
                  value: '3 Aktif',
                  bgColor: const Color(0xFFE8F5E9), // Light green
                  iconColor: const Color(0xFF2E7D32), // Dark green
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Lihat Detail', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ),
              InkWell(
                onTap: () {
                  context.pushNamed('election', pathParameters: {'id': '1'});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.goldDark,
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A030), Color(0xFFB38622)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMid.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Pilih Sekarang', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedElectionCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // Light grey
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Selesai',
                  style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const Icon(Icons.check_circle_outline, color: AppColors.textSecondary, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text('Pemilihan Senat Mahasiswa', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text('Berakhir pada 12 Okt 2025', style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          
          // Bottom Action
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF384666), // Dark Navy button
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(
              'Lihat Hasil Akhir',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.captionBold.copyWith(fontSize: 10)),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
