import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import '../providers/user_notifications_provider.dart';

void showNotificationsModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const NotificationsBottomSheet(),
  );
}

class NotificationsBottomSheet extends ConsumerWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(userNotificationsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary800.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active_outlined, color: AppColors.primary800, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pusat Notifikasi', style: AppTypography.headerTitle.copyWith(fontSize: 18)),
                      Text('Info terbaru mengenai pemilihan dan aktivitasmu', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ref.invalidate(userNotificationsProvider),
                  icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
                  tooltip: 'Segarkan Notifikasi',
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Body
          Expanded(
            child: notifsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildNotificationCard(item);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.goldMid),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                      const SizedBox(height: 12),
                      Text('Gagal Memuat Notifikasi', style: AppTypography.cardTitle),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(userNotificationsProvider),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary800),
                        child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary800.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_off_outlined, size: 56, color: AppColors.outline),
            ),
            const SizedBox(height: 20),
            Text('Belum Ada Notifikasi', style: AppTypography.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Saat ini belum ada aktivitas pemilihan, delegasi suara, atau status usulan baru pada akun Anda.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotificationItem item) {
    Color badgeColor;
    IconData icon;

    switch (item.type) {
      case 'election':
        badgeColor = AppColors.primary800;
        icon = Icons.how_to_vote_outlined;
        break;
      case 'vote':
        badgeColor = AppColors.successTeal;
        icon = Icons.check_circle_outline;
        break;
      case 'delegation':
        badgeColor = AppColors.goldMid;
        icon = Icons.group_outlined;
        break;
      case 'proposal_approved':
        badgeColor = AppColors.successTeal;
        icon = Icons.verified_outlined;
        break;
      case 'proposal_rejected':
        badgeColor = AppColors.errorRed;
        icon = Icons.cancel_outlined;
        break;
      case 'proposal_pending':
      default:
        badgeColor = AppColors.warningAmber;
        icon = Icons.pending_actions_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: badgeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                    ),
                    Text(
                      _formatTimestamp(item.timestamp),
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    if (diff.inDays < 7) return '${diff.inDays}h lalu';
    return '${time.day}/${time.month}/${time.year}';
  }
}
