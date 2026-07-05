import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminElectionLiveDetailScreen extends StatelessWidget {
  const AdminElectionLiveDetailScreen({super.key});

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
        title: Text('Detail Pemilihan', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Elections > Detail Pemilihan 2024', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Pemilihan Umum\nGubernur & Wakil\nGubernur',
                          style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900, height: 1.2),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6FFF4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.successTeal, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('LIVE', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.refresh, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('Perbarui Data', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.share_outlined, size: 16),
                            const SizedBox(width: 8),
                            Text('Bagikan', style: AppTypography.captionBold),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Stats Section (Light blue bg container)
            Container(
              width: double.infinity,
              color: const Color(0xFFF0F4FA),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _buildStatCard(
                    title: 'TOTAL SUARA MASUK',
                    value: '4,281,902',
                    badge: '+12%',
                    hasProgressBar: true,
                    progressValue: 0.4,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    title: 'PARTISIPASI',
                    value: '82.4%',
                    subtitle: 'Target: 85.0%',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    title: 'TPS TERLAPOR',
                    value: '12,402 / 15,000',
                    subtitle: 'Progress: 82.7%',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    title: 'UPDATE TERAKHIR',
                    value: '14:32:05',
                    subtitle: 'WIB, Jakarta',
                    topRightIcon: Icons.access_time,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Chart Section
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tren Suara Per Jam', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
                                  child: const Icon(Icons.show_chart, color: AppColors.textSecondary, size: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
                                  child: const Icon(Icons.download_outlined, color: AppColors.textSecondary, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Mock Bar Chart
                        SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildChartBar(height: 40, label: '08:00', isLive: false),
                              _buildChartBar(height: 60, label: '10:00', isLive: false),
                              _buildChartBar(height: 90, label: '11:00', isLive: false),
                              _buildChartBar(height: 110, label: '12:00', isLive: false),
                              _buildChartBar(height: 130, label: '13:00', isLive: true), // Live
                              _buildChartBar(height: 70, label: '14:00', isLive: false),
                              _buildChartBar(height: 50, label: '15:00', isLive: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Log Aktivitas Data
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Log Aktivitas Data', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildLogItem(
                          icon: Icons.description_outlined,
                          iconBg: const Color(0xFFE6FFF4),
                          iconColor: AppColors.successTeal,
                          title: 'Data Masuk: TPS 042 Bogor',
                          subtitle: '350 Suara Terverifikasi',
                          time: '2 MENIT LALU',
                        ),
                        const SizedBox(height: 12),
                        _buildLogItem(
                          icon: Icons.verified_user_outlined,
                          iconBg: AppColors.background,
                          iconColor: AppColors.textSecondary,
                          title: 'Saksi Terverifikasi',
                          subtitle: 'TPS 112 Jakarta Selatan',
                          time: '5 MENIT LALU',
                        ),
                        const SizedBox(height: 12),
                        _buildLogItem(
                          icon: Icons.sync,
                          iconBg: AppColors.background,
                          iconColor: AppColors.textSecondary,
                          title: 'Sinkronisasi Pusat',
                          subtitle: '98.2% Data Terintegrasi',
                          time: '12 MENIT LALU',
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text('Lihat Semua Log', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Perolehan Suara Kandidat
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Perolehan\nSuara Kandidat', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900, height: 1.2)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Data sementara\nberdasarkan real-count\nsistem.',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Candidate 1
                  _buildCandidateResultCard(
                    rank: 1,
                    name: 'Drs. H. Ahmad\n& Ir. Maya',
                    percentage: '48.2%',
                    votes: '2,063,870 Suara',
                    progressValue: 0.482,
                    imageUrl: 'https://i.pravatar.cc/150?img=11',
                    isWinning: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Candidate 2
                  _buildCandidateResultCard(
                    rank: 2,
                    name: 'Dr. Budi\n& Hj. Siti, M.Si',
                    percentage: '31.5%',
                    votes: '1,348,700 Suara',
                    progressValue: 0.315,
                    imageUrl: 'https://i.pravatar.cc/150?img=5',
                    isWinning: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Candidate 3
                  _buildCandidateResultCard(
                    rank: 3,
                    name: 'Raka Putra\n& Dian S.',
                    percentage: '20.3%',
                    votes: '869,322 Suara',
                    progressValue: 0.203,
                    imageUrl: 'https://i.pravatar.cc/150?img=12',
                    isWinning: false,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    String? subtitle,
    String? badge,
    bool hasProgressBar = false,
    double progressValue = 0.0,
    IconData? topRightIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Stack(
        children: [
          if (topRightIcon != null)
            Positioned(
              top: 0,
              right: 0,
              child: Icon(topRightIcon, color: AppColors.goldMid, size: 20),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(badge, style: AppTypography.captionBold.copyWith(color: AppColors.successTeal)),
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
              if (hasProgressBar) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: AppColors.outlineVariant.withOpacity(0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary900),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar({required double height, required String label, required bool isLive}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isLive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.primary900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('LIVE', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 8)),
          ),
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: isLive ? AppColors.goldMid : AppColors.outlineVariant.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            gradient: isLive
                ? const LinearGradient(
                    colors: [AppColors.goldMid, AppColors.goldDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isLive ? AppColors.primary900 : AppColors.textSecondary,
            fontSize: 9,
            fontWeight: isLive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLogItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
              Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ),
        Text(time, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 8)),
      ],
    );
  }

  Widget _buildCandidateResultCard({
    required int rank,
    required String name,
    required String percentage,
    required String votes,
    required double progressValue,
    required String imageUrl,
    required bool isWinning,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isWinning)
            Positioned(
              top: -10,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldMid,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('UNGGUL', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 9)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KANDIDAT 0$rank', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.0)),
                          const SizedBox(height: 4),
                          Text(name, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold, height: 1.2)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(percentage, style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
                    Text(votes, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: AppColors.outlineVariant.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(isWinning ? AppColors.goldMid : AppColors.goldDark),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('TERVERIFIKASI ', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 8)),
                            const Icon(Icons.check_circle, color: AppColors.successTeal, size: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('REAL-COUNT', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
