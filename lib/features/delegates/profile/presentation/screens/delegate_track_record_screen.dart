// lib/features/delegates/profile/presentation/screens/delegate_track_record_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/user/profile/presentation/providers/profile_provider.dart';

// ─────────────────── Model ─────────────────────────────────────────────────

class _TrackRecordItem {
  final String dateRange;
  final String title;
  final String description;
  final List<String> tags;

  const _TrackRecordItem({
    required this.dateRange,
    required this.title,
    required this.description,
    this.tags = const [],
  });

  factory _TrackRecordItem.fromJson(Map<String, dynamic> json) {
    return _TrackRecordItem(
      dateRange: json['dateRange'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateRange': dateRange,
      'title': title,
      'description': description,
      'tags': tags,
    };
  }
}

// ─────────────────── Screen ────────────────────────────────────────────────

class DelegateTrackRecordScreen extends ConsumerStatefulWidget {
  const DelegateTrackRecordScreen({super.key});

  @override
  ConsumerState<DelegateTrackRecordScreen> createState() =>
      _DelegateTrackRecordScreenState();
}

class _DelegateTrackRecordScreenState extends ConsumerState<DelegateTrackRecordScreen> {
  bool _initialized = false;
  final List<_TrackRecordItem> _records = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final profile = ref.read(userProfileProvider).valueOrNull;
      final savedRecords = profile?.delegateTrackRecords ?? [];
      if (savedRecords.isNotEmpty) {
        _records.addAll(savedRecords.map((json) => _TrackRecordItem.fromJson(json)));
      }
      _initialized = true;
    }
  }

  void _addRecord(_TrackRecordItem item) {
    setState(() {
      _records.add(item);
    });
  }

  void _editRecord(int index, _TrackRecordItem item) {
    setState(() {
      _records[index] = item;
    });
  }

  void _deleteRecord(int index) {
    setState(() {
      _records.removeAt(index);
    });
  }

  Future<void> _saveToDatabase() async {
    final recordsJson = _records.map((r) => r.toJson()).toList();
    await ref.read(profileUpdateProvider.notifier).updateProfile(
          delegateTrackRecords: recordsJson,
        );
    if (!mounted) return;
    final state = ref.read(profileUpdateProvider);
    if (state.error == null) {
      ref.invalidate(userProfileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Track Record berhasil disimpan'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: ${state.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRecordDialog({int? editIndex}) {
    final isEdit = editIndex != null;
    final initialItem = isEdit ? _records[editIndex] : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TrackRecordFormDialog(
        initialItem: initialItem,
        onSave: (item) {
          if (isEdit) {
            _editRecord(editIndex, item);
          } else {
            _addRecord(item);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(profileUpdateProvider);
    final isLoading = updateState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  if (_records.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Text(
                          'Belum ada track record.\nSilakan tambah pengalaman Anda.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyText.copyWith(
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_records.length, (i) {
                      final isLast = i == _records.length - 1;
                      return _TimelineItem(
                        item: _records[i],
                        isLast: isLast,
                        onEdit: () => _showRecordDialog(editIndex: i),
                        onDelete: () => _deleteRecord(i),
                      );
                    }),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          _buildActionButtons(context, isLoading),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Track Record',
        style: AppTypography.headerTitle.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.show_chart_rounded,
              color: AppColors.goldDark,
              size: 26,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Rekam Jejak Organisasi',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 22,
                  color: AppColors.primary900,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Kelola riwayat kepemimpinan dan pencapaian Anda untuk meningkatkan kepercayaan pemilih.',
          style: AppTypography.bodyText.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLoading) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => _showRecordDialog(),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'Tambah Rekam Jejak',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary900,
                  side: const BorderSide(color: AppColors.primary900),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _saveToDatabase,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined, size: 18),
                label: Text(
                  isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────── Timeline Item Widget ─────────────────────────────────

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.item,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  final _TrackRecordItem item;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 22),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.goldDark,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: AppColors.goldDark.withValues(alpha: 0.30),
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.dateRange,
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.goldDark,
                              fontSize: 10,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onEdit,
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit_outlined,
                              color: AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onDelete,
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: AppTypography.displayHeading.copyWith(
                        fontSize: 18,
                        color: AppColors.primary900,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: AppTypography.bodyText.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: AppTypography.captionBold.copyWith(
                                color: AppColors.goldDark,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Dialog Form ──────────────────────────────────────────────

class _TrackRecordFormDialog extends StatefulWidget {
  final _TrackRecordItem? initialItem;
  final ValueChanged<_TrackRecordItem> onSave;

  const _TrackRecordFormDialog({this.initialItem, required this.onSave});

  @override
  State<_TrackRecordFormDialog> createState() => _TrackRecordFormDialogState();
}

class _TrackRecordFormDialogState extends State<_TrackRecordFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _descController;
  late TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialItem?.title);
    _dateController = TextEditingController(text: widget.initialItem?.dateRange);
    _descController = TextEditingController(text: widget.initialItem?.description);
    _tagsController = TextEditingController(
      text: widget.initialItem?.tags.join(', '),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final date = _dateController.text.trim();
    final desc = _descController.text.trim();
    final tagsRaw = _tagsController.text.trim();

    if (title.isEmpty || date.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, Tanggal, dan Deskripsi wajib diisi')),
      );
      return;
    }

    final tags = tagsRaw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    widget.onSave(_TrackRecordItem(
      dateRange: date,
      title: title,
      description: desc,
      tags: tags,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialItem == null
                    ? 'Tambah Track Record'
                    : 'Edit Track Record',
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Judul (ex: Ketua Himpunan)', _titleController),
              const SizedBox(height: 12),
              _buildTextField('Waktu (ex: 2023 - Sekarang)', _dateController),
              const SizedBox(height: 12),
              _buildTextField('Deskripsi', _descController, maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField('Tags (pisahkan dengan koma)', _tagsController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
