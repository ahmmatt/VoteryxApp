import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateExecutionHistoryScreen extends StatelessWidget {
  const DelegateExecutionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Riwayat Eksekusi', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Top Stats Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF3E7CA), Color(0xFFE8D3A8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('3', 'PEMILIHAN'),
                    Container(height: 40, width: 1, color: AppColors.goldDark.withOpacity(0.2)),
                    _buildStatItem('96', 'TOTAL SUARA'),
                    Container(height: 40, width: 1, color: AppColors.goldDark.withOpacity(0.2)),
                    _buildStatItem('100%', 'TEPAT WAKTU'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('2026', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('2025', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('BEM', false),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // List of Executions
              _buildExecutionCard(
                title: 'Ketua BEM UI 2026',
                date: '07 Jun 2026',
                votes: 47,
                mandators: 12,
                accuracy: '96% tepat waktu',
                status: 'Selesai',
              ),
              _buildExecutionCard(
                title: 'HIMA Teknik 2025',
                date: '12 Des 2025',
                votes: 31,
                mandators: 8,
                status: 'Selesai',
              ),
              _buildExecutionCard(
                title: 'Rektor 2024',
                date: '15 Nov 2024',
                votes: 18,
                status: 'Selesai',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.goldDark)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 10, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary900 : Colors.white,
        border: Border.all(color: isSelected ? AppColors.primary900 : AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildExecutionCard({
    required String title,
    required String date,
    required int votes,
    int? mandators,
    String? accuracy,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Green left border
          Container(width: 4, height: 120, color: const Color(0xFF10B981)),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.list_alt, color: Color(0xFF10B981), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
                            const SizedBox(height: 2),
                            Text(date, style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(status, style: AppTypography.captionBold.copyWith(color: const Color(0xFF10B981), fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBadge(Icons.how_to_vote, '$votes suara', AppColors.goldDark, AppColors.goldDark),
                      if (mandators != null)
                        _buildBadge(Icons.people, '$mandators mandator', AppColors.primary900, AppColors.primary900),
                      if (accuracy != null)
                        _buildBadge(Icons.timer_outlined, accuracy, const Color(0xFF10B981), const Color(0xFFD1FAE5), textColor: const Color(0xFF10B981)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color, Color bgColor, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor == color ? color : bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: bgColor == color ? Colors.white : color),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.captionBold.copyWith(color: textColor ?? Colors.white)),
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
              _buildNavItem(Icons.home_outlined, 'Beranda', false, () {
                context.pushNamed('delegate-home');
              }),
              _buildNavItem(Icons.gavel_outlined, 'Mandat', false, () {
                context.pop();
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Eksekusi', true, () {}),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {}),
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
                color: AppColors.goldMid.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppColors.goldDark : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? AppColors.goldDark : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
