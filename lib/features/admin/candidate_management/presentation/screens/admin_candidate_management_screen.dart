import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminCandidateManagementScreen extends StatelessWidget {
  const AdminCandidateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Kelola kandidat', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manajemen Kandidat', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Kelola verifikasi dan profil kandidat pemilihan tahun ini.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('TAMBAH KANDIDAT', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nama atau NIM kandidat...',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outlineVariant),
                  prefixIcon: const Icon(Icons.search, color: AppColors.outlineVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Filters
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 12),
                      Text('Semua Fakultas', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 12),
                      Text('Status Verifikasi', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Candidates Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary900,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text('KANDIDAT', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10))),
                        Expanded(flex: 2, child: Text('FAKULTAS', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10))),
                        Expanded(flex: 1, child: Text('NOMOR\nURUT', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10, height: 1.2), textAlign: TextAlign.right)),
                      ],
                    ),
                  ),
                  // Items
                  _buildCandidateRow('Budi\nSantoso', '120220301', 'Teknik\nInformatika', '01', 'https://i.pravatar.cc/150?img=11'),
                  _buildCandidateRow('Siti\nAminah', '120220455', 'Ekonomi &\nBisnis', '02', 'https://i.pravatar.cc/150?img=5'),
                  _buildCandidateRow('Dimas\nPrayoga', '120220912', 'Hukum', '03', 'https://i.pravatar.cc/150?img=12', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Summaries
            _buildSummaryCard(
              icon: Icons.people_alt,
              title: 'TOTAL KANDIDAT',
              value: '24',
              color: AppColors.primary900,
              iconBgColor: AppColors.outlineVariant.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.verified_outlined,
              title: 'TERVERIFIKASI',
              value: '18',
              color: AppColors.primary900,
              iconBgColor: const Color(0xFFE6FFF4),
              iconColor: AppColors.successTeal,
              borderColor: AppColors.successTeal,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.pending_actions,
              title: 'MENUNGGU',
              value: '06',
              color: AppColors.primary900,
              iconBgColor: const Color(0xFFFDF9F0),
              iconColor: AppColors.goldMid,
              borderColor: AppColors.goldMid,
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.goldDark,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCandidateRow(String name, String nim, String fakultas, String nomor, String imgUrl, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(imgUrl, width: 32, height: 32, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, height: 1.2)),
                      const SizedBox(height: 4),
                      Text('NIM:', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 9)),
                      Text(nim, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(fakultas, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.2)),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Text(nomor, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconBgColor,
    Color? iconColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: borderColor != null ? Border.all(color: borderColor.withOpacity(0.5)) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
              Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: color)),
            ],
          ),
        ],
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
              _buildNavItem(Icons.people_outline, 'Voters', true, () {}),
              _buildNavItem(Icons.settings_outlined, 'Settings', false, () {}),
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
