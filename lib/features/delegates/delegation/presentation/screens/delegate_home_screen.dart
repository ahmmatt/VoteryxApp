// lib/features/delegates/delegation/presentation/screens/delegate_home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/profile_provider.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_dashboard_provider.dart';

class DelegateHomeScreen extends ConsumerWidget {
  const DelegateHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final dashboardAsync = ref.watch(delegateDashboardProvider);
    final data = dashboardAsync.valueOrNull ?? const DelegateDashboardData();

    final fullName = profile?.fullName ?? 'Delegate';
    final avatarUrl = profile?.avatarUrl;
    final trustScore = data.trustScore;
    final totalVotesHeld = data.totalVotesHeld;
    final activeElections = data.activeElectionsCount;
    final activeMandates = data.mandates.where((m) => m.status == 'active').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Builder(builder: (context) {
              ImageProvider? avatarProvider;
              if (avatarUrl != null && avatarUrl.isNotEmpty) {
                if (avatarUrl.startsWith('data:image')) {
                  try {
                    final base64Str = avatarUrl.split(',').last;
                    avatarProvider = MemoryImage(base64Decode(base64Str));
                  } catch (_) {}
                } else if (avatarUrl.startsWith('http')) {
                  avatarProvider = NetworkImage(avatarUrl);
                }
              }
              return CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.goldMid,
                backgroundImage: avatarProvider,
                child: avatarProvider == null
                    ? const Icon(Icons.person, color: AppColors.primary900, size: 18)
                    : null,
              );
            }),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HALO,',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.outlineVariant,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  fullName,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  Text(
                    'DELEGATE',
                    style: AppTypography.captionBold.copyWith(
                      color: AppColors.primary900,
                      fontSize: 10,
                    ),
                  ),
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
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(delegateDashboardProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Stats Card ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFDF9F0), Color(0xFFF3E7CA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCol('$totalVotesHeld', 'SUARA DIPEGANG', valueColor: AppColors.goldDark),
                      // Circular Trust Score
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: trustScore > 0 ? (trustScore / 100).clamp(0.0, 1.0) : 0.0,
                              strokeWidth: 4,
                              backgroundColor: AppColors.goldMid.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldDark),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                trustScore > 0 ? '${trustScore.round()}%' : '-',
                                style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _buildStatCol(
                        '$activeElections',
                        'PEMILIHAN AKTIF',
                        valueColor: AppColors.primary900,
                        hasIcon: activeElections > 0,
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'TRUST SCORE',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Warning Card jika ada pemilihan aktif yang belum dieksekusi ──
                if (activeElections > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Eksekusi Diperlukan!',
                              style: AppTypography.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.urgentElectionHoursLeft > 0
                              ? 'Batas waktu delegasi untuk "${data.urgentElectionTitle}" akan berakhir dalam ${data.urgentElectionHoursLeft} jam.'
                              : 'Ada pemilihan yang perlu dieksekusi: "${data.urgentElectionTitle}".',
                          style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => context.pushNamed('delegate-vote-execution'),
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
                ],

                // ── Live Mandat Card ────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E7CA).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MANDAT SAAT INI',
                            style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, letterSpacing: 1.0),
                          ),
                          if (activeElections > 0)
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

                      if (data.urgentElectionTitle != null) ...[
                        // Ada pemilihan aktif — tampilkan info
                        Text(
                          data.urgentElectionTitle!,
                          style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900),
                        ),
                        const SizedBox(height: 16),
                        // Konsensus = persen mandator aktif dari total delegasi yang masuk
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Konsensus', style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
                            Text(
                              activeMandates.isNotEmpty
                                  ? '${data.consensusPercent.round()}%'
                                  : '-',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary900),
                            ),
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
                            widthFactor: activeMandates.isNotEmpty
                                ? (data.consensusPercent / 100).clamp(0.01, 1.0)
                                : 0.01,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.goldDark,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Avatar mandator aktif + tombol lihat manifesto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Avatar stack mandator
                            if (activeMandates.isNotEmpty)
                              SizedBox(
                                width: activeMandates.length > 3 ? 100 : (activeMandates.length * 24.0 + 8),
                                height: 32,
                                child: Stack(
                                  children: [
                                    ...activeMandates.take(3).toList().asMap().entries.map((entry) {
                                      final idx = entry.key;
                                      final m = entry.value;
                                      final url = m.delegatorAvatarUrl;
                                      return Positioned(
                                        left: idx * 20.0,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                            color: AppColors.goldMid.withValues(alpha: 0.3),
                                            image: url != null && url.startsWith('http')
                                                ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                                                : null,
                                          ),
                                          child: url == null || !url.startsWith('http')
                                              ? const Icon(Icons.person, size: 16, color: AppColors.goldDark)
                                              : null,
                                        ),
                                      );
                                    }),
                                    if (activeMandates.length > 3)
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
                                          child: Center(
                                            child: Text(
                                              '+${activeMandates.length - 3}',
                                              style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 9),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            else
                              Text(
                                'Belum ada mandator',
                                style: AppTypography.caption.copyWith(color: AppColors.outline),
                              ),
                            // Tombol Lihat Manifesto — ke halaman eksekusi suara
                            InkWell(
                              onTap: () => context.pushNamed('delegate-vote-execution'),
                              child: Row(
                                children: [
                                  Text('Lihat Manifesto', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.open_in_new, color: AppColors.goldDark, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Tidak ada pemilihan aktif
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada pemilihan aktif saat ini.',
                          style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Aktivitas Terkini ───────────────────────────────
                Text(
                  'Aktivitas Terkini',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: _buildActivities(data.mandates),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bangun daftar aktivitas dari mandates nyata database.
  /// Jika tidak ada delegasi sama sekali → tampilkan pesan kosong.
  List<Widget> _buildActivities(List<DelegateMandateItem> mandates) {
    if (mandates.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inbox_outlined, color: AppColors.outline, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Belum ada aktivitas delegasi.\nBagikan profil delegasimu agar mahasiswa lain dapat mempercayakan suara mereka kepadamu.',
                  style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ];
    }

    final widgets = <Widget>[];
    final shown = mandates.take(5).toList();

    for (int i = 0; i < shown.length; i++) {
      final m = shown[i];
      IconData icon;
      Color iconBgColor;
      Color iconColor;
      String titleText;
      final String timeText = m.createdAt != null ? _formatTimeAgo(m.createdAt!) : '';

      switch (m.status) {
        case 'revoked':
          icon = Icons.person_remove_alt_1;
          iconBgColor = const Color(0xFFFFF5F5);
          iconColor = Colors.redAccent;
          titleText = '${m.delegatorName} mencabut delegasinya';
          break;
        case 'pending':
          icon = Icons.hourglass_top_rounded;
          iconBgColor = const Color(0xFFE6EFFF);
          iconColor = Colors.blueAccent;
          titleText = 'Mandat dari ${m.delegatorName} menunggu verifikasi';
          break;
        default: // active
          icon = Icons.person_add_alt_1;
          iconBgColor = const Color(0xFFFDF9F0);
          iconColor = AppColors.goldDark;
          titleText = '${m.delegatorName} mendelegasikan suara kepadamu';
      }

      widgets.add(_buildActivityItem(
        icon: icon,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        title: titleText,
        time: timeText,
        avatarUrl: m.delegatorAvatarUrl,
      ));

      if (i < shown.length - 1) {
        widgets.add(const Divider(height: 1, color: AppColors.outlineVariant));
      }
    }
    return widgets;
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari yang lalu';
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

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String time,
    String? avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatarUrl != null && avatarUrl.isNotEmpty)
            _buildAvatar(avatarUrl, radius: 18)
          else
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
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(time, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, {double radius = 18}) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.outlineVariant,
        child: Icon(Icons.person, color: AppColors.textSecondary, size: radius * 1.2),
      );
    }
    
    try {
      if (avatarUrl.startsWith('data:image')) {
        final base64Str = avatarUrl.split(',').last;
        final normalized = base64.normalize(base64Str.replaceAll(RegExp(r'\s+'), ''));
        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(base64Decode(normalized)),
        );
      } else {
        return CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(avatarUrl),
        );
      }
    } catch (_) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.outlineVariant,
        child: Icon(Icons.person, color: AppColors.textSecondary, size: radius * 1.2),
      );
    }
  }
}
