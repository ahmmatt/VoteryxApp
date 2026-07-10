// lib/features/admin/election_management/presentation/screens/admin_inbox_usulan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../providers/admin_proposal_provider.dart';
import 'package:voteryxapp/features/user/election_proposal/domain/entities/election_proposal.dart';

class AdminInboxUsulanScreen extends ConsumerWidget {
  const AdminInboxUsulanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(adminProposalFilterProvider);
    final proposalsAsync = ref.watch(adminAllProposalsProvider);

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
        title: Text('Inbox Usulan Pemilihan',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(adminAllProposalsProvider),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Segarkan',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: Column(
          children: [
            // Filter Tabs
            _buildFilterTabs(ref, filter),

            // Proposals List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(adminAllProposalsProvider),
                color: AppColors.goldMid,
                child: proposalsAsync.when(
                  data: (proposals) {
                    if (proposals.isEmpty) return _buildEmpty(filter);
                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: proposals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (ctx, i) =>
                          _ProposalCard(item: proposals[i]),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.goldMid),
                  ),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.errorRed),
                          const SizedBox(height: 12),
                          Text('Gagal memuat usulan',
                              style: AppTypography.cardTitle),
                          const SizedBox(height: 8),
                          Text(e.toString(),
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                ref.invalidate(adminAllProposalsProvider),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary800),
                            child: const Text('Coba Lagi',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(WidgetRef ref, String currentFilter) {
    final tabs = [
      ('Semua', 'all'),
      ('Menunggu', 'pending'),
      ('Disetujui', 'approved'),
      ('Ditolak', 'rejected'),
    ];

    return Container(
      color: AppColors.primary800,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: tabs.map((t) {
            final isSelected = currentFilter == t.$2;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => ref
                    .read(adminProposalFilterProvider.notifier)
                    .state = t.$2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.goldMid
                        : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.$1,
                    style: AppTypography.captionBold.copyWith(
                      color: isSelected
                          ? AppColors.primary900
                          : Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmpty(String filter) {
    final label = filter == 'all'
        ? 'Belum ada usulan pemilihan masuk.'
        : 'Tidak ada usulan dengan status ini.';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 56, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(label,
              style: AppTypography.bodyText
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ── Proposal Card ─────────────────────────────────────────────────────────────

class _ProposalCard extends ConsumerWidget {
  const _ProposalCard({required this.item});

  final AdminProposalItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = item.proposal;
    final statusConfig = _statusConfig(p.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Org avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary800.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          p.organization?.isNotEmpty == true
                              ? p.organization![0].toUpperCase()
                              : 'P',
                          style: AppTypography.captionBold.copyWith(
                              color: AppColors.primary800, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.organization ?? 'Organisasi tidak diketahui',
                              style: AppTypography.captionBold
                                  .copyWith(color: AppColors.textPrimary)),
                          Text('Diajukan oleh: ${item.proposerName}',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusConfig['bg'] as Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: statusConfig['border'] as Color),
                      ),
                      child: Text(
                        statusConfig['label'] as String,
                        style: AppTypography.captionBold.copyWith(
                          color: statusConfig['text'] as Color,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(p.title,
                    style: AppTypography.cardTitle
                        .copyWith(color: AppColors.primary900, fontSize: 16)),
                if (p.purpose?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    p.purpose!,
                    style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatPeriode(p.proposedStartDate, p.proposedEndDate),
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      p.createdAt != null
                          ? _formatAgo(p.createdAt!)
                          : '-',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Kandidat List
          if (item.candidates.isNotEmpty) ...[
            Divider(height: 1, color: AppColors.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                          '${item.candidates.length} Kandidat Diajukan',
                          style: AppTypography.captionBold
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...item.candidates.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  AppColors.primary800.withOpacity(0.1),
                              child: Text(
                                c.fullName.isNotEmpty
                                    ? c.fullName[0].toUpperCase()
                                    : '?',
                                style: AppTypography.captionBold.copyWith(
                                    color: AppColors.primary800,
                                    fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                c.fullName,
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textPrimary),
                              ),
                            ),
                            if (c.nikOrNim != null)
                              Text(
                                'NIM: ${c.nikOrNim}',
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],

          // Action Buttons (hanya untuk pending)
          if (p.isPending || p.isUnderReview) ...[
            Divider(height: 1, color: AppColors.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showActionDialog(context, ref, p.id, p.title, false),
                      icon: const Icon(Icons.close,
                          size: 16, color: AppColors.errorRed),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: const BorderSide(color: AppColors.errorRed),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.button)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showActionDialog(context, ref, p.id, p.title, true),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Setujui'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.button)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context, WidgetRef ref,
      String proposalId, String title, bool isApprove) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Row(
          children: [
            Icon(
              isApprove ? Icons.check_circle : Icons.cancel,
              color: isApprove ? AppColors.successTeal : AppColors.errorRed,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              isApprove ? 'Setujui Usulan' : 'Tolak Usulan',
              style: AppTypography.cardTitle,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"$title"',
                style: AppTypography.bodyText
                    .copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text('Catatan untuk pengusul (opsional):',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: isApprove
                    ? 'Mis: Silakan lanjutkan ke tahap persiapan...'
                    : 'Mis: Kekurangan dokumen persyaratan...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.outlineVariant)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primary800)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              ctx.pop();
              await ref.read(adminProposalActionProvider.notifier).updateStatus(
                proposalId,
                isApprove ? 'approved' : 'rejected',
                adminNote: noteController.text.trim().isEmpty
                    ? null
                    : noteController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isApprove ? AppColors.successTeal : AppColors.errorRed,
            ),
            child: Text(isApprove ? 'Setujui' : 'Tolak',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _statusConfig(String status) {
    switch (status) {
      case 'approved':
        return {
          'label': 'DISETUJUI',
          'bg': const Color(0xFFE8F6F2),
          'border': const Color(0xFFB5E3D8),
          'text': AppColors.successTeal,
        };
      case 'rejected':
        return {
          'label': 'DITOLAK',
          'bg': const Color(0xFFFFF0F0),
          'border': const Color(0xFFFFCCCC),
          'text': AppColors.errorRed,
        };
      case 'under_review':
        return {
          'label': 'DALAM REVIEW',
          'bg': const Color(0xFFF0F4FF),
          'border': const Color(0xFFB8CAFF),
          'text': AppColors.primary800,
        };
      default: // pending
        return {
          'label': 'MENUNGGU',
          'bg': const Color(0xFFFFFDF5),
          'border': const Color(0xFFF0D695),
          'text': AppColors.warningAmber,
        };
    }
  }

  String _formatPeriode(DateTime? start, DateTime? end) {
    if (start == null && end == null) return 'Periode belum ditentukan';
    final fmt = DateFormat('d MMM yyyy', 'id');
    if (start != null && end != null) {
      return '${fmt.format(start)} – ${fmt.format(end)}';
    }
    return start != null ? fmt.format(start) : fmt.format(end!);
  }

  String _formatAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }
}
