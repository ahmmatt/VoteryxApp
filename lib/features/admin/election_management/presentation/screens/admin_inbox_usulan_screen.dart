// lib/features/admin/election_management/presentation/screens/admin_inbox_usulan_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

// ── Data Model (local/mock) ───────────────────────────────────────────────────
enum _ProposalStatus { baru, disetujui, ditolak }

class _Proposal {
  const _Proposal({
    required this.id,
    required this.org,
    required this.orgInitial,
    required this.status,
    required this.statusLabel,
    required this.timeAgo,
    required this.title,
    required this.tujuan,
    required this.periode,
    required this.candidateCount,
    required this.filter,
    this.showFullCard = false,
  });

  final String id;
  final String org;
  final String orgInitial;
  final _ProposalStatus status;
  final String statusLabel;
  final String timeAgo;
  final String title;
  final String tujuan;
  final String periode;
  final int candidateCount;
  final String filter;
  final bool showFullCard;
}

// ── Screen ────────────────────────────────────────────────────────────────────
class AdminInboxUsulanScreen extends StatefulWidget {
  const AdminInboxUsulanScreen({super.key});

  @override
  State<AdminInboxUsulanScreen> createState() => _AdminInboxUsulanScreenState();
}

class _AdminInboxUsulanScreenState extends State<AdminInboxUsulanScreen> {
  int _selectedTab = 0; // 0: Baru, 1: Disetujui, 2: Ditolak

  static const _tabs = [
    ('Baru', 4),
    ('Disetujui', 12),
    ('Ditolak', 2),
  ];

  static const List<_Proposal> _allProposals = [
    _Proposal(
      id: '1',
      org: 'HIMA Teknik Informatika',
      orgInitial: 'H',
      status: _ProposalStatus.baru,
      statusLabel: 'MENUNGGU REVIEW',
      timeAgo: '2 jam yang lalu',
      title: 'Usulan: Pemilihan Ketua HIMA TI 2026',
      tujuan: 'Regenerasi kepemimpinan tahunan organisasi mahasiswa.',
      periode: '15 – 17 Juni 2026',
      candidateCount: 5,
      filter: 'baru',
      showFullCard: true,
    ),
    _Proposal(
      id: '2',
      org: 'BEM Fakultas Ekonomi',
      orgInitial: 'B',
      status: _ProposalStatus.baru,
      statusLabel: 'BARU MASUK',
      timeAgo: '5 jam yang lalu',
      title: 'Usulan: Pemilihan Ketua BEM FE 2026',
      tujuan: '-',
      periode: '-',
      candidateCount: 3,
      filter: 'baru',
      showFullCard: false,
    ),
    _Proposal(
      id: '3',
      org: 'BEM Universitas',
      orgInitial: 'U',
      status: _ProposalStatus.disetujui,
      statusLabel: 'DISETUJUI',
      timeAgo: '1 hari yang lalu',
      title: 'Usulan: Pemilihan Ketua BEM 2026',
      tujuan: 'Regenerasi kepemimpinan.',
      periode: '20 – 22 Juni 2026',
      candidateCount: 4,
      filter: 'disetujui',
      showFullCard: true,
    ),
    _Proposal(
      id: '4',
      org: 'DPM Fakultas Hukum',
      orgInitial: 'D',
      status: _ProposalStatus.ditolak,
      statusLabel: 'DITOLAK',
      timeAgo: '3 hari yang lalu',
      title: 'Usulan: Pemilihan Anggota DPM 2026',
      tujuan: 'Regenerasi anggota dewan perwakilan.',
      periode: '1 – 3 Juli 2026',
      candidateCount: 6,
      filter: 'ditolak',
      showFullCard: true,
    ),
  ];

  List<_Proposal> get _filteredProposals {
    const filterMap = ['baru', 'disetujui', 'ditolak'];
    return _allProposals
        .where((p) => p.filter == filterMap[_selectedTab])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabRow(),
          Expanded(
            child: _filteredProposals.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.xxl,
                    ),
                    itemCount: _filteredProposals.length + 1, // +1 for bottom note
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (ctx, i) {
                      if (i == _filteredProposals.length) {
                        return _buildBottomNote();
                      }
                      final p = _filteredProposals[i];
                      return p.showFullCard
                          ? _buildFullProposalCard(ctx, p)
                          : _buildCompactProposalCard(ctx, p);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary900,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text('Inbox Usulan', style: AppTypography.headerTitle),
    );
  }

