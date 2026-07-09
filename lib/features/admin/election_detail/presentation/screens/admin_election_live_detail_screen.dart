import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/core/network/supabase_client.dart';
import 'package:voteryxapp/features/admin/dashboard/presentation/providers/admin_dashboard_provider.dart';
import 'package:voteryxapp/features/user/election/presentation/widgets/election_summary_white_card.dart';

class AdminElectionLiveDetailScreen extends ConsumerStatefulWidget {
  const AdminElectionLiveDetailScreen({
    super.key,
    this.electionId,
    this.electionTitle,
  });

  final String? electionId;
  final String? electionTitle;

  @override
  ConsumerState<AdminElectionLiveDetailScreen> createState() =>
      _AdminElectionLiveDetailScreenState();
}

class _AdminElectionLiveDetailScreenState
    extends ConsumerState<AdminElectionLiveDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Map<String, dynamic>> _candidates = [];
  bool _isLoadingCandidates = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    setState(() => _isLoadingCandidates = true);
    try {
      List<dynamic> resp = [];
      if (widget.electionId != null && widget.electionId!.isNotEmpty) {
        resp = await SupabaseConfig.client
            .from('candidates')
            .select('*')
            .eq('election_id', widget.electionId!)
            .order('candidate_number', ascending: true);
      }
      _candidates = List<Map<String, dynamic>>.from(resp);
    } catch (_) {
      _candidates = [];
    } finally {
      if (mounted) {
        setState(() => _isLoadingCandidates = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(adminDashboardProvider);
    final numberFormat = NumberFormat.decimalPattern('id_ID');

    final String displayTitle = widget.electionTitle ??
        (stats.activeElections.isNotEmpty
            ? stats.activeElections.first['title']?.toString() ??
                'Pemilihan Voteryx'
            : 'Ketua BEM FST 2026');

    String displayEndsIn = 'Ends in 4h 20m';
    if (stats.activeElections.isNotEmpty) {
      final match = stats.activeElections.firstWhere(
        (x) => x['id']?.toString() == widget.electionId || x['title']?.toString() == displayTitle,
        orElse: () => stats.activeElections.first,
      );
      displayEndsIn = match['ends_in']?.toString() ?? 'Ends in 4h 20m';
    }

    final double pctVal = (stats.participationRate / 100.0).clamp(0.0, 1.0);

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
        title: Text('Detail Pemilihan (Admin)',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(adminDashboardProvider.notifier).fetchRealDashboardData();
              _fetchCandidates();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
            child: ElectionSummaryWhiteCard(
              title: displayTitle,
              participationPercentage: pctVal,
              votersCountText:
                  '${numberFormat.format(stats.totalVotes)} dari ${numberFormat.format(stats.totalDpt > 0 ? stats.totalDpt : 100)}\npemilih terdaftar',
              countdownText: displayEndsIn,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tab Bar (persis seperti versi user namun untuk admin)
          Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.goldDark,
              indicatorWeight: 3,
              labelColor: AppColors.primary800,
              labelStyle: AppTypography.itemTitle,
              unselectedLabelColor: AppColors.textSecondary,
              unselectedLabelStyle: AppTypography.bodyMedium,
              tabs: const [
                Tab(text: 'Daftar\nKandidat'),
                Tab(text: 'Monitoring\nReal-Count & Chart'),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.outlineVariant),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCandidatesTab(context, stats, numberFormat),
                _buildRealCountMonitorTab(context, stats, numberFormat, displayTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: Daftar Kandidat & Manajemen Real-Count
  Widget _buildCandidatesTab(
    BuildContext context,
    AdminDashboardStats stats,
    NumberFormat numberFormat,
  ) {
    if (_isLoadingCandidates) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary800));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kandidat Terdaftar',
                  style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary900, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('Admin Mode: Verified Node',
                    style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Data perolehan suara sementara dihitung secara real-time dari setiap node TPS terdaftar.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          if (_candidates.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8, bottom: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.people_outline, size: 40, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Text('Belum Ada Kandidat Terdaftar',
                      style: AppTypography.cardTitle.copyWith(color: AppColors.primary900)),
                  const SizedBox(height: 8),
                  Text(
                    'Kandidat untuk pemilihan ini belum ditambahkan atau masih menunggu verifikasi database.',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._candidates.asMap().entries.map((entry) {
              final idx = entry.key;
              final cand = entry.value;
              final rank = cand['candidate_number'] ?? (idx + 1);
              final name = cand['full_name']?.toString() ?? 'Kandidat #$rank';
              final votesNum = cand['vote_count'] as num? ?? 0;
              final votesText = '${numberFormat.format(votesNum)} Suara';
              
              double progress = 0.0;
              if (stats.totalVotes > 0 && votesNum > 0) {
                progress = (votesNum / stats.totalVotes).toDouble().clamp(0.0, 1.0);
              } else if (cand['percentage'] != null) {
                final pctStr = cand['percentage'].toString().replaceAll('%', '');
                progress = (double.tryParse(pctStr) ?? 0.0) / 100.0;
              }

              final String pctString = cand['percentage']?.toString() ?? '${(progress * 100).toStringAsFixed(1)}%';
              final photoUrl = cand['photo_url']?.toString() ?? 'https://i.pravatar.cc/150?img=${rank + 10}';
              final isWin = cand['is_winning'] == true || (idx == 0 && progress >= 0.4);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _buildCandidateResultCard(
                  rank: rank is int ? rank : (idx + 1),
                  name: name,
                  percentage: pctString,
                  votes: votesText,
                  progressValue: progress,
                  imageUrl: photoUrl,
                  isWinning: isWin,
                ),
              );
            }),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // Tab 2: Monitoring Real-Count & Chart
  Widget _buildRealCountMonitorTab(
    BuildContext context,
    AdminDashboardStats stats,
    NumberFormat numberFormat,
    String displayTitle,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          _buildStatCard(
            title: 'TOTAL SUARA MASUK',
            value: numberFormat.format(stats.totalVotes),
            badge: 'LIVE',
            hasProgressBar: true,
            progressValue: stats.totalDpt > 0
                ? (stats.totalVotes / stats.totalDpt).clamp(0.0, 1.0)
                : 0.0,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'PARTISIPASI',
            value: '${stats.participationRate}%',
            subtitle: 'Dari Total User: ${numberFormat.format(stats.totalDpt)}',
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'DELEGASI AKTIF',
            value: '${numberFormat.format(stats.activeDelegates)} Node',
            subtitle: 'Verifikasi Blockchain',
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'UPDATE TERAKHIR',
            value: DateFormat('HH:mm:ss').format(DateTime.now()),
            subtitle: 'WIB, Jakarta',
            topRightIcon: Icons.access_time,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Chart Section (moved specifically inside Election Detail as requested)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
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
                        Text('Tren Partisipasi per Jam',
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary900,
                                fontWeight: FontWeight.bold)),
                        Text('Live Data Progression',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.successTeal
                                .withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  color: AppColors.successTeal,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text('LIVE',
                              style: AppTypography.captionBold.copyWith(
                                  color: AppColors.successTeal, fontSize: 9)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 150,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.goldMid.withValues(alpha: 0.35),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(double.infinity, 150),
                        painter: _LiveChartPainter(
                          hourlyRates: stats.hourlyRates,
                          currentRate: stats.participationRate,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('08:00',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.outline, fontSize: 10)),
                            Text('10:00',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.outline, fontSize: 10)),
                            Text('12:00',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.outline, fontSize: 10)),
                            Text('14:00',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.outline, fontSize: 10)),
                            Text('16:00',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.outline, fontSize: 10)),
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

          // Log Aktivitas Data
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Log Aktivitas Data Node',
                    style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.bold)),
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
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
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
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
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
              Text(title,
                  style: AppTypography.captionBold.copyWith(
                      color: AppColors.textSecondary, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value,
                      style: AppTypography.displayHeading
                          .copyWith(fontSize: 24, color: AppColors.primary900)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(badge,
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.successTeal)),
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
              if (hasProgressBar) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor:
                        AppColors.outlineVariant.withValues(alpha: 0.5),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary900),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
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
          decoration:
              BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.captionBold
                      .copyWith(color: AppColors.primary900)),
              Text(subtitle,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ),
        Text(time,
            style: AppTypography.captionBold
                .copyWith(color: AppColors.textSecondary, fontSize: 8)),
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
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
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
                child: Text('UNGGUL',
                    style: AppTypography.captionBold
                        .copyWith(color: Colors.white, fontSize: 9)),
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
                      child: Image.network(imageUrl,
                          width: 48, height: 48, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                    color: AppColors.primary800,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'K',
                                    style: AppTypography.cardTitle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KANDIDAT 0$rank',
                              style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  letterSpacing: 1.0)),
                          const SizedBox(height: 4),
                          Text(name,
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary900,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2)),
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
                    Text(percentage,
                        style: AppTypography.displayHeading.copyWith(
                            fontSize: 24, color: AppColors.primary900)),
                    Text(votes,
                        style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progressValue.clamp(0.0, 1.0),
                    backgroundColor:
                        AppColors.outlineVariant.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        isWinning ? AppColors.goldMid : AppColors.goldDark),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.outlineVariant
                                  .withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('TERVERIFIKASI ',
                                style: AppTypography.captionBold.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 8)),
                            const Icon(Icons.check_circle,
                                color: AppColors.successTeal, size: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.outlineVariant
                                  .withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('REAL-COUNT AUDIT',
                              style: AppTypography.captionBold.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 8)),
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

