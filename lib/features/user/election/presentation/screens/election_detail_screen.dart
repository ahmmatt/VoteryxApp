import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../widgets/election_summary_white_card.dart';

class ElectionDetailScreen extends StatefulWidget {
  const ElectionDetailScreen({super.key});

  @override
  State<ElectionDetailScreen> createState() => _ElectionDetailScreenState();
}

class _ElectionDetailScreenState extends State<ElectionDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Elections', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
              child: ElectionSummaryWhiteCard(
                title: 'Pemilihan Ketua BEM 2026',
                participationPercentage: 0.62,
                votersCountText: '12,402 dari 20,000\nmahasiswa',
                countdownText: '02 : 14 : 45 : 12',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tab Bar
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
                  Tab(text: 'Delegasikan\nSuara'),
                ],
              ),
            ),

            // Divider
            const Divider(
                height: 1, thickness: 1, color: AppColors.outlineVariant),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _CandidateListTab(),
                  _DelegatorListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class _CandidateEstimateRow extends StatelessWidget {
  const _CandidateEstimateRow({
    required this.name,
    required this.votes,
    required this.percent,
    required this.color,
  });

  final String name;
  final String votes;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '$votes suara',
              style: AppTypography.captionBold.copyWith(
                color: Colors.white,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ── Tab 1: Daftar Kandidat ───────────────────────────────────────────────────

class _CandidateListTab extends StatelessWidget {
  const _CandidateListTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      children: [
        _CandidateCard(
          number: '01',
          name: 'Aris Setiawan',
          tagline: '"Digitalisasi Kampus untuk Masa Depan Inklusif"',
          isSelected: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _CandidateCard(
          number: '02',
          name: 'Farah Quinn',
          tagline: '"Kesejahteraan Mahasiswa Adalah Prioritas Utama"',
          isSelected: false,
        ),
        const SizedBox(height: AppSpacing.md),
        _CandidateCard(
          number: '03',
          name: 'Budi Tabuti',
          tagline: '"Kolaborasi Riset Antar Fakultas Tanpa Batas"',
          isSelected: false,
        ),
        const SizedBox(height: AppSpacing.md),
        _CandidateCard(
          number: '04',
          name: 'Siti Aminah',
          tagline: '"Satu Visi, Satu Aksi, Untuk BEM yang Berdikari"',
          isSelected: false,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Bottom Assistance
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Butuh bantuan tentang pemilihan?',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Baca Panduan Pemilihan',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary800,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldMid.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.outbox_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.number,
    required this.name,
    required this.tagline,
    required this.isSelected,
  });

  final String number;
  final String name;
  final String tagline;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.pushNamed('election-candidate',
              pathParameters: {'id': '1', 'candidateId': number});
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.goldMid : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080F1F3D),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with Badges
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.goldMid
                              : AppColors.outlineVariant,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        // Gunakan icon placeholder untuk web (hindari CORS)
                        child: Container(
                          color: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: isSelected
                                ? AppColors.primary800
                                : AppColors.outline,
                          ),
                        ),
                      ),
                    ),
                    // Number Badge
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.goldDark
                              : AppColors.outline,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            number,
                            style: AppTypography.captionBold.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Checkmark Badge (if selected)
                    if (isSelected)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.goldDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.cardTitle.copyWith(
                        color: AppColors.primary800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tagline,
                      style: AppTypography.caption.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Lihat Profil',
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.goldDark
                                : AppColors.outline,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: isSelected
                              ? AppColors.goldDark
                              : AppColors.outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

// ── Tab 2: Delegasikan Suara ─────────────────────────────────────────────────

class _DelegatorListTab extends StatelessWidget {
  const _DelegatorListTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePad),
          child: AppTextField(
            label: '',
            hint: 'Cari nama delegator',
            prefixIcon: Icons.search,
          ),
        ),

        // List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
            physics: const ClampingScrollPhysics(),
            children: [
              _DelegatorCard(
                name: 'Arkananta Putra',
                badges: const [
                  _DelegatorBadge(
                      label: 'MANTAN KETUA BEM', type: _BadgeType.gray),
                  _DelegatorBadge(
                      label: 'FAKULTAS TEKNIK', type: _BadgeType.green),
                ],
                voteCount: 428,
              ),
              const SizedBox(height: AppSpacing.md),
              _DelegatorCard(
                name: 'Sarah Wijaya',
                badges: const [
                  _DelegatorBadge(
                      label: 'AKTIVIS MAHASISWA', type: _BadgeType.gray),
                  _DelegatorBadge(
                      label: 'FAKULTAS HUKUM', type: _BadgeType.gold),
                ],
                voteCount: 152,
              ),
              const SizedBox(height: AppSpacing.md),
              _DelegatorCard(
                name: 'Dimas Ramadhan',
                badges: const [
                  _DelegatorBadge(
                      label: 'KETUA HIMPUNAN', type: _BadgeType.gray),
                  _DelegatorBadge(
                      label: 'EKONOMI & BISNIS', type: _BadgeType.green),
                ],
                voteCount: 89,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Info Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary800.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primary800, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Delegasi bersifat cair. Anda dapat menarik suara kapan saja.',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ],
    );
  }
}

class _DelegatorCard extends StatelessWidget {
  const _DelegatorCard({
    required this.name,
    required this.badges,
    required this.voteCount,
  });

  final String name;
  final List<Widget> badges;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F1F3D),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Avatar & Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(Icons.person,
                    color: AppColors.outline, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.cardTitle.copyWith(
                        color: AppColors.primary800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: badges,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Bottom Row: Stats & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BEBAN SUARA SAAT INI',
                    style: AppTypography.captionBold.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        voteCount.toString(),
                        style: AppTypography.itemTitle.copyWith(
                          fontSize: 16,
                          color: AppColors.primary800,
                        ),
                      ),
                      Text(
                        ' Suara',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Button Delegasikan
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Delegasikan',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _BadgeType { gray, green, gold }

class _DelegatorBadge extends StatelessWidget {
  const _DelegatorBadge({required this.label, required this.type});

  final String label;
  final _BadgeType type;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case _BadgeType.green:
        bgColor = const Color(0x3334C759); // Light green
        textColor = const Color(0xFF0F6E56); // Dark green
        break;
      case _BadgeType.gold:
        bgColor = const Color(0x33D4A030);
        textColor = AppColors.goldDark;
        break;
      case _BadgeType.gray:
        bgColor = AppColors.outlineVariant.withValues(alpha: 0.3);
        textColor = AppColors.primary800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.captionBold.copyWith(
          color: textColor,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
