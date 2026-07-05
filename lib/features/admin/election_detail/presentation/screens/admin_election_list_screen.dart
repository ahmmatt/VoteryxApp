// lib/features/admin/election_detail/presentation/screens/admin_election_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class AdminElectionListScreen extends StatefulWidget {
  const AdminElectionListScreen({super.key});

  @override
  State<AdminElectionListScreen> createState() =>
      _AdminElectionListScreenState();
}

class _AdminElectionListScreenState extends State<AdminElectionListScreen> {
  int _selectedTab = 2;

  static const List<_ElectionTab> _tabs = [
    _ElectionTab(label: 'Live', count: 1),
    _ElectionTab(label: 'Terjadwal', count: 2),
    _ElectionTab(label: 'Draft', count: 3),
  ];

  static const List<_DraftElection> _drafts = [
    _DraftElection(
      title: 'Pemilihan Ketua Dewan\nDaerah 2024',
      description:
          'Proses pemilihan untuk menentukan pemimpin legislatif tingkat regional periode mendatang.',
      badge: 'Kandidat Kosong',
      icon: Icons.article_outlined,
      progress: .60,
      status: _DraftStatus.danger,
    ),
    _DraftElection(
      title: 'Referendum\nPembangunan\nInfrastruktur',
      description:
          'Pemungutan suara publik terkait alokasi anggaran proyek strategis nasional wilayah...',
      badge: 'Jadwal Belum Set',
      icon: Icons.campaign_outlined,
      progress: .45,
      status: _DraftStatus.danger,
    ),
    _DraftElection(
      title: 'Pemilihan Senat\nUniversitas Jaya',
      description:
          'Restrukturisasi kepemimpinan akademik untuk periode tahun ajaran 2024/2025.',
      badge: 'Review Akhir',
      icon: Icons.groups_2_outlined,
      progress: .92,
      status: _DraftStatus.neutral,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FB),
      appBar: _AdminElectionAppBar(onBack: () => context.pop()),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderTabs(
                selectedIndex: _selectedTab,
                tabs: _tabs,
                onChanged: (index) => setState(() => _selectedTab = index),
              ),
              Expanded(
                child: _selectedTab == 2
                    ? _DraftElectionList(drafts: _drafts)
                    : _EmptyTabState(tabLabel: _tabs[_selectedTab].label),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _AdminBottomNavigation(),
          ),
        ],
      ),
    );
  }
}

class _AdminElectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _AdminElectionAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: AppColors.primary800,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
      titleSpacing: 0,
      title: Text(
        'Daftar Pemilihan',
        style: AppTypography.headerTitle.copyWith(fontSize: 17),
      ),
    );
  }
}

class _HeaderTabs extends StatelessWidget {
  const _HeaderTabs({
    required this.selectedIndex,
    required this.tabs,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<_ElectionTab> tabs;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFFCFAFD), Color(0x00FCFAFD)],
          stops: [0, .74, 1],
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MANA DAFTAR KONTESTASI',
                style: AppTypography.captionBold.copyWith(
                  color: const Color(0xFF5D6170),
                  fontSize: 9,
                  letterSpacing: .9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manajemen Pemilihan',
                style: AppTypography.displayHeading.copyWith(
                  color: AppColors.primary900,
                  fontSize: 22,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: index == tabs.length - 1 ? 0 : 10),
                      child: _SegmentTab(
                        tab: tabs[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onChanged(index),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab(
      {required this.tab, required this.isSelected, required this.onTap});

  final _ElectionTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary800 : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: isSelected
                    ? AppColors.primary800
                    : const Color(0xFFE7E8EE)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: AppColors.primary900.withOpacity(.14),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  tab.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.captionBold.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFF676B77),
                    fontSize: 10,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withOpacity(.14)
                      : const Color(0xFFF0F1F5),
                ),
                child: Text(
                  '${tab.count}',
                  style: AppTypography.captionBold.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFF7D818B),
                    fontSize: 8,
                    letterSpacing: 0,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftElectionList extends StatelessWidget {
  const _DraftElectionList({required this.drafts});

  final List<_DraftElection> drafts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: drafts.length + _summaryItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        if (index < drafts.length) {
          return _DraftElectionCard(election: drafts[index]);
        }
        return _SummaryMetricCard(item: _summaryItems[index - drafts.length]);
      },
    );
  }
}

class _DraftElectionCard extends StatelessWidget {
  const _DraftElectionCard({required this.election});

  final _DraftElection election;