  // ── Tab Row ───────────────────────────────────────────────────────────────
  Widget _buildTabRow() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final (label, count) = _tabs[i];
          final isSelected = i == _selectedTab;
          return Padding(
            padding: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary900 : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: isSelected
                      ? null
                      : Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.outlineVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: AppTypography.captionBold.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Full Proposal Card (with tujuan, periode, candidate avatars) ──────────
  Widget _buildFullProposalCard(BuildContext context, _Proposal p) {
    final statusColor = _statusColor(p.status);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left gold accent bar + content
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Gold left bar
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: AppColors.goldMid,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.card),
                      bottomLeft: Radius.circular(AppRadius.card),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrgAvatar(p.orgInitial),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.org,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primary900,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        p.statusLabel,
                                        style: AppTypography.captionBold
                                            .copyWith(
                                          color: statusColor,
                                          fontSize: 9,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              p.timeAgo,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.outline,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Title
                        Text(
                          p.title,
                          style: AppTypography.cardTitle.copyWith(
                            color: AppColors.primary900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Tujuan
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: 'TUJUAN',
                          value: p.tujuan,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Periode
                        _buildInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'PERIODE',
                          value: p.periode,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Candidate avatars row
                        _buildCandidateAvatarRow(p.candidateCount),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withOpacity(0.3),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Tolak button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.errorRed),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.cardInner),
                      ),
                    ),
                    icon: const Icon(Icons.close, color: AppColors.errorRed,
                        size: 18),
                    label: Text(
                      'Tolak Usulan',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Review & Setujui button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushNamed('admin-review-detail'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldMid,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.cardInner),
                      ),
                    ),
                    icon: const Icon(Icons.verified_outlined,
                        color: Colors.white, size: 18),
                    label: Text(
                      'Review & Setujui',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Compact Proposal Card (without detail, with Proses button) ────────────
  Widget _buildCompactProposalCard(BuildContext context, _Proposal p) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrgAvatar(p.orgInitial),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.org,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _statusColor(p.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          p.statusLabel,
                          style: AppTypography.captionBold.copyWith(
                            color: _statusColor(p.status),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                p.timeAgo,
                style: AppTypography.caption
                    .copyWith(color: AppColors.outline, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            p.title,
            style: AppTypography.cardTitle
                .copyWith(color: AppColors.primary900, fontSize: 15),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Avatars + count
          Row(
            children: [
              _buildCandidateAvatarRow(p.candidateCount),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.pushNamed('admin-review-detail'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  'Lihat Detail',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.pushNamed('admin-review-detail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.cardInner),
                  ),
                ),
                child: Text(
                  'Proses',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 56, color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tidak ada usulan',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Bottom Note ───────────────────────────────────────────────────────────
  Widget _buildBottomNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(Icons.history_outlined,
              size: 32, color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Menampilkan usulan terbaru minggu ini',
            style: AppTypography.caption.copyWith(color: AppColors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildOrgAvatar(String initial) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.goldMid,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.cardTitle.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.bodyText.copyWith(
                color: AppColors.primary900,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCandidateAvatarRow(int count) {
    const avatarColors = [
      Color(0xFF7986CB),
      Color(0xFF64B5F6),
      Color(0xFF81C784),
    ];
    final displayCount = count > 3 ? 3 : count;
    final extra = count > 3 ? count - 3 : 0;

    return Row(
      children: [
        SizedBox(
          width: displayCount * 22.0 + (extra > 0 ? 30 : 0),
          height: 28,
          child: Stack(
            children: [
              ...List.generate(displayCount, (i) {
                return Positioned(
                  left: i * 22.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: avatarColors[i % avatarColors.length],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                );
              }),
              if (extra > 0)
                Positioned(
                  left: displayCount * 22.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$extra',
                      style: AppTypography.captionBold.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$count kandidat diusulkan',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
      ],
    );
  }

  Color _statusColor(_ProposalStatus status) {
    switch (status) {
      case _ProposalStatus.baru:
        return AppColors.goldMid;
      case _ProposalStatus.disetujui:
        return AppColors.successTeal;
      case _ProposalStatus.ditolak:
        return AppColors.errorRed;
    }
  }
}
