import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateDashboardScreen extends StatelessWidget {
  const DelegateDashboardScreen({super.key});

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
        title: Text('Manajemen Mandat', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.pageGradient),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: 100, // Space for bottom button
              ),
              child: Column(
                children: [
                  // Top Status Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF3E7CA), Color(0xFFE8D3A8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldMid.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TOTAL BOBOT SUARA', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, letterSpacing: 1.0)),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('47', style: AppTypography.displayHeading.copyWith(fontSize: 48, height: 1.0, color: AppColors.primary900)),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text('Delegasi Terverifikasi', style: AppTypography.caption.copyWith(color: AppColors.primary900)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.85,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.goldDark,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('Ketua BEM\n2026', style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.goldDark)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Trust Circle
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.goldDark, width: 4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('TRUST', style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.primary900)),
                                Text('85%', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTab('Semua (12)', true),
                        const SizedBox(width: 8),
                        _buildTab('Aktif (10)', false),
                        const SizedBox(width: 8),
                        _buildTab('Menunggu (2)', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Mandators List
                  _buildMandatorCard(
                    name: 'Siti Rahma',
                    nim: '220104052',
                    faculty: 'Ilmu Komputer',
                    votes: 1,
                    status: 'Menunggu',
                    statusColor: AppColors.goldDark,
                    imageUrl: 'https://i.pravatar.cc/150?img=5',
                  ),
                  _buildMandatorCard(
                    name: 'Ahmad Fauzi',
                    nim: '220104099',
                    faculty: 'Teknik Mesin',
                    votes: 1,
                    status: 'Aktif',
                    statusColor: Colors.green,
                    imageUrl: 'https://i.pravatar.cc/150?img=11',
                  ),
                  _buildMandatorCard(
                    name: 'Dian Kartika',
                    nim: '220104011',
                    faculty: 'Psikologi',
                    votes: 0,
                    status: 'Mandat telah ditarik oleh pemberi',
                    statusColor: Colors.red,
                    imageUrl: 'https://i.pravatar.cc/150?img=9',
                    isRevoked: true,
                  ),
                  _buildMandatorCard(
                    name: 'Kevin Pratama',
                    nim: '220104105',
                    faculty: 'Ekonomi',
                    votes: 1,
                    status: 'Aktif',
                    statusColor: Colors.green,
                    imageUrl: 'https://i.pravatar.cc/150?img=12',
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Fixed Button
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldDark.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.pushNamed('delegate-vote-execution');
                  },
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Eksekusi 47 Suara untuk BEM 2026', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                     const SizedBox(width: 8),
                     const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                   ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.goldMid : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : AppColors.outlineVariant),
      ),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMandatorCard({
    required String name,
    required String nim,
    required String faculty,
    required int votes,
    required String status,
    required Color statusColor,
    required String imageUrl,
    bool isRevoked = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isRevoked ? const Color(0xFFF9FAFB) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: isRevoked ? Border.all(color: Colors.red.withOpacity(0.2), style: BorderStyle.solid) : null,
        boxShadow: isRevoked ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: isRevoked ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.displayHeading.copyWith(
                          fontSize: 18,
                          color: isRevoked ? AppColors.textSecondary : AppColors.primary900,
                          decoration: isRevoked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    if (isRevoked)
                       Text('DICABUT', style: AppTypography.captionBold.copyWith(color: Colors.red.withOpacity(0.6))),
                    if (!isRevoked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldMid.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('$votes suara', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 10)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$nim • $faculty', style: AppTypography.caption.copyWith(color: AppColors.outline)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor)),
                    const SizedBox(width: 6),
                    Text(isRevoked ? status : 'Status: $status', style: AppTypography.captionBold.copyWith(color: statusColor, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          if (isRevoked)
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 12),
              child: Icon(Icons.do_not_disturb_alt, color: Colors.redAccent, size: 20),
            ),
          if (!isRevoked)
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 12),
              child: Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
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
              _buildNavItem(Icons.home_outlined, 'Beranda', false, () {
                context.pushNamed('delegate-home');
              }),
              _buildNavItem(Icons.gavel_outlined, 'Mandat', true, () {}),
              _buildNavItem(Icons.how_to_vote_outlined, 'Eksekusi', false, () {
                context.pushNamed('delegate-history');
              }),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {
                context.pushNamed('profile');
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
