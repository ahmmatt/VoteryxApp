import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminVoterManagementScreen extends StatelessWidget {
  const AdminVoterManagementScreen({super.key});

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
        title: Text('Manajemen Pemilih', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manajemen Pemilih', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Daftar Pemilih Tetap (DPT) untuk Pemilihan Raya Mahasiswa 2024.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.note_add_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text('Import DPT (CSV/Excel)', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text('Tambah Manual', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Stats List
            _buildStatCard(
              icon: Icons.people_alt_outlined,
              title: 'TOTAL PEMILIH',
              value: '12,482',
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              icon: Icons.verified_user_outlined,
              title: 'TERVERIFIKASI',
              value: '10,102',
              subtitle: '80.9% dari total',
              subtitleColor: AppColors.successTeal,
              iconColor: AppColors.successTeal,
              isHighlight: true,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              icon: Icons.assignment_late_outlined,
              title: 'BELUM VERIFIKASI',
              value: '2,380',
              iconColor: Colors.red,
            ),
            const SizedBox(height: 12),
            // Dark Stat Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary900,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.move_to_inbox, color: Colors.white, size: 28),
                  const SizedBox(height: 12),
                  Text('SUARA MASUK', style: AppTypography.captionBold.copyWith(color: AppColors.outlineVariant, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text('4,892', style: AppTypography.displayHeading.copyWith(fontSize: 28, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Live Analytics', style: AppTypography.caption.copyWith(color: AppColors.outlineVariant, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Search and Filters
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  // Search Input
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari NIM atau Nama Pemilih...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outlineVariant),
                        prefixIcon: const Icon(Icons.search, color: AppColors.outlineVariant),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filters Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Semua Fakultas', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.filter_list, color: AppColors.primary900, size: 18),
                              const SizedBox(width: 8),
                              Text('Filter', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // DPT Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: AppColors.primary900,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text('NIM', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10))),
                        Expanded(flex: 3, child: Text('FAKULTAS /\nPRODI', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10, height: 1.2))),
                        Expanded(flex: 2, child: Text('STATUS', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10), textAlign: TextAlign.right)),
                      ],
                    ),
                  ),
                  
                  // Rows
                  _buildDptRow('20210810012', 'Teknik\nInformatika', 'Fakultas Teknik', _buildBadge(true, 'TERVERIFIKASI')),
                  _buildDptRow('20210810045', 'Manajemen', 'Fakultas Ekonomi', _buildBadge(false, 'BELUM VERIFIKASI')),
                  _buildDptRow('20220910089', 'Kedokteran\nUmum', 'Fakultas Kedokteran', _buildTextStatus('AKTIF', AppColors.successTeal)),
                  _buildDptRow('20210810102', 'Teknik Sipil', 'Fakultas Teknik', _buildBadge(true, 'TERVERIFIKASI')),
                  
                  // Pagination
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Menampilkan 1-10 dari 12,482 data', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                        ),
                        Row(
                          children: [
                            _buildPageButton('<', false),
                            const SizedBox(width: 4),
                            _buildPageButton('1', true),
                            const SizedBox(width: 4),
                            _buildPageButton('2', false),
                            const SizedBox(width: 4),
                            _buildPageButton('3', false),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Color? subtitleColor,
    Color? iconColor,
    bool isHighlight = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: isHighlight ? Border.all(color: AppColors.successTeal.withOpacity(0.3)) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: isHighlight ? AppColors.successTeal : Colors.transparent,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.card)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor ?? AppColors.primary900, size: 28),
                  const SizedBox(height: 12),
                  Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 28, color: AppColors.primary900)),
                  if (subtitle != null && subtitleColor != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTypography.captionBold.copyWith(color: subtitleColor, fontSize: 10)),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDptRow(String nim, String prodi, String fakultas, Widget statusWidget) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(nim, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900))),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prodi, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, height: 1.2)),
                Text(fakultas, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: statusWidget)),
        ],
      ),
    );
  }

  Widget _buildBadge(bool verified, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified ? AppColors.primary900 : AppColors.outlineVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (verified) ...[
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(text, style: AppTypography.captionBold.copyWith(color: verified ? Colors.white : AppColors.textSecondary, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildTextStatus(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: AppTypography.captionBold.copyWith(color: color, fontSize: 10)),
      ],
    );
  }

  Widget _buildPageButton(String text, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.goldMid : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: isActive ? null : Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTypography.captionBold.copyWith(
            color: isActive ? Colors.white : AppColors.primary900,
            fontSize: 10,
          ),
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
              _buildNavItem(Icons.people_outline, 'Voters', true, () {}),
              _buildNavItem(Icons.settings_outlined, 'Settings', false, () {
                context.pushNamed('admin-settings');
              }),
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
