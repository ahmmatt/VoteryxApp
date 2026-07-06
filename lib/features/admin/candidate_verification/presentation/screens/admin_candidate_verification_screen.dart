import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminCandidateVerificationScreen extends StatelessWidget {
  const AdminCandidateVerificationScreen({super.key});

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
        title: Text('Verifikasi Kandidat', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildCandidateCard(
              name: 'Arjuna Pratama',
              faculty: 'Fakultas Teknik',
              nim: '2021001234',
              time: '2 Jam Lalu',
              imageUrl: 'https://i.pravatar.cc/150?img=11',
              isHighlight: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildCandidateCard(
              name: 'Siti Aminah',
              faculty: 'Fakultas Kedokteran',
              nim: '2021005678',
              time: '5 Jam Lalu',
              imageUrl: 'https://i.pravatar.cc/150?img=5',
              isHighlight: false,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildCandidateCard(
              name: 'Budi Santoso',
              faculty: 'Fakultas Hukum',
              nim: '2021009988',
              time: '1 Hari Lalu',
              imageUrl: 'https://i.pravatar.cc/150?img=12',
              isHighlight: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCandidateCard({
    required String name,
    required String faculty,
    required String nim,
    required String time,
    required String imageUrl,
    required bool isHighlight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: isHighlight ? Border.all(color: AppColors.goldMid) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left border indicator if highlight
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: isHighlight ? AppColors.goldMid : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.card)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl, 
                            width: 48, 
                            height: 48, 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 48,
                              height: 48,
                              color: AppColors.navy600.withOpacity(0.1),
                              child: const Icon(Icons.person, color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(faculty, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldMid.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.goldMid, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('MENUNGGU', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('NIM', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 12)),
                      Text(nim, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Diajukan', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 12)),
                      Text(time, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.outlineVariant),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Lihat Berkas', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldMid,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Tinjau Sekarang', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view, 'Overview', false, () {
                context.pushNamed('admin-dashboard');
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Elections', false, () {
                context.pushNamed('admin-proposals');
              }),
              _buildNavItem(Icons.people_outline, 'Voters', false, () {
                context.pushNamed('admin-candidate-manage');
              }),
              _buildNavItem(Icons.settings_outlined, 'Settings', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
