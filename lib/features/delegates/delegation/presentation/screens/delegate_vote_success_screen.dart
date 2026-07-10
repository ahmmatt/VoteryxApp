// lib/features/delegation/presentation/screens/delegate_vote_success_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_dashboard_provider.dart';
import 'package:voteryxapp/features/delegates/delegation/application/delegate_vote_execution_provider.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

/// Model mandator utama untuk ditampilkan di bukti eksekusi.
class _MandatorItem {
  final String name;
  final String imageUrl;

  const _MandatorItem({required this.name, required this.imageUrl});
}

/// Layar Delegate Portal — menampilkan bukti eksekusi suara yang
/// berhasil dikunci beserta detail receipt dan QR code validasi.
class DelegateVoteSuccessScreen extends ConsumerWidget {
  const DelegateVoteSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(delegateVoteExecutionProvider);
    final dashboardData = ref.watch(delegateDashboardProvider).valueOrNull;
    final profile = ref.watch(userProfileProvider).valueOrNull;
    
    final int weight = state.totalWeight > 0 ? state.totalWeight : 0;
    final String batchId = state.transactionHash ?? '#VOTE-DELEG-9921-X';
    final String electionTitle = dashboardData?.urgentElectionTitle ?? 'Pemilihan Aktif';
    final String executorName = profile?.fullName ?? 'Delegate';
    
    final activeMandates = dashboardData?.mandates.where((m) => m.status == 'active').toList() ?? [];
    final totalMandators = activeMandates.length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Success badge ──────────────────────────────────
              _buildSuccessBadge(),
              const SizedBox(height: 28),

              // ── Headline ───────────────────────────────────────
              Text(
                '$weight Suara Berhasil Dikunci!',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 24,
                  color: AppColors.primary900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Eksekusi mandat anda telah tercatat permanen\ndi sistem.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 28),

              // ── Receipt card ───────────────────────────────────
              _buildReceiptCard(context, batchId, electionTitle, executorName, weight, totalMandators, activeMandates),
              const SizedBox(height: 20),

              // ── Info banner ────────────────────────────────────
              _buildInfoBanner(),
              const SizedBox(height: 28),

              // ── Action buttons ─────────────────────────────────
              _buildSaveButton(),
              const SizedBox(height: 12),
              _buildDashboardButton(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return Container(
        color: AppColors.outlineVariant,
        child: const Icon(Icons.person, color: AppColors.textSecondary, size: 20),
      );
    }
    
    try {
      if (avatarUrl.startsWith('data:image')) {
        final base64Str = avatarUrl.split(',').last;
        final normalized = base64.normalize(base64Str.replaceAll(RegExp(r'\s+'), ''));
        return Image.memory(
          base64Decode(normalized),
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          avatarUrl,
          fit: BoxFit.cover,
        );
      }
    } catch (_) {
      return Container(
        color: AppColors.outlineVariant,
        child: const Icon(Icons.person, color: AppColors.textSecondary, size: 20),
      );
    }
  }

  // ─────────────────────────── AppBar ────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Delegate Portal',
        style: AppTypography.headerTitle,
      ),
    );
  }

  // ─────────────────── Success Badge ─────────────────────────────
  Widget _buildSuccessBadge() {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.goldMid,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.goldMid.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.how_to_vote, color: Colors.white, size: 46),
        ),
        Positioned(
          top: -6,
          right: -12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '×$weight',
              style: AppTypography.captionBold.copyWith(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────── Receipt Card ──────────────────────────
  Widget _buildReceiptCard(BuildContext context, String batchId, String electionTitle, String executorName, int weight, int totalMandators, List<DelegateMandateItem> mandates) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header label
          Text(
            'BUKTI EKSEKUSI DELEGATE',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),

          // Batch ID chip
          _buildBatchIdChip(context, batchId),
          const SizedBox(height: 20),

          const Divider(color: AppColors.outlineVariant, height: 1),
          const SizedBox(height: 20),

          // Receipt rows
          _buildReceiptRow('Waktu', _formatCurrentTime()),
          const SizedBox(height: 14),
          _buildReceiptRow('Pemilihan', electionTitle),
          const SizedBox(height: 14),
          _buildReceiptRowWithBadge('Dieksekusi sebagai', executorName, 'DELEGATE'),
          const SizedBox(height: 14),
          _buildReceiptRow('Bobot Dieksekusi', '$weight Suara',
              valueColor: AppColors.goldDark),
          const SizedBox(height: 14),
          _buildReceiptRow('Mandator', '$totalMandators Orang'),
          const SizedBox(height: 20),

          // Mandator detail box
          if (mandates.isNotEmpty) _buildMandatorDetail(mandates),
          const SizedBox(height: 20),

          // QR Code
          _buildQrCode(),
          const SizedBox(height: 10),
          Text(
            'Scan untuk memvalidasi',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Batch ID Chip ─────────────────────────────
  Widget _buildBatchIdChip(BuildContext context, String batchId) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: batchId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Batch ID disalin')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.outlineVariant.withOpacity(0.25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BATCH ID: $batchId',
              style: AppTypography.captionBold.copyWith(
                color: AppColors.primary900,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.content_copy_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── Receipt Row helpers ───────────────────────
  Widget _buildReceiptRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: AppTypography.bodyText.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor ?? AppColors.primary900,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRowWithBadge(
    String label,
    String value,
    String badge,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: AppTypography.bodyText.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: AppTypography.captionBold.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────── Mandator Detail Box ───────────────────────
  Widget _buildMandatorDetail(List<DelegateMandateItem> mandates) {
    final displayMandates = mandates.take(3).toList();
    final remaining = mandates.length - displayMandates.length;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETAIL MANDATOR UTAMA',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          ...displayMandates.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMandatorItem(m),
              )),
          if (remaining > 0) ...[
            const Divider(color: AppColors.outlineVariant, height: 1),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '+$remaining mandator lainnya',
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.primary900,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMandatorItem(DelegateMandateItem item) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant, width: 1),
          ),
          child: ClipOval(child: _buildAvatar(item.delegatorAvatarUrl)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.delegatorName,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          'Verified',
          style: AppTypography.captionBold.copyWith(
            color: AppColors.goldDark,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ─────────────────────── QR Code mock ──────────────────────────
  Widget _buildQrCode() {
    return Container(
      width: 108,
      height: 108,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Icon(
        Icons.qr_code_2_rounded,
        size: 84,
        color: AppColors.primary900.withOpacity(0.85),
      ),
    );
  }

  // ─────────────────── Info Banner ───────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE594)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.goldDark, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kandidat yang dipilih tetap dirahasiakan oleh sistem enkripsi Civic Glass. Riwayat ini hanya mencatat bahwa suara telah sukses dieksekusi.',
              style: AppTypography.caption.copyWith(
                color: AppColors.goldDark,
                height: 1.5,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Action Buttons ────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldMid,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              'Simpan Bukti Eksekusi ke Galeri',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => context.pushNamed('delegate-history'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary900,
          side: const BorderSide(color: AppColors.primary900, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Text(
          'Kembali ke Dashboard',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary900,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${now.day} ${months[now.month - 1]} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
  }
}
