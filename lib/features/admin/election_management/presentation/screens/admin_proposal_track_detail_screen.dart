import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/admin/election_management/presentation/providers/admin_proposal_provider.dart';

class AdminProposalTrackDetailScreen extends ConsumerWidget {
  const AdminProposalTrackDetailScreen({super.key, required this.proposalId});

  final String proposalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: Text('Detail Review Usulan',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: proposalsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary800)),
        error: (err, _) => Center(
            child: Text('Gagal memuat data: $err',
                style: AppTypography.bodyText)),
        data: (proposals) {
          final item = proposals.cast<AdminProposalItem?>().firstWhere(
                (p) => p?.proposal.id == proposalId,
                orElse: () => null,
              );

          if (item == null) {
            return const Center(child: Text('Usulan tidak ditemukan'));
          }

          final p = item.proposal;
          return Container(
            decoration: const BoxDecoration(gradient: AppColors.pageGradient),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _buildAdminSummaryCard(item),
                const SizedBox(height: AppSpacing.xl),
                Text('Alur Review Admin',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18)),
                const SizedBox(height: AppSpacing.md),
                _buildStatusCard(p.status),
                const SizedBox(height: AppSpacing.xl),
                Text('Rincian Pengajuan',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18)),
                const SizedBox(height: AppSpacing.md),
                _buildDetailsCard(item),
                const SizedBox(height: AppSpacing.xl),
                Text('Kandidat & Verifikasi Berkas',
                    style: AppTypography.screenTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 12),
                _buildCandidatesList(context, item),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: () {
        final proposals = proposalsAsync.valueOrNull;
        if (proposals != null) {
          final item = proposals.cast<AdminProposalItem?>().firstWhere(
                (p) => p?.proposal.id == proposalId,
                orElse: () => null,
              );
          if (item != null) {
            if (item.proposal.isApproved) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => _PublishBottomSheet(item: item),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successTeal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    ),
                    child: const Text('Verifikasi & Publikasikan Pemilihan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              );
            } else if (item.proposal.isPending || item.proposal.isUnderReview) {
              final actionState = ref.watch(adminProposalActionProvider);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: actionState.isLoading ? null : () async {
                            final noteController = TextEditingController();
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Tolak Usulan'),
                                content: TextField(
                                  controller: noteController,
                                  decoration: const InputDecoration(hintText: 'Alasan penolakan (opsional)'),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref.read(adminProposalActionProvider.notifier).updateStatus(item.proposal.id, 'rejected', adminNote: noteController.text);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usulan ditolak')));
                                context.pop();
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorRed,
                            side: const BorderSide(color: AppColors.errorRed),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                          ),
                          child: const Text('Tolak Usulan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: actionState.isLoading || !item.candidates.every((c) => c.isVerified) ? null : () async {
                            await ref.read(adminProposalActionProvider.notifier).updateStatus(item.proposal.id, 'approved');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usulan disetujui')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !item.candidates.every((c) => c.isVerified) ? AppColors.outlineVariant : AppColors.successTeal,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                          ),
                          child: actionState.isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Setujui Usulan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        }
        return null;
      }(),
    );
  }

  Widget _buildAdminSummaryCard(AdminProposalItem item) {
    final p = item.proposal;
    final shortId = p.id.split('-').last.substring(0, 6).toUpperCase();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFDF9F0), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
              color: AppColors.goldMid.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.primary800,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.admin_panel_settings_outlined,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('VTX-$shortId',
                    style: AppTypography.captionBold
                        .copyWith(color: AppColors.goldDark)),
                Text(p.title,
                    style: AppTypography.screenTitle
                        .copyWith(fontSize: 18, height: 1.25)),
              ])),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(AppRadius.input),
              border:
                  Border.all(color: AppColors.warningAmber.withOpacity(0.28))),
          child: Row(children: [
            Icon(
              p.isPublished || p.isApproved ? Icons.check_circle : (p.isRejected ? Icons.cancel : Icons.rate_review_outlined),
              color: p.isPublished || p.isApproved ? AppColors.successTeal : (p.isRejected ? AppColors.errorRed : AppColors.warningAmber),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                    p.isPublished
                  ? 'Pemilihan ini telah sukses dipublikasikan dan sedang berjalan/terjadwal.'
                  : (p.isApproved
                      ? 'Usulan telah disetujui dan menunggu dijadwalkan secara sistem.'
                      : (p.isRejected
                          ? 'Usulan ini telah ditolak oleh admin. Alasan: ${p.adminNote ?? "-"}'
                          : 'Menunggu pemeriksaan kelengkapan dokumen dan validasi oleh admin.')),
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textPrimary, height: 1.4))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStatusCard(String status) {
    bool isReview = status == 'pending' || status == 'under_review';
    bool isApproved = status == 'approved' || status == 'published';
    bool isPublished = status == 'published';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      child: Column(children: [
        _buildStepItem(
            title: 'Diajukan',
            subtitle: 'Data usulan awal telah tersimpan di sistem.',
            isActive: true,
            isCompleted: true,
            isLast: false),
        _buildStepItem(
            title: 'Review Admin',
            subtitle: 'Periksa tujuan, jadwal, panitia, metode, dan dokumen pendukung.',
            isActive: isReview,
            isCompleted: !isReview && status != 'pending',
            isLast: false),
        _buildStepItem(
            title: status == 'rejected' ? 'Ditolak' : 'Disetujui',
            subtitle: status == 'rejected' 
                ? 'Usulan ditolak dan tidak dapat dilanjutkan.'
                : 'Usulan dapat dilanjutkan ke publikasi pemilihan.',
            isActive: status == 'rejected',
            isCompleted: isApproved,
            isLast: false),
        _buildStepItem(
            title: 'Live / Berjalan',
            subtitle: 'Pemilihan siap dipublikasikan ke pemilih.',
            isActive: isPublished,
            isCompleted: isPublished,
            isLast: true),
      ]),
    );
  }

  Widget _buildStepItem(
      {required String title,
      required String subtitle,
      required bool isActive,
      required bool isCompleted,
      required bool isLast}) {
    final color = isCompleted
        ? AppColors.successTeal
        : (isActive ? AppColors.warningAmber : AppColors.outline);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: isCompleted
                  ? color
                  : (isActive ? color.withOpacity(0.12) : Colors.transparent),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: isCompleted ? 0 : 2)),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : isActive
                  ? Center(
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle)))
                  : null,
        ),
        if (!isLast)
          Container(
              width: 2,
              height: 44,
              color: isCompleted ? color : AppColors.outlineVariant),
      ]),
      const SizedBox(width: AppSpacing.md),
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTypography.itemTitle.copyWith(
                  color: isActive || isCompleted
                      ? AppColors.textPrimary
                      : AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary, height: 1.4)),
        ]),
      )),
    ]);
  }

  Widget _buildDetailsCard(AdminProposalItem item) {
    final p = item.proposal;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(children: [
        _buildDetailRow('Tanggal Pengajuan', p.createdAt != null ? DateFormat('dd MMM yyyy, HH:mm').format(p.createdAt!) : '-'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Pengusul', item.proposerName),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Organisasi', p.organization ?? '-'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Jenis Pemilihan', p.electionType ?? '-'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Tujuan Pemilihan', p.purpose ?? '-'),
        const Divider(height: 24, color: AppColors.outlineVariant),
        _buildDetailRow('Periode', p.proposedStartDate != null && p.proposedEndDate != null ? '${DateFormat('dd MMM yy').format(p.proposedStartDate!)} s/d ${DateFormat('dd MMM yy').format(p.proposedEndDate!)}' : '-'),
        if (p.adminNote?.isNotEmpty == true) ...[
          const Divider(height: 24, color: AppColors.outlineVariant),
          _buildDetailRow('Catatan Admin', p.adminNote!),
        ]
      ]),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child: Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary))),
      Expanded(
          flex: 3,
          child: Text(value,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.right)),
    ]);
  }

  Widget _buildCandidatesList(BuildContext context, AdminProposalItem item) {
    if (item.candidates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: const Center(
          child: Text('Belum ada kandidat yang ditambahkan.'),
        ),
      );
    }
    return Column(
      children: item.candidates.map((c) {
        final isVerified = c.isVerified;
        final docsCompleted = c.docsCompleted;
        return InkWell(
          onTap: () {
            if (c.proposalCandidateId != null) {
              context.pushNamed(
                'admin-candidate-review',
                pathParameters: {'id': c.proposalCandidateId!},
                extra: {
                  'electionId': item.proposal.id,
                  'isProposal': true,
                },
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary800.withOpacity(0.1),
                  child: Text(
                    c.fullName.isNotEmpty ? c.fullName[0].toUpperCase() : '?',
                    style: AppTypography.itemTitle.copyWith(color: AppColors.primary800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.fullName, style: AppTypography.itemTitle),
                      if (c.nikOrNim != null)
                        Text('NIM/NIK: ${c.nikOrNim}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVerified ? Colors.green.withOpacity(0.1) : (docsCompleted ? AppColors.successTeal.withOpacity(0.1) : AppColors.warningAmber.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isVerified ? 'Terverifikasi' : (docsCompleted ? 'Berkas Lengkap' : 'Menunggu Berkas'),
                    style: AppTypography.captionBold.copyWith(
                      color: isVerified ? Colors.green.shade700 : (docsCompleted ? AppColors.successTeal : AppColors.goldDark),
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PublishBottomSheet extends ConsumerStatefulWidget {
  final AdminProposalItem item;
  const _PublishBottomSheet({required this.item});

  @override
  ConsumerState<_PublishBottomSheet> createState() => _PublishBottomSheetState();
}

class _PublishBottomSheetState extends ConsumerState<_PublishBottomSheet> {
  String _faculty = 'all';
  String _major = 'all';
  String _specificUsers = '';
  bool _isAllDocsCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkDocs();
  }

  void _checkDocs() {
    if (widget.item.candidates.isEmpty) {
      _isAllDocsCompleted = false;
      return;
    }
    bool allDone = true;
    for (var c in widget.item.candidates) {
      if (!c.docsCompleted) {
        allDone = false;
        break;
      }
    }
    _isAllDocsCompleted = allDone;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProposalActionProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Publikasikan Pemilihan', style: AppTypography.headerTitle),
              const SizedBox(height: 8),
              Text(
                'Tentukan target pemilih (DPT) dan pastikan kandidat telah diverifikasi sebelum membuat pemilihan ini Live.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              
              Text('1. Verifikasi Kandidat', style: AppTypography.itemTitle),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isAllDocsCompleted ? AppColors.successTeal.withOpacity(0.1) : AppColors.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isAllDocsCompleted ? AppColors.successTeal : AppColors.errorRed),
                ),
                child: Row(
                  children: [
                    Icon(_isAllDocsCompleted ? Icons.check_circle : Icons.warning_amber, color: _isAllDocsCompleted ? AppColors.successTeal : AppColors.errorRed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isAllDocsCompleted ? 'Semua dokumen kandidat lengkap dan terverifikasi.' : 'Terdapat kandidat yang belum melengkapi dokumen.',
                        style: AppTypography.bodyMedium.copyWith(color: _isAllDocsCompleted ? AppColors.successTeal : AppColors.errorRed),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('2. Target Pemilih (DPT)', style: AppTypography.itemTitle),
              const SizedBox(height: 12),
              Text('Fakultas', style: AppTypography.captionBold),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _faculty,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Semua Fakultas')),
                  DropdownMenuItem(value: 'Fakultas Sains dan Teknologi', child: Text('Fakultas Sains dan Teknologi')),
                  DropdownMenuItem(value: 'Fakultas Hukum', child: Text('Fakultas Hukum')),
                  DropdownMenuItem(value: 'Fakultas Kedokteran', child: Text('Fakultas Kedokteran')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _faculty = val);
                },
              ),
              const SizedBox(height: 16),
              Text('Jurusan / Program Studi', style: AppTypography.captionBold),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _major,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Semua Jurusan')),
                  DropdownMenuItem(value: 'Teknik Informatika', child: Text('Teknik Informatika')),
                  DropdownMenuItem(value: 'Sistem Informasi', child: Text('Sistem Informasi')),
                  DropdownMenuItem(value: 'Ilmu Hukum', child: Text('Ilmu Hukum')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _major = val);
                },
              ),
              const SizedBox(height: 16),
              Text('Pemilih Spesifik (Opsional)', style: AppTypography.captionBold),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Masukkan NIM (pisahkan dengan koma)',
                  hintStyle: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 2,
                onChanged: (val) {
                  _specificUsers = val;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isAllDocsCompleted && !state.isLoading)
                      ? () async {
                          final userList = _specificUsers.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                          final success = await ref.read(adminProposalActionProvider.notifier).publishElectionToLive(
                            item: widget.item,
                            facultyFilter: _faculty,
                            majorFilter: _major,
                            specificUsers: userList,
                          );
                          if (context.mounted) {
                            if (success) {
                              Navigator.pop(context); // close bottom sheet
                              Navigator.pop(context); // go back to list
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pemilihan berhasil di-publish dan Live!')),
                              );
                            } else {
                              final errorState = ref.read(adminProposalActionProvider);
                              final errMsg = errorState.hasError ? errorState.error.toString() : 'Terjadi kesalahan tidak diketahui';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal: $errMsg'),
                                  backgroundColor: AppColors.errorRed,
                                ),
                              );
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successTeal,
                    disabledBackgroundColor: AppColors.outline,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: state.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Buat Pemilihan Live', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
