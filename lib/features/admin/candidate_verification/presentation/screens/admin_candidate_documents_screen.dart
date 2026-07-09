import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/admin/candidate_verification/presentation/providers/admin_candidate_verification_provider.dart';

class AdminCandidateDocumentsScreen extends ConsumerWidget {
  final String candidateId;
  const AdminCandidateDocumentsScreen({super.key, required this.candidateId});

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
        title: Text('Berkas Kandidat',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: candidatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goldMid)),
        error: (err, _) => Center(child: Text('Gagal memuat berkas kandidat: $err')),
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
          final imageUrl = c['photo_url']?.toString() ?? 'https://i.pravatar.cc/150?img=12';
          final programsCount = (c['programs'] is List) ? (c['programs'] as List).length : 2;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _buildCandidateHeader(name, faculty, candNo, imageUrl, isVerified),
              const SizedBox(height: AppSpacing.xl),
              Text('Dokumen & Berkas Pengajuan',
                  style: AppTypography.screenTitle.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.md),
              _buildDocumentTile(
                context: context,
                title: 'Formulir Pendaftaran Resmi Paslon',
                meta: 'PDF • Berkas Terverifikasi Sistem',
                icon: Icons.description_outlined,
                verified: true,
                content: 'Form Pendaftaran untuk Paslon Nomor Urut $candNo ($name).\nStatus berkas lengkap dan ditandatangani panitia pemilu.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Kartu Tanda Mahasiswa (KTM) & KHS',
                meta: 'JPG / PDF • Status Mahasiswa Aktif',
                icon: Icons.badge_outlined,
                verified: true,
                content: 'Dokumen verifikasi akademik untuk $name.\nIPK memenuhi kualifikasi minimum (> 3.00) dan status aktif pada semester berjalan.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Naskah Visi, Misi & Rencana Kerja ($programsCount Program)',
                meta: 'PDF • 840 KB',
                icon: Icons.campaign_outlined,
                verified: isVerified,
                content: 'Visi: ${c['visi'] ?? 'Mewujudkan lingkungan kampus transparan.'}\n\nMisi: ${c['misi'] ?? 'Meningkatkan kolaborasi digital.'}',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Surat Rekomendasi Organisasi & Fakultas',
                meta: 'PDF • 1.1 MB',
                icon: Icons.verified_outlined,
                verified: true,
                content: 'Surat rekomendasi resmi dari Dekanat $faculty dan pengurus himpunan/ormawa terkait.',
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildNoteCard(),
              const SizedBox(height: AppSpacing.xl),

              if (!isVerified)
                ElevatedButton.icon(
                  onPressed: () async {
                    final success = await ref
                        .read(adminCandidateVerificationProvider.notifier)
                        .updateVerificationStatus(candidateId, true);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Berkas diverifikasi & Kandidat $name disetujui!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  label: Text('Verifikasi Berkas & Setujui Kandidat',
                      style: AppTypography.bodyBold.copyWith(color: Colors.white)),
                )
              else
                OutlinedButton.icon(
                  onPressed: () async {
                    final success = await ref
                        .read(adminCandidateVerificationProvider.notifier)
                        .updateVerificationStatus(candidateId, false);
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('⚠️ Verifikasi $name dibatalkan.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.cancel_outlined, color: AppColors.errorRed),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorRed),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  label: Text('Batalkan Status Verifikasi Berkas',
                      style: AppTypography.bodyBold.copyWith(color: AppColors.errorRed)),
                ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCandidateHeader(String name, String faculty, String candNo, String imageUrl, bool isVerified) {
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
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            imageUrl,
            width: 58,
            height: 58,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  color: AppColors.navy600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.person, color: AppColors.textSecondary, size: 30),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name,
              style: AppTypography.itemTitle
                  .copyWith(color: AppColors.primary900)),
          const SizedBox(height: 4),
          Text('$faculty • No. Urut $candNo',
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: isVerified ? AppColors.successTeal.withValues(alpha: 0.1) : AppColors.goldMid.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isVerified ? AppColors.successTeal.withValues(alpha: 0.3) : AppColors.goldMid.withValues(alpha: 0.3))),
          child: Text(isVerified ? 'Terverifikasi' : '4 Berkas',
              style: AppTypography.captionBold
                  .copyWith(color: isVerified ? AppColors.successTeal : AppColors.goldDark, fontSize: 10)),
        ),
      ]),
    );
  }

  Widget _buildDocumentTile({
    required BuildContext context,
    required String title,
    required String meta,
    required IconData icon,
    required bool verified,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color:
                  verified ? const Color(0xFFE8F6F2) : const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon,
              color: verified ? AppColors.successTeal : AppColors.warningAmber,
              size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary900, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(meta,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
        ])),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (ctx) => Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: AppColors.primary800, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(title, style: AppTypography.screenTitle.copyWith(fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(content, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Tutup Pratinjau'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.visibility_outlined,
                color: AppColors.primary800)),
      ]),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.goldMid.withValues(alpha: 0.35))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline, color: AppColors.goldDark, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                'Pastikan semua berkas sesuai sebelum menekan tombol tinjau pada halaman verifikasi kandidat.',
                style: AppTypography.caption
                    .copyWith(color: AppColors.primary900, height: 1.45))),
      ]),
    );
  }
}
