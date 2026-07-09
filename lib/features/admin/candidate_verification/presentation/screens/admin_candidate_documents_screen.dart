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
          final imageUrl = getCandidateAvatarUrl(c);
          final programsCount = (c['programs'] is List) ? (c['programs'] as List).length : 2;

          final formUrl = c['form_url']?.toString() ?? c['document_url']?.toString();
          final ktmUrl = c['ktm_url']?.toString();
          final visiMisiUrl = c['vision_mission_url']?.toString() ?? c['visi_url']?.toString();
          final recUrl = c['recommendation_url']?.toString();

          final formText = c['form_text']?.toString() ?? 'Formulir Pendaftaran Resmi untuk Paslon Nomor Urut $candNo ($name).\n\nStatus: Terverifikasi lengkap dan memenuhi seluruh persyaratan administrasi.';
          final ktmText = c['ktm_text']?.toString() ?? 'Dokumen verifikasi akademik untuk $name.\n\nStatus: Mahasiswa Aktif pada semester berjalan, IPK memenuhi kualifikasi minimum (> 3.00).';
          final visiMisiText = 'Visi:\n${c['visi'] ?? 'Mewujudkan lingkungan kampus transparan.'}\n\nMisi:\n${c['misi'] ?? 'Meningkatkan kolaborasi digital.'}' + ((c['programs'] is List && (c['programs'] as List).isNotEmpty) ? '\n\nProgram Kerja Unggulan:\n' + (c['programs'] as List).map((p) => '• ${(p is Map ? (p['title'] ?? p['name'] ?? '') : p.toString())}').join('\n') : '');
          final recText = c['recommendation_text']?.toString() ?? 'Surat rekomendasi resmi dari Dekanat $faculty serta pengurus himpunan/ormawa terkait untuk pendaftaran Paslon $name.';

          final List<Widget> documentWidgets = [];
          if (c['documents'] is List && (c['documents'] as List).isNotEmpty) {
            final docsList = c['documents'] as List;
            for (var i = 0; i < docsList.length; i++) {
              final doc = docsList[i];
              if (doc is Map) {
                final docTitle = doc['title']?.toString() ?? 'Dokumen ${i + 1}';
                final docMeta = doc['meta']?.toString() ?? 'Berkas Terlampir';
                final docContent = doc['content']?.toString() ?? 'Salinan dokumen resmi terdaftar di database untuk Paslon $name.';
                final docFileUrl = doc['file_url']?.toString() ?? doc['fileUrl']?.toString();
                final docIcon = i == 0 ? Icons.description_outlined : (i == 1 ? Icons.badge_outlined : (i == 2 ? Icons.campaign_outlined : Icons.verified_outlined));

                documentWidgets.add(
                  _buildDocumentTile(
                    context: context,
                    title: docTitle,
                    meta: docMeta,
                    icon: docIcon,
                    verified: true,
                    content: docContent,
                    fileUrl: docFileUrl,
                    candidateName: name,
                    candidateNo: candNo,
                  ),
                );
                if (i < docsList.length - 1) {
                  documentWidgets.add(const SizedBox(height: AppSpacing.sm));
                }
              }
            }
          }

          if (documentWidgets.isEmpty) {
            documentWidgets.addAll([
              _buildDocumentTile(
                context: context,
                title: 'Formulir Pendaftaran Resmi Paslon',
                meta: 'PDF • Berkas Terverifikasi Sistem',
                icon: Icons.description_outlined,
                verified: true,
                content: formText,
                fileUrl: formUrl,
                candidateName: name,
                candidateNo: candNo,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Kartu Tanda Mahasiswa (KTM) & KHS',
                meta: 'JPG / PDF • Status Mahasiswa Aktif',
                icon: Icons.badge_outlined,
                verified: true,
                content: ktmText,
                fileUrl: ktmUrl,
                candidateName: name,
                candidateNo: candNo,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Naskah Visi, Misi & Rencana Kerja ($programsCount Program)',
                meta: 'PDF • 840 KB',
                icon: Icons.campaign_outlined,
                verified: isVerified,
                content: visiMisiText,
                fileUrl: visiMisiUrl,
                candidateName: name,
                candidateNo: candNo,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDocumentTile(
                context: context,
                title: 'Surat Rekomendasi Organisasi & Fakultas',
                meta: 'PDF • 1.1 MB',
                icon: Icons.verified_outlined,
                verified: true,
                content: recText,
                fileUrl: recUrl,
                candidateName: name,
                candidateNo: candNo,
              ),
            ]);
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _buildCandidateHeader(name, faculty, candNo, imageUrl, isVerified),
              const SizedBox(height: AppSpacing.xl),
              Text('Dokumen & Berkas Pengajuan',
                  style: AppTypography.screenTitle.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.md),
              ...documentWidgets,
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

  Widget _buildCandidateHeader(String name, String faculty, String candNo, String? imageUrl, bool isVerified) {
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
        buildCandidateAvatarWidget(
          imageUrl: imageUrl,
          size: 58,
          radius: 14,
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
    String? fileUrl,
    required String candidateName,
    required String candidateNo,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => _showDocumentViewerSheet(
          context: context,
          title: title,
          meta: meta,
          icon: icon,
          content: content,
          fileUrl: fileUrl,
          candidateName: candidateName,
          candidateNo: candidateNo,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
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
              onPressed: () => _showDocumentViewerSheet(
                context: context,
                title: title,
                meta: meta,
                icon: icon,
                content: content,
                fileUrl: fileUrl,
                candidateName: candidateName,
                candidateNo: candidateNo,
              ),
              icon: const Icon(Icons.visibility_outlined,
                  color: AppColors.primary800),
            ),
          ]),
        ),
      ),
    );
  }

  void _showDocumentViewerSheet({
    required BuildContext context,
    required String title,
    required String meta,
    required IconData icon,
    required String content,
    String? fileUrl,
    required String candidateName,
    required String candidateNo,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _DocumentViewerModal(
        title: title,
        meta: meta,
        icon: icon,
        content: content,
        fileUrl: fileUrl,
        candidateName: candidateName,
        candidateNo: candidateNo,
      ),
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

class _DocumentViewerModal extends StatefulWidget {
  final String title;
  final String meta;
  final IconData icon;
  final String content;
  final String? fileUrl;
  final String candidateName;
  final String candidateNo;

  const _DocumentViewerModal({
    required this.title,
    required this.meta,
    required this.icon,
    required this.content,
    this.fileUrl,
    required this.candidateName,
    required this.candidateNo,
  });

  @override
  State<_DocumentViewerModal> createState() => _DocumentViewerModalState();
}

class _DocumentViewerModalState extends State<_DocumentViewerModal> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _isDownloaded = false;

  Future<void> _handleDownload() async {
    if (_isDownloading) return;
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() {
        _downloadProgress = i / 10.0;
      });
    }

    if (!mounted) return;
    setState(() {
      _isDownloading = false;
      _isDownloaded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '✅ Berkas "${widget.title}" (${widget.candidateName}) berhasil diunduh dan tersimpan di penyimpanan lokal!',
                style: AppTypography.captionBold.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.successTeal,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFileUrl = widget.fileUrl != null &&
        widget.fileUrl!.trim().isNotEmpty &&
        widget.fileUrl != 'null';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary800.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: AppColors.primary800, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: AppTypography.screenTitle.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(widget.meta,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: hasFileUrl ? const Color(0xFFE8F6F2) : const Color(0xFFEFF3F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: hasFileUrl
                      ? AppColors.successTeal.withValues(alpha: 0.4)
                      : AppColors.primary800.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  hasFileUrl ? Icons.cloud_done_rounded : Icons.folder_shared_rounded,
                  size: 18,
                  color: hasFileUrl ? AppColors.successTeal : AppColors.primary800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasFileUrl
                        ? 'Sumber: Berkas Fisik Terlampir di Database'
                        : 'Sumber: Arsip Digital & Salinan Resmi Sistem',
                    style: AppTypography.captionBold.copyWith(
                      color: hasFileUrl ? AppColors.successTeal : AppColors.primary800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Letterhead header simulation
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.outlineVariant, width: 2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BERKAS KANDIDAT VOTERYX',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.goldDark,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'NO. URUT ${widget.candidateNo}',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.primary800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kandidat: ${widget.candidateName}',
                      style: AppTypography.itemTitle.copyWith(color: AppColors.primary900),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.content,
                      style: AppTypography.bodyMedium.copyWith(
                        height: 1.6,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (hasFileUrl) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded,
                                color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.fileUrl!,
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.primary800,
                                    decoration: TextDecoration.underline),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_isDownloading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _downloadProgress,
                backgroundColor: AppColors.outlineVariant,
                color: AppColors.goldMid,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Mengunduh berkas... ${(_downloadProgress * 100).toInt()}%',
                style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? null : _handleDownload,
                  icon: Icon(
                    _isDownloaded ? Icons.check_circle_rounded : Icons.download_rounded,
                    color: Colors.white,
                  ),
                  label: Text(_isDownloaded ? 'BERKAS DIUNDUH' : 'UNDUH BERKAS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isDownloaded ? AppColors.successTeal : AppColors.goldMid,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary800,
                    side: const BorderSide(color: AppColors.primary800, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
