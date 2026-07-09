import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/features/user/election/domain/entities/election.dart';
import 'package:voteryxapp/features/user/election/presentation/providers/election_provider.dart';

class ElectionsTab extends ConsumerWidget {
  const ElectionsTab({super.key});

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final electionsAsync = ref.watch(allElectionsProvider);

    return Column(
      children: [
        // Top Section (Navy Background AppBar)
        _buildAppBar(context, ref),
        
        // Body
        Expanded(
          child: Container(
            color: AppColors.background,
            child: electionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary800),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                      const SizedBox(height: 12),
                      Text('Gagal memuat daftar pemilihan', style: AppTypography.cardTitle.copyWith(color: AppColors.primary800)),
                      const SizedBox(height: 6),
                      Text(err.toString(), style: AppTypography.caption.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(allElectionsProvider),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary800),
                        child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              data: (elections) {
                // Filter hanya pemilihan aktif & lengkap (kandidat >= 2)
                final activeElections = elections
                    .where((e) => (e.status == 'live' || e.status == 'scheduled') && e.candidateCount >= 2 && e.title.isNotEmpty)
                    .toList();
                final completedElections = elections
                    .where((e) => e.status == 'completed' || e.status == 'ended')
                    .toList();

                if (activeElections.isEmpty && completedElections.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.how_to_vote_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text('Belum Ada Pemilihan Terverifikasi', style: AppTypography.cardTitle.copyWith(color: AppColors.primary800)),
                          const SizedBox(height: 8),
                          Text(
                            'Saat ini belum ada pemilihan yang memenuhi syarat (minimal 2 paslon terverifikasi dan berstatus aktif/terjadwal).',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Text(
                      'Daftar Pemilihan',
                      style: AppTypography.displayHeading.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tentukan masa depan institusi Anda hari ini.',
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Live & Scheduled Election Cards
                    if (activeElections.isNotEmpty) ...[
                      Text('Pemilihan Berlangsung & Terjadwal', style: AppTypography.itemTitle.copyWith(color: AppColors.primary800)),
                      const SizedBox(height: AppSpacing.sm),
                      ...activeElections.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                            child: _buildDynamicLiveElectionCard(context, e),
                          )),
                    ],
                    
                    // Completed Election Cards
                    if (completedElections.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text('Riwayat Pemilihan Selesai', style: AppTypography.itemTitle.copyWith(color: AppColors.primary800)),
                      const SizedBox(height: AppSpacing.sm),
                      ...completedElections.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                            child: _buildDynamicCompletedElectionCard(context, e),
                          )),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: AppColors.primary800,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        bottom: AppSpacing.md,
        left: AppSpacing.pagePad,
        right: AppSpacing.pagePad,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.canPop() ? context.pop() : context.go('/dashboard'),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Elections',
                style: AppTypography.headerTitle.copyWith(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(allElectionsProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicLiveElectionCard(BuildContext context, Election election) {
    final isLive = election.isLive;
    final statusColor = isLive ? AppColors.goldDark : const Color(0xFF1E50FF);
    final statusBg = isLive ? const Color(0xFFFFF6E5) : const Color(0xFFE5EEFF);
    final statusText = isLive ? 'SEDANG BERLANGSUNG' : 'TERJADWAL';
    final dotColor = isLive ? AppColors.goldMid : const Color(0xFF1E50FF);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: isLive ? AppColors.glassBorderGold : AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(statusText, style: AppTypography.captionBold.copyWith(color: statusColor, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(election.timeRemainingFormatted, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(election.title, style: AppTypography.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            election.description ?? 'Pemilihan resmi oleh ${election.organization ?? "Panitia Pemilihan"}.',
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Middle Info Box
          _buildInfoBox(
            icon: Icons.people_outline,
            title: 'PARTISIPASI SAAT INI',
            value: '${election.voteCount} dari ${election.estimatedVoters > 0 ? election.estimatedVoters : 100} Pemilih (${election.participationRate.toStringAsFixed(1)}%)',
            bgColor: const Color(0xFFF3F4F6),
            iconColor: AppColors.primary800,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoBox(
            icon: Icons.event_note_outlined,
            title: 'TIMELINE PEMILIHAN',
            value: '${_formatDate(election.startDate)} – ${_formatDate(election.endDate)}',
            bgColor: const Color(0xFFFFF6E5),
            iconColor: AppColors.goldDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  context.pushNamed('election-info', pathParameters: {'id': election.id});
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text('Lihat Detail', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary800, fontWeight: FontWeight.w700)),
                ),
              ),
              InkWell(
                onTap: () {
                  context.pushNamed('election', pathParameters: {'id': election.id});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.goldDark,
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A030), Color(0xFFB38622)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMid.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.how_to_vote, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Pilih Sekarang', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCompletedElectionCard(BuildContext context, Election election) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('Selesai', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
              ),
              const Icon(Icons.check_circle_outline, color: AppColors.successTeal, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(election.title, style: AppTypography.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text('Berakhir pada ${_formatDate(election.endDate)}', style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          
          // Bottom Action
          InkWell(
            onTap: () {
              context.pushNamed('election-info', pathParameters: {'id': election.id});
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF384666),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text('Lihat Hasil Akhir', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.captionBold.copyWith(fontSize: 10)),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