class _LiveChartPainter extends CustomPainter {
  _LiveChartPainter({required this.hourlyRates, required this.currentRate});
  final List<double> hourlyRates;
  final double currentRate;

  @override
  void paint(Canvas canvas, Size size) {
    if (hourlyRates.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.goldDark
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final int n = hourlyRates.length;
    final List<Offset> points = [];
    for (int i = 0; i < n; i++) {
      final double x = (i / (n - 1).clamp(1, n)) * (size.width - 20) + 10;
      final double rate = hourlyRates[i].clamp(0.0, 100.0);
      final double y =
          (size.height - 25) - (rate / 100.0) * (size.height - 65);
      points.add(Offset(x, y));
    }

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) * 0.5, p0.dy);
        final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) * 0.5, p1.dy);
        path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
            controlPoint2.dy, p1.dx, p1.dy);
      }
      canvas.drawPath(path, paint);
    }

    if (points.isNotEmpty) {
      final dotOffset = points.last;
      final dotOuterPaint = Paint()..color = AppColors.primary900;
      canvas.drawCircle(dotOffset, 6, dotOuterPaint);
      final dotInnerPaint = Paint()..color = AppColors.goldMid;
      canvas.drawCircle(dotOffset, 3, dotInnerPaint);

      final String labelText = '$currentRate%';
      final textSpan = TextSpan(
        text: labelText,
        style: AppTypography.captionBold
            .copyWith(color: Colors.white, fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      )..layout();

      final double badgeWidth = textPainter.width + 16;
      final double badgeHeight = textPainter.height + 8;
      double badgeX = dotOffset.dx - (badgeWidth / 2);
      badgeX = badgeX.clamp(4.0, size.width - badgeWidth - 4.0);
      final double badgeY =
          (dotOffset.dy - badgeHeight - 8).clamp(4.0, size.height);

      final badgeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(badgeX, badgeY, badgeWidth, badgeHeight),
        const Radius.circular(6),
      );
      final badgePaint = Paint()..color = AppColors.primary900;
      canvas.drawRRect(badgeRect, badgePaint);

      textPainter.paint(
        canvas,
        Offset(badgeX + 8, badgeY + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LiveChartPainter oldDelegate) =>
      oldDelegate.currentRate != currentRate ||
      oldDelegate.hourlyRates != hourlyRates;
}
