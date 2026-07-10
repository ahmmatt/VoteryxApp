import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';
import 'package:voteryxapp/core/widgets/app_text_field.dart';
import 'package:voteryxapp/features/user/election_proposal/presentation/providers/candidate_document_provider.dart';
import 'package:voteryxapp/features/user/notifications/presentation/providers/user_notifications_provider.dart';

class CandidateDocumentFormScreen extends ConsumerStatefulWidget {
  final String proposalId;

  const CandidateDocumentFormScreen({super.key, required this.proposalId});

  @override
  ConsumerState<CandidateDocumentFormScreen> createState() => _CandidateDocumentFormScreenState();
}

class _CandidateDocumentFormScreenState extends ConsumerState<CandidateDocumentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();

  final List<Map<String, dynamic>> _trackRecords = [];
  final List<Map<String, dynamic>> _programs = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(candidateDocumentProvider.notifier).fetchCandidateData(widget.proposalId));
  }

  @override
  void dispose() {
    _visiController.dispose();
    _misiController.dispose();
    super.dispose();
  }

  void _addTrackRecord() {
    setState(() {
      _trackRecords.add({'year': '', 'title': '', 'description': ''});
    });
  }

  void _addProgram() {
    setState(() {
      _programs.add({'title': '', 'description': ''});
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Check if dynamic fields are empty
    for (var t in _trackRecords) {
      if (t['year'].toString().trim().isEmpty || t['title'].toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi semua field Tahun dan Judul pada Track Record.'), backgroundColor: AppColors.errorRed));
        return;
      }
    }
    for (var p in _programs) {
      if (p['title'].toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi semua field Judul pada Program Kerja.'), backgroundColor: AppColors.errorRed));
        return;
      }
    }

    final success = await ref.read(candidateDocumentProvider.notifier).submitDocument(
      proposalId: widget.proposalId,
      visi: _visiController.text.trim(),
      misi: _misiController.text.trim(),
      trackRecords: _trackRecords,
      programs: _programs,
    );

    if (success && mounted) {
      ref.invalidate(userNotificationsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Berhasil melengkapi berkas kandidat!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref.read(candidateDocumentProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Terjadi kesalahan.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(candidateDocumentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Lengkapi Berkas Kandidat', style: AppTypography.headerTitle.copyWith(fontSize: 18, color: Colors.white)),
        centerTitle: true,
      ),
      body: state.isLoading && state.candidateData == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.goldMid))
          : state.error != null && state.candidateData == null
              ? Center(child: Text(state.error!))
              : _buildForm(),
    );
  }

  Widget _buildForm() {
    final state = ref.watch(candidateDocumentProvider);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePad),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary800.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.primary800.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary800),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Anda diajukan sebagai kandidat. Lengkapi visi, misi, track record, dan program kerja agar usulan dapat diproses ke tahap verifikasi admin.',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'Visi',
            hint: 'Masukkan Visi Anda',
            controller: _visiController,
            maxLines: 3,
            validator: (value) => value == null || value.trim().isEmpty ? 'Visi tidak boleh kosong' : null,
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'Misi',
            hint: 'Masukkan Misi Anda',
            controller: _misiController,
            maxLines: 4,
            validator: (value) => value == null || value.trim().isEmpty ? 'Misi tidak boleh kosong' : null,
          ),
          
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Track Record (Pengalaman)', style: AppTypography.screenTitle.copyWith(fontSize: 16)),
              TextButton.icon(
                onPressed: _addTrackRecord,
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
                style: TextButton.styleFrom(foregroundColor: AppColors.goldDark),
              ),
            ],
          ),
          if (_trackRecords.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Belum ada track record.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ),
          ..._trackRecords.asMap().entries.map((entry) {
            final index = entry.key;
            final record = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Pengalaman ${index + 1}', style: AppTypography.itemTitle),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                        onPressed: () => setState(() => _trackRecords.removeAt(index)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: record['year'],
                    decoration: const InputDecoration(labelText: 'Tahun (Contoh: 2023)'),
                    onChanged: (val) => record['year'] = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: record['title'],
                    decoration: const InputDecoration(labelText: 'Jabatan / Posisi'),
                    onChanged: (val) => record['title'] = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: record['description'],
                    decoration: const InputDecoration(labelText: 'Deskripsi Singkat (Opsional)'),
                    maxLines: 2,
                    onChanged: (val) => record['description'] = val,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Program Kerja', style: AppTypography.screenTitle.copyWith(fontSize: 16)),
              TextButton.icon(
                onPressed: _addProgram,
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
                style: TextButton.styleFrom(foregroundColor: AppColors.goldDark),
              ),
            ],
          ),
          if (_programs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Belum ada program kerja.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ),
          ..._programs.asMap().entries.map((entry) {
            final index = entry.key;
            final program = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Program ${index + 1}', style: AppTypography.itemTitle),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                        onPressed: () => setState(() => _programs.removeAt(index)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: program['title'],
                    decoration: const InputDecoration(labelText: 'Judul Program Kerja'),
                    onChanged: (val) => program['title'] = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: program['description'],
                    decoration: const InputDecoration(labelText: 'Deskripsi Program Kerja (Opsional)'),
                    maxLines: 2,
                    onChanged: (val) => program['description'] = val,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 32),
          GoldButton(
            label: 'Kirim Berkas Kandidat',
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
