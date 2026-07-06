import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Pagi,', style: AppTypography.caption.copyWith(color: AppColors.outlineVariant, fontSize: 12)),
            Text('Admin Pemilu FST', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusBadge('Server: Online', AppColors.successTeal),
                  _buildStatusBadge('Blockchain: Sinkron', AppColors.successTeal),
                  _buildStatusBadge('KYC', AppColors.successTeal), // Cut off in image
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistik Hari Ini', style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Grid Statistik
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Suara',
                          value: '2,847',
                          subtitle: '+12% vs last hour',
                          subtitleColor: AppColors.successTeal,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Partisipasi',
                          value: '68.4%',
                          subtitle: '+4.2% trend up',
                          subtitleColor: AppColors.successTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Delegasi Aktif',
                          value: '412',
                          subtitle: 'Node Terverifikasi',
                          subtitleColor: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total DPT',
                          value: '4,162',
                          subtitle: 'Mahasiswa Terdaftar',
                          subtitleColor: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Chart Section (Placeholder)
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ketua BEM 2026', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                                Text('Tren partisipasi per jam (Live Data)', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6FFF4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.successTeal.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.successTeal, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text('LIVE', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal, fontSize: 9)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Chart Placeholder
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Mock Chart line and gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.goldMid.withOpacity(0.4),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                              CustomPaint(
                                size: const Size(double.infinity, 150),
                                painter: _MockChartPainter(),
                              ),
                              // Mock tooltips/labels
                              Positioned(
                                top: 10,
                                right: 60,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary900,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('68%', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
                                ),
                              ),
                              // X-axis labels
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('08:00', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 10)),
                                    Text('10:00', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 10)),
                                    Text('12:00', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 10)),
                                    Text('14:00', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 10)),
                                    Text('16:00', style: AppTypography.caption.copyWith(color: AppColors.outline, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Pemilihan Aktif Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pemilihan Aktif', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontSize: 16)),
                      Text('Lihat Semua', style: AppTypography.captionBold.copyWith(color: AppColors.navy600)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Active Election Card (Live)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF9F0),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.goldMid.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.how_to_vote, color: AppColors.primary900, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ketua BEM 2026', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('LIVE', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal, fontSize: 10)),
                                  const SizedBox(width: 8),
                                  Text('Ends in 4h 20m', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('68%', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900)),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 60,
                              height: 4,
                              child: LinearProgressIndicator(
                                value: 0.68,
                                backgroundColor: AppColors.outlineVariant.withOpacity(0.5),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary900),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Upcoming Election Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ketua HIMA TI 2026', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900)),
                              const SizedBox(height: 4),
                              Text('Terjadwal: Besok, 08:00', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Aksi Cepat
                  Text('Aksi Cepat', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontSize: 16)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: AppColors.goldMid,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed('proposal-create');
                            },
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              child: Column(
                                children: [
                                  const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
                                  const SizedBox(height: 8),
                                  Text('Buat Pemilihan Baru', style: AppTypography.captionBold.copyWith(color: Colors.white), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: AppColors.primary900,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed('admin-candidate-verification');
                                },
                                borderRadius: BorderRadius.circular(AppRadius.card),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Icon(Icons.verified_user_outlined, color: Colors.white, size: 28),
                                      const SizedBox(height: 8),
                                      Text('Verifikasi Kandidat', style: AppTypography.captionBold.copyWith(color: Colors.white), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text('3', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10, height: 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatusBadge(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required String subtitle, required Color subtitleColor}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
          Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.caption.copyWith(color: subtitleColor, fontSize: 9)),
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
              _buildNavItem(Icons.grid_view, 'Overview', true, () {}),
              _buildNavItem(Icons.how_to_vote_outlined, 'Elections', false, () {
                context.pushNamed('admin-proposals');
              }),
              _buildNavItem(Icons.how_to_reg, 'Delegates', false, () {
                context.pushNamed('admin-delegate-applications');
              }),
              _buildNavItem(Icons.people_outline, 'Voters', false, () {
                context.pushNamed('admin-candidate-manage'); // Using candidate manage as voters/candidates proxy for now
              }),
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

class _MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldDark
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    final path = Path();
    path.moveTo(0, size.height - 20);
    path.quadraticBezierTo(size.width * 0.25, size.height - 15, size.width * 0.35, size.height - 10);
    path.quadraticBezierTo(size.width * 0.5, size.height + 10, size.width * 0.6, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, 40, size.width * 0.8, 35);
    path.quadraticBezierTo(size.width * 0.9, 30, size.width, 30);
    
    canvas.drawPath(path, paint);
    
    // Draw the dot at 68%
    final dotPaint = Paint()..color = AppColors.primary900;
    canvas.drawCircle(Offset(size.width * 0.77, 36), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
