// lib/features/delegation/presentation/screens/delegate_execution_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Model data untuk item riwayat eksekusi.
class _ExecutionItem {
  final String title;
  final String date;
  final int votes;
  final int? mandators;
  final String? accuracy;
  final String status;

  const _ExecutionItem({
    required this.title,
    required this.date,
    required this.votes,
    this.mandators,
    this.accuracy,
    required this.status,
  });
}

/// Layar Riwayat Eksekusi — menampilkan ringkasan statistik
/// dan daftar pemilihan yang pernah dieksekusi.
class DelegateExecutionHistoryScreen extends StatefulWidget {
  const DelegateExecutionHistoryScreen({super.key});

  @override
  State<DelegateExecutionHistoryScreen> createState() =>
      _DelegateExecutionHistoryScreenState();
}

class _DelegateExecutionHistoryScreenState
    extends State<DelegateExecutionHistoryScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Menunggu', 'Selesai'];

  static const List<_ExecutionItem> _items = [
    _ExecutionItem(
      title: 'Ketua BEM UI 2026',
      date: '07 Jun 2026',
      votes: 47,
      mandators: 12,
      accuracy: '96% tepat waktu',
      status: 'Menunggu',
    ),
    _ExecutionItem(
      title: 'HIMA Teknik 2025',
      date: '12 Des 2025',
      votes: 31,
      mandators: 8,
      status: 'Selesai',
    ),
    _ExecutionItem(
      title: 'Rektor 2024',
      date: '15 Nov 2024',
      votes: 18,
      status: 'Selesai',
    ),
  ];

  List<_ExecutionItem> get _filteredItems {
    if (_selectedFilter == 0) return _items; // Semua
    final keyword = _filters[_selectedFilter].toLowerCase();
    return _items.where((item) => 
      item.status.toLowerCase() == keyword
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCard(),
              const SizedBox(height: AppSpacing.xl),
              _buildFilterChips(),
              const SizedBox(height: AppSpacing.xl),
              if (_filteredItems.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Tidak ada riwayat untuk filter ini'),
                  ),
                )
              else
                ..._filteredItems.map(_buildExecutionCard),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.primary800,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Riwayat Eksekusi',
        style: AppTypography.headerTitle,
      ),
    );
  }

  // ──────────────────── Stats Summary Card ───────────────────────
  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF5E6),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldMid.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildStatItem('3', 'PEMILIHAN')),
            VerticalDivider(
              color: AppColors.goldDark.withOpacity(0.2),
              thickness: 1,
              width: 1,
            ),
            Expanded(child: _buildStatItem('96', 'TOTAL SUARA')),
            VerticalDivider(
              color: AppColors.goldDark.withOpacity(0.2),
              thickness: 1,
              width: 1,
            ),
            Expanded(child: _buildStatItem('100%', 'TEPAT WAKTU')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTypography.displayHeading.copyWith(
            fontSize: 26,
            color: AppColors.goldDark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.captionBold.copyWith(
            color: AppColors.goldDark,
            fontSize: 10,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  // ──────────────────── Filter Chips ────────────────────────────
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (i) {
          final isSelected = i == _selectedFilter;
          return Padding(
            padding: EdgeInsets.only(right: i < _filters.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary900 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary900
                        : AppColors.outlineVariant,
                  ),
                ),
                child: Text(
                  _filters[i],
                  style: AppTypography.bodyMedium.copyWith(
                    color:
                        isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────── Execution Card ──────────────────────────
  Widget _buildExecutionCard(_ExecutionItem item) {
    final bool isSelesai = item.status.toLowerCase() == 'selesai';
    final Color badgeColor = isSelesai ? const Color(0xFF10B981) : AppColors.goldDark;
    final Color badgeBgColor = badgeColor.withOpacity(0.15);

    return GestureDetector(
      onTap: () => context.pushNamed('delegate-dashboard'),
      child: Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(width: 4, color: badgeColor),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: icon + title/date + status badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon box
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.list_alt_rounded,
                            color: badgeColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title and date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTypography.displayHeading.copyWith(
                                  fontSize: 17,
                                  color: AppColors.primary900,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.date,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status,
                            style: AppTypography.captionBold.copyWith(
                              color: badgeColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Badges row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildBadge(
                          Icons.how_to_vote_rounded,
                          '${item.votes} suara',
                          bgColor: AppColors.goldDark,
                          textColor: Colors.white,
                        ),
                        if (item.mandators != null)
                          _buildBadge(
                            Icons.people,
                            '${item.mandators} mandator',
                            bgColor: AppColors.primary900,
                            textColor: Colors.white,
                          ),
                        if (item.accuracy != null)
                          _buildBadge(
                            Icons.timer_outlined,
                            item.accuracy!,
                            bgColor: badgeBgColor,
                            textColor: badgeColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildBadge(
    IconData icon,
    String text, {
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.captionBold.copyWith(
              color: textColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
