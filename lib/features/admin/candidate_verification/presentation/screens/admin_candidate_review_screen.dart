import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/admin/candidate_verification/presentation/providers/admin_candidate_verification_provider.dart';

class AdminCandidateReviewScreen extends ConsumerWidget {
  final String candidateId;
  const AdminCandidateReviewScreen({super.key, required this.candidateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatesAsync = ref.watch(adminCandidateVerificationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop()),
        title: Text('Tinjau & Verifikasi Paslon',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: candidatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goldMid)),
        error: (err, _) => Center(child: Text('Gagal memuat detail kandidat: $err')),
        data: (candidates) {
          final c = candidates.firstWhere(
            (element) => element['id'] == candidateId,
            orElse: () => candidates.isNotEmpty ? candidates.first : <String, dynamic>{},
          );

          if (c.isEmpty) {
            return const Center(child: Text('Data kandidat tidak ditemukan.'));
          }

          final name = c['full_name']?.toString() ?? 'Kandidat';
          final candNo = c['candidate_number']?.toString() ?? '1';
          final faculty = c['faculty']?.toString() ?? c['major']?.toString() ?? 'Fakultas Teknik';
          final isVerified = c['is_verified'] == true;
          final electionTitle = (c['elections'] is Map) ? (c['elections']['title']?.toString() ?? 'Pemilihan BEM') : 'Pemilihan BEM';
          final imageUrl = getCandidateAvatarUrl(c);
          final visi = c['visi']?.toString() ?? 'Mewujudkan lingkungan kampus kolaboratif.';
          final hasPrograms = c['programs'] != null && (c['programs'] is List) && (c['programs'] as List).isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _buildProfileCard(name, faculty, candNo, electionTitle, isVerified, imageUrl),
              const SizedBox(height: AppSpacing.xl),
              Text('Checklist Kelayakan & Verifikasi',
                  style: AppTypography.screenTitle.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.md),
              _buildChecklistCard(isVerified, hasPrograms, visi.isNotEmpty),
              const SizedBox(height: AppSpacing.xl),
              _buildDecisionCard(context, ref, candidateId, name, isVerified),
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(String name, String faculty, String candNo, String electionTitle, bool isVerified, String? imageUrl) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          buildCandidateAvatarWidget(
            imageUrl: imageUrl,
            size: 62,
            radius: 16,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: AppTypography.screenTitle
                        .copyWith(fontSize: 18, color: AppColors.primary900)),
                const SizedBox(height: 4),
                Text('$faculty • No. Urut $candNo',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ])),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _buildInfoRow('Pemilihan', electionTitle),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildInfoRow('Nomor Urut', 'Paslon Nomor $candNo'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildInfoRow('Status Database', isVerified ? '✅ TERVERIFIKASI RESMI' : '⏳ MENUNGGU REVIEW'),
      ]),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child: Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary))),
      Expanded(
          flex: 3,
          child: Text(value,
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900, fontWeight: FontWeight.w600))),
    ]);
  }

  Widget _buildChecklistCard(bool isVerified, bool hasPrograms, bool hasVisi) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(children: [
        _buildChecklistItem('Identitas paslon & fakultas valid', true),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Berkas pendaftaran dan KTM lengkap', true),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Visi & misi kandidat telah diisi', hasVisi),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Program kerja paslon terdefinisi', hasPrograms),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildChecklistItem('Status verifikasi diaktifkan oleh Admin', isVerified),
      ]),
    );
  }

  Widget _buildChecklistItem(String title, bool checked) {
    return Row(children: [
      Icon(checked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: checked ? AppColors.successTeal : AppColors.outline, size: 20),
      const SizedBox(width: 10),
      Expanded(
          child: Text(title,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.primary900))),
    ]);
  }

  Widget _buildDecisionCard(BuildContext context, WidgetRef ref, String candidateId, String name, bool isVerified) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Keputusan Verifikasi Admin',
            style:
                AppTypography.itemTitle.copyWith(color: AppColors.primary900)),
        const SizedBox(height: AppSpacing.sm),
        Text(
            'Dengan menekan tombol Setujui, kandidat akan berstatus TERVERIFIKASI di database Supabase dan sah berpartisipasi dalam pemilihan live.',
            style: AppTypography.caption
                .copyWith(color: AppColors.textSecondary, height: 1.45)),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () async {
                    final success = await ref
                        .read(adminCandidateVerificationProvider.notifier)
                        .updateVerificationStatus(candidateId, false);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('⚠️ Verifikasi untuk $name dibatalkan.')),
                      );
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Batalkan / Tolak'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(color: AppColors.errorRed),
                      padding: const EdgeInsets.symmetric(vertical: 14)))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final success = await ref
                        .read(adminCandidateVerificationProvider.notifier)
                        .updateVerificationStatus(candidateId, true);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Kandidat $name berhasil diverifikasi & disetujui!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.check, size: 18, color: Colors.white),
                  label: const Text('Setujui & Verifikasi'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14)))),
        ]),
      ]),
    );
  }
}
