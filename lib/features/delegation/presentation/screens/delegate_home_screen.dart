import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateHomeScreen extends StatelessWidget {
  const DelegateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button for home
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HALO,', style: AppTypography.caption.copyWith(color: AppColors.outlineVariant, fontSize: 10, letterSpacing: 1.0)),
                Text('Ahmad Rizki', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.goldMid,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.primary900, size: 14),
                  const SizedBox(width: 4),
                  Text('DELEGATE', style: AppTypography.captionBold.copyWith(color: AppColors.primary900, fontSize: 10)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Stats Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFDF9F0), Color(0xFFF3E7CA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCol('47', 'SUARA DIPEGANG', valueColor: AppColors.goldDark),
                    // Circular Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: 0.78,
                            strokeWidth: 4,
                            backgroundColor: AppColors.goldMid.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldDark),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('78%', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                          ],
                        ),
                      ],
                    ),
                    _buildStatCol('2', 'PEMILIHAN AKTIF', valueColor: AppColors.primary900, hasIcon: true),
                  ],
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text('TRUST SCORE', style: TextStyle(fontSize: 9, color: AppColors.goldDark, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Warning Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5), // Light pinkish
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text('Eksekusi Diperlukan!', style: AppTypography.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Batas waktu delegasi untuk aspirasi Mahasiswa Baru akan berakhir dalam 4 jam.',
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // Goes to Eksekusi
                          context.pushNamed('delegate-vote-execution');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Eksekusi Sekarang', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Live Mandat Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E7CA).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.goldMid.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MANDAT SAAT INI', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, letterSpacing: 1.0)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('LIVE', style: AppTypography.captionBold.copyWith(color: Colors.red, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Ketua BEM 2026', style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Konsensus', style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
                        Text('78%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.78,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.goldDark,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 32,
                          child: Stack(
                            children: [
                              _buildAvatar(0, 'https://i.pravatar.cc/150?img=5'),
                              _buildAvatar(1, 'https://i.pravatar.cc/150?img=8'),
                              _buildAvatar(2, 'https://i.pravatar.cc/150?img=3'),
                              Positioned(
                                left: 3 * 20.0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.goldMid,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(child: Text('+44', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 9))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text('Lihat Manifesto', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                            const SizedBox(width: 4),
                            const Icon(Icons.open_in_new, color: AppColors.goldDark, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              Text('Aktivitas Terkini', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              
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
                    _buildActivityItem(
                      icon: Icons.person_add_alt_1,
                      iconBgColor: const Color(0xFFFDF9F0),
                      iconColor: AppColors.goldDark,
                      title: 'Siti Rahma mendelegasikan suara kepadamu',
                      time: 'Baru saja',
                    ),
                    const Divider(height: 1, color: AppColors.outlineVariant),
                    _buildActivityItem(
                      icon: Icons.check_circle_outline,
                      iconBgColor: const Color(0xFFE6FFF4),
                      iconColor: const Color(0xFF139971),
                      title: 'Kamu mengeksekusi 31 suara untuk Isu Transportasi Kampus',
                      time: '2 jam yang lalu',
                    ),
                    const Divider(height: 1, color: AppColors.outlineVariant),
                    _buildActivityItem(
                      icon: Icons.person_remove_alt_1,
                      iconBgColor: const Color(0xFFFFF5F5),
                      iconColor: Colors.redAccent,
                      title: 'Budi Santoso mencabut delegasinya',
                      time: 'Kemarin, 15:40',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildStatCol(String value, String label, {required Color valueColor, bool hasIcon = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 28, color: valueColor, height: 1.0)),
            if (hasIcon)
              const Icon(Icons.campaign, color: Colors.red, size: 12),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 9, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildAvatar(int index, String url) {
    return Positioned(
      left: index * 20.0,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, height: 1.4)),
                const SizedBox(height: 4),
                Text(time, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
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
              _buildNavItem(Icons.home_outlined, 'Beranda', true, () {}),
              _buildNavItem(Icons.gavel_outlined, 'Mandat', false, () {
                context.pushNamed('delegate-dashboard');
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Eksekusi', false, () {
                context.pushNamed('delegate-history');
              }),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {
                context.goNamed('profile');
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