  @override
  Widget build(BuildContext context) {
    final isDanger = election.status == _DraftStatus.danger;
    final badgeColor = isDanger ? AppColors.errorRed : const Color(0xFF6F7380);
    final badgeBg =
        isDanger ? AppColors.errorBg.withOpacity(.65) : const Color(0xFFF0F1F5);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary900.withOpacity(.035),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardIcon(icon: election.icon),
              const Spacer(),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _StatusBadge(
                    label: election.badge,
                    color: badgeColor,
                    backgroundColor: badgeBg,
                    showAlertIcon: isDanger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            election.title,
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.primary900,
              fontSize: 21,
              height: 1.12,
              letterSpacing: -.15,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            election.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
                color: const Color(0xFF535762), fontSize: 11, height: 1.45),
          ),
          const SizedBox(height: 18),
          _ProgressLabel(value: election.progress),
          const SizedBox(height: 6),
          _GoldProgressBar(value: election.progress),
          const SizedBox(height: 18),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: () => context.pushNamed('admin-election-draft'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary900,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lanjutkan Setup',
                    style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 7),
                  const Icon(Icons.arrow_forward, size: 13),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xFFF4F5F8),
          borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, size: 18, color: AppColors.primary900.withOpacity(.82)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(
      {required this.label,
      required this.color,
      required this.backgroundColor,
      this.showAlertIcon = false});

  final String label;
  final Color color;
  final Color backgroundColor;
  final bool showAlertIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAlertIcon) ...[
            Icon(Icons.info_outline, color: color, size: 10),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.captionBold.copyWith(
                  color: color, fontSize: 9, letterSpacing: 0, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  const _ProgressLabel({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Kelengkapan Data',
            style: AppTypography.captionBold.copyWith(
                color: const Color(0xFF565B66), fontSize: 9, letterSpacing: 0)),
        Text('$percentage%',
            style: AppTypography.captionBold.copyWith(
                color: AppColors.primary900, fontSize: 9, letterSpacing: 0)),
      ],
    );
  }
}

class _GoldProgressBar extends StatelessWidget {
  const _GoldProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 5,
        value: value,
        backgroundColor: const Color(0xFFE8E8EC),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldMid),
      ),
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({required this.item});
  final _SummaryMetric item;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary900.withOpacity(.025),
              blurRadius: 14,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: item.backgroundColor, shape: BoxShape.circle),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style: AppTypography.caption.copyWith(
                        color: const Color(0xFF777B86),
                        fontSize: 10,
                        height: 1.15)),
                const SizedBox(height: 2),
                Text(item.value,
                    style: AppTypography.displayHeading.copyWith(
                        color: item.valueColor, fontSize: 22, height: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBottomNavigation extends StatelessWidget {
  const _AdminBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: const Color(0xFFE7E8EE).withOpacity(.85))),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary900.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, -6))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
          child: Row(
            children: [
              Expanded(
                  child: _BottomNavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Overview',
                      onTap: () => context.pushNamed('admin-dashboard'))),
              const Expanded(
                  child: _BottomNavItem(
                      icon: Icons.how_to_vote_rounded,
                      label: 'Elections',
                      isSelected: true)),
              Expanded(
                  child: _BottomNavItem(
                      icon: Icons.groups_2_outlined,
                      label: 'Voters',
                      onTap: () => context.pushNamed('admin-voters'))),
              Expanded(
                  child: _BottomNavItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () => context.pushNamed('admin-settings'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem(
      {required this.icon,
      required this.label,
      this.isSelected = false,
      this.onTap});

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? Colors.white : const Color(0xFF5F636D);
    final labelColor =
        isSelected ? AppColors.goldDark : const Color(0xFF5F636D);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isSelected ? AppColors.goldMid : Colors.transparent,
                    borderRadius: BorderRadius.circular(11)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.captionBold.copyWith(
                    color: labelColor,
                    fontSize: 9,
                    letterSpacing: 0,
                    height: 1.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTabState extends StatelessWidget {
  const _EmptyTabState({required this.tabLabel});
  final String tabLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card)),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFFF4F5F8), shape: BoxShape.circle),
                child: const Icon(Icons.folder_open_outlined,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Daftar $tabLabel',
                  style: AppTypography.cardTitle
                      .copyWith(color: AppColors.primary900)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Konten tab ini mengikuti desain komponen yang sama dan siap diisi dengan data backend.',
                textAlign: TextAlign.center,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ElectionTab {
  const _ElectionTab({required this.label, required this.count});
  final String label;
  final int count;
}

enum _DraftStatus { danger, neutral }

class _DraftElection {
  const _DraftElection({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.progress,
    required this.status,
  });

  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final double progress;
  final _DraftStatus status;
}

class _SummaryMetric {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color backgroundColor;
  final Color valueColor;
}

const List<_SummaryMetric> _summaryItems = [
  _SummaryMetric(
    icon: Icons.play_circle_outline_rounded,
    label: 'Draft Aktif',
    value: '12',
    iconColor: AppColors.primary900,
    backgroundColor: Color(0xFFF0F1F5),
    valueColor: AppColors.primary900,
  ),
  _SummaryMetric(
    icon: Icons.warning_amber_rounded,
    label: 'Butuh Perhatian',
    value: '4',
    iconColor: AppColors.errorRed,
    backgroundColor: Color(0xFFFFECE9),
    valueColor: AppColors.errorRed,
  ),
  _SummaryMetric(
    icon: Icons.check_circle_outline_rounded,
    label: 'Siap Rilis',
    value: '3',
    iconColor: Color(0xFF767A84),
    backgroundColor: Color(0xFFF0F1F5),
    valueColor: AppColors.primary900,
  ),
  _SummaryMetric(
    icon: Icons.group_add_outlined,
    label: 'Voter Terdaftar',
    value: '42.1k',
    iconColor: Color(0xFF767A84),
    backgroundColor: Color(0xFFF0F1F5),
    valueColor: AppColors.primary900,
  ),
];
