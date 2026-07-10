import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../user/election_proposal/domain/entities/election_proposal.dart';
import '../../../../user/election_proposal/presentation/providers/election_proposal_provider.dart';

class ProposalCreateScreen extends ConsumerStatefulWidget {
  const ProposalCreateScreen({super.key});

  @override
  ConsumerState<ProposalCreateScreen> createState() =>
      _ProposalCreateScreenState();
}

class _ProposalCreateScreenState extends ConsumerState<ProposalCreateScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // ── Step 1 Controllers ─────────────────────────────────────────────────────
  final _titleCtrl = TextEditingController();
  final _orgCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();
  final _votersCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _agreeCheck = false;

  // ── Step 1 form key ────────────────────────────────────────────────────────
  final _step1FormKey = GlobalKey<FormState>();

  // ── Step 2 Search ──────────────────────────────────────────────────────────
  final _searchCtrl = TextEditingController();
  bool _showSearchResults = false;

  @override
  void dispose() {
    _pageController.dispose();
    _titleCtrl.dispose();
    _orgCtrl.dispose();
    _purposeCtrl.dispose();
    _votersCtrl.dispose();
    _typeCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────────────

  bool _validateStep1() {
    if (_titleCtrl.text.trim().isEmpty) {
      _showError('Nama Pemilihan wajib diisi.');
      return false;
    }
    if (_typeCtrl.text.trim().isEmpty) {
      _showError('Jenis Pemilihan wajib diisi.');
      return false;
    }
    if (_orgCtrl.text.trim().isEmpty) {
      _showError('Lembaga / Organisasi wajib diisi.');
      return false;
    }
    if (_purposeCtrl.text.trim().isEmpty) {
      _showError('Tujuan Pengajuan wajib diisi.');
      return false;
    }
    if (_startDate == null || _endDate == null) {
      _showError('Periode usulan (Mulai & Selesai) wajib diisi.');
      return false;
    }
    if (_endDate!.isBefore(_startDate!)) {
      _showError('Tanggal Selesai harus setelah tanggal Mulai.');
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _goNext() {
    if (_currentStep == 0) {
      if (!_validateStep1()) return;
      // Sync ke provider draft
      ref.read(proposalDraftProvider.notifier)
        ..setTitle(_titleCtrl.text.trim())
        ..setElectionType(_typeCtrl.text.trim())
        ..setOrganization(_orgCtrl.text.trim())
        ..setPurpose(_purposeCtrl.text.trim())
        ..setStartDate(_startDate!)
        ..setEndDate(_endDate!);
      if (_votersCtrl.text.trim().isNotEmpty) {
        ref.read(proposalDraftProvider.notifier)
            .setEstimatedVoters(int.tryParse(_votersCtrl.text.trim()) ?? 0);
      }
    } else if (_currentStep == 1) {
      final candidates = ref.read(proposalDraftProvider).selectedCandidates;
      if (candidates.length < 2) {
        _showError('Minimal 2 kandidat harus ditambahkan.');
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goPrev() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Listen submit state
    ref.listen(proposalSubmitProvider, (prev, next) {
      if (next.isSuccess) {
        ref.read(proposalSubmitProvider.notifier).reset();
        context.goNamed('proposal-status');
      }
      if (next.error != null) {
        _showError(next.error!);
        ref.read(proposalSubmitProvider.notifier).clearError();
      }
    });

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
        title: Text('Ajukan Pemilihan Baru',
            style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step Indicator
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(0),
          _buildStepLine(isActive: _currentStep >= 1),
          _buildStepCircle(1),
          _buildStepLine(isActive: _currentStep >= 2),
          _buildStepCircle(2),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isActive = _currentStep == index;
    final isPast = _currentStep > index;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: (isActive || isPast) ? AppColors.goldDark : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: (isActive || isPast) ? AppColors.goldDark : AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: isPast
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : Text(
              '${index + 1}',
              style: AppTypography.captionBold.copyWith(
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      width: 40, height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? AppColors.goldDark : AppColors.outlineVariant,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STEP 1: Info Dasar
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('P1 — Info Dasar',
                style: AppTypography.displayHeading.copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              'Lengkapi semua kolom di bawah ini. Semua kolom wajib diisi sebelum lanjut ke tahap berikutnya.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Form Container
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Pemilihan
                  _label('Nama Pemilihan *'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: _titleCtrl,
                    hint: 'Contoh: Pemilihan Ketua HIMA TI 2026',
                    suffixIcon: Icons.edit_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Jenis Pemilihan
                  _label('Jenis Pemilihan *'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: _typeCtrl,
                    hint: 'Contoh: Pemilihan Umum, BEM, RT/RW, dll',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Organisasi
                  _label('Lembaga / Organisasi Pengusul *'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: _orgCtrl,
                    hint: 'Contoh: KPU, HIMA, Kelurahan, dll',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Tujuan
                  _label('Tujuan Pengajuan *'),
                  const SizedBox(height: 6),
                  _textAreaField(
                    controller: _purposeCtrl,
                    hint: 'Jelaskan tujuan pemilihan ini secara singkat...',
                    maxLength: 300,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Periode
                  _label('Periode Diusulkan *'),
                  const SizedBox(height: 6),
                  _datePicker(
                    label: 'MULAI',
                    value: _startDate,
                    onPick: (d) => setState(() => _startDate = d),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _datePicker(
                    label: 'SELESAI',
                    value: _endDate,
                    onPick: (d) => setState(() => _endDate = d),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Estimasi Pemilih (Opsional)
                  _label('Estimasi Jumlah Pemilih (Opsional)'),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.outlineVariant),
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _votersCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              hintText: 'Contoh: 1200',
                              hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text('orang',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            _primaryButton(label: 'Lanjut: Tambah Kandidat', onTap: _goNext),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTypography.captionBold);

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.outline, size: 18)
              : null,
        ),
      ),
    );
  }

  Widget _textAreaField({
    required TextEditingController controller,
    required String hint,
    int maxLength = 300,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _datePicker({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onPick,
  }) {
    final fmt = DateFormat('dd MMM yyyy');
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: value != null ? AppColors.primary800 : AppColors.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16,
                color: value != null ? AppColors.primary800 : AppColors.outline),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value != null ? fmt.format(value) : 'Pilih tanggal...',
                style: AppTypography.bodyText.copyWith(
                  color: value != null ? AppColors.textPrimary : AppColors.outline,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary800.withOpacity(0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(label,
                  style: AppTypography.captionBold
                      .copyWith(color: AppColors.primary800, fontSize: 9)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STEP 2: Kandidat — Search from Database
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildStep2() {
    final draft = ref.watch(proposalDraftProvider);
    final selectedCandidates = draft.selectedCandidates;
    final searchResults = ref.watch(candidateSearchResultsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daftar Kandidat',
              style: AppTypography.displayHeading.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            'Cari dan tambahkan kandidat berdasarkan nama atau NIM. Kandidat yang diajukan akan menerima notifikasi wajib melengkapi berkas.',
            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Info Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.navy600.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.navy600.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary800, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Minimal 2 kandidat wajib ditambahkan. Notifikasi akan dikirim kepada setiap kandidat untuk melengkapi berkas mereka.',
                    style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary800, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Search Bar ────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) {
                ref.read(candidateSearchQueryProvider.notifier).state = v;
                setState(() => _showSearchResults = v.trim().length >= 2);
              },
              style: AppTypography.bodyText.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama atau NIM...',
                hintStyle: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary800, size: 22),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(candidateSearchQueryProvider.notifier).state = '';
                          setState(() => _showSearchResults = false);
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Search Results ────────────────────────────────────────────
          if (_showSearchResults)
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: searchResults.when(
                data: (results) {
                  if (results.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Icon(Icons.person_search,
                              color: AppColors.textSecondary.withOpacity(0.5), size: 20),
                          const SizedBox(width: 12),
                          Text('User tidak ditemukan.',
                              style: AppTypography.bodyText
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: results.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.outlineVariant),
                    itemBuilder: (context, i) {
                      final c = results[i];
                      final isAdded = selectedCandidates.any((s) => s.userId == c.userId);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary800.withOpacity(0.1),
                          child: Text(
                            c.fullName.isNotEmpty ? c.fullName[0].toUpperCase() : '?',
                            style: AppTypography.captionBold
                                .copyWith(color: AppColors.primary800),
                          ),
                        ),
                        title: Text(c.fullName,
                            style: AppTypography.itemTitle.copyWith(fontSize: 14)),
                        subtitle: Text(
                          [
                            if (c.nikOrNim != null) 'NIM: ${c.nikOrNim}',
                            if (c.faculty != null) c.faculty!,
                          ].join(' • '),
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        trailing: isAdded
                            ? const Icon(Icons.check_circle,
                                color: AppColors.successTeal, size: 22)
                            : IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: AppColors.primary800, size: 24),
                                onPressed: () {
                                  ref
                                      .read(proposalDraftProvider.notifier)
                                      .addCandidate(c);
                                  _searchCtrl.clear();
                                  ref.read(candidateSearchQueryProvider.notifier).state = '';
                                  setState(() => _showSearchResults = false);
                                },
                              ),
                        onTap: isAdded
                            ? null
                            : () {
                                ref.read(proposalDraftProvider.notifier).addCandidate(c);
                                _searchCtrl.clear();
                                ref.read(candidateSearchQueryProvider.notifier).state = '';
                                setState(() => _showSearchResults = false);
                              },
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.goldMid, strokeWidth: 2)),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text('Gagal mencari: $e',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.errorRed)),
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          // ── Kandidat Terpilih ─────────────────────────────────────────
          if (selectedCandidates.isNotEmpty) ...[
            Row(
              children: [
                Text('Kandidat Dipilih',
                    style: AppTypography.captionBold
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${selectedCandidates.length}',
                      style: AppTypography.captionBold
                          .copyWith(color: Colors.white, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...selectedCandidates.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _selectedCandidateCard(e.value, e.key + 1),
                )),
          ] else
            _emptyState(),

          const SizedBox(height: AppSpacing.xxl),

          // ── Nav Buttons ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _goPrev,
                icon: const Icon(Icons.arrow_back, color: AppColors.primary800, size: 18),
                label: Text('Kembali',
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.w700, color: AppColors.primary800)),
              ),
              ElevatedButton.icon(
                onPressed: _goNext,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(
                  'Lanjut: Review${selectedCandidates.length >= 2 ? " (${selectedCandidates.length})" : ""}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCandidates.length >= 2
                      ? AppColors.goldDark
                      : AppColors.outlineVariant,
                  foregroundColor: selectedCandidates.length >= 2
                      ? Colors.white
                      : AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _selectedCandidateCard(ProposalCandidate c, int index) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: AppColors.primary800, shape: BoxShape.circle),
            child: Center(
              child: Text('$index',
                  style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.fullName, style: AppTypography.itemTitle),
                if (c.nikOrNim != null || c.faculty != null)
                  Text(
                    [
                      if (c.nikOrNim != null) 'NIM: ${c.nikOrNim}',
                      if (c.faculty != null) c.faculty!,
                    ].join(' • '),
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.notifications_active_outlined, size: 10, color: Color(0xFF856404)),
              const SizedBox(width: 3),
              Text('Dinotif', style: AppTypography.captionBold.copyWith(fontSize: 9, color: const Color(0xFF856404))),
            ]),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 20),
            onPressed: () => ref.read(proposalDraftProvider.notifier).removeCandidate(c.userId),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.person_search, size: 48, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text('Belum ada kandidat',
              style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            'Ketikkan nama atau NIM di kolom pencarian untuk menemukan dan menambahkan kandidat.',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STEP 3: Review & Submit
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildStep3() {
    final draft = ref.watch(proposalDraftProvider);
    final submitState = ref.watch(proposalSubmitProvider);
    final fmt = DateFormat('d MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePad),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Kirim',
              style: AppTypography.displayHeading.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text('Periksa kembali data usulan pemilihan sebelum dikirimkan ke admin.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),

          // Ringkasan Proposal
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.description_outlined, color: AppColors.primary800, size: 18),
                  const SizedBox(width: 8),
                  Text('Ringkasan Proposal', style: AppTypography.cardTitle),
                ]),
                const Divider(height: 20),
                _summaryRow('Nama Pemilihan', draft.title),
                _summaryRow('Jenis', draft.electionType),
                _summaryRow('Organisasi', draft.organization),
                _summaryRow('Tujuan', draft.purpose, maxLines: 3),
                if (draft.proposedStartDate != null && draft.proposedEndDate != null)
                  _summaryRow('Periode',
                      '${fmt.format(draft.proposedStartDate!)} — ${fmt.format(draft.proposedEndDate!)}'),
                if (draft.estimatedVoters != null && draft.estimatedVoters! > 0)
                  _summaryRow('Est. Pemilih', '${draft.estimatedVoters} orang'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Daftar Kandidat
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.people_outline, color: AppColors.primary800, size: 18),
                      const SizedBox(width: 8),
                      Text('Kandidat', style: AppTypography.cardTitle),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary800,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${draft.selectedCandidates.length} orang',
                          style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ),
                const Divider(height: 20),
                ...draft.selectedCandidates.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primary800.withOpacity(0.1),
                            child: Text(
                              '${e.key + 1}',
                              style: AppTypography.captionBold
                                  .copyWith(color: AppColors.primary800, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value.fullName, style: AppTypography.itemTitle),
                                if (e.value.nikOrNim != null)
                                  Text('NIM: ${e.value.nikOrNim}',
                                      style: AppTypography.caption
                                          .copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Info Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time_filled, color: Color(0xFF8D6E63), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Proposal Anda akan melalui tahap verifikasi teknis oleh tim admin dalam waktu 1-2 hari kerja. Kandidat juga akan segera mendapatkan notifikasi.',
                    style: AppTypography.caption.copyWith(color: const Color(0xFF4E342E), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Persetujuan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeCheck,
                onChanged: (v) => setState(() => _agreeCheck = v ?? false),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                activeColor: AppColors.primary800,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _agreeCheck = !_agreeCheck),
                  child: Text(
                    'Saya menyatakan bahwa data yang diberikan adalah benar dan telah disetujui oleh pimpinan lembaga yang berwenang.',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_agreeCheck && !submitState.isLoading)
                  ? () => ref.read(proposalSubmitProvider.notifier).submitProposal()
                  : null,
              icon: submitState.isLoading
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, size: 18),
              label: Text(submitState.isLoading ? 'Mengirim...' : 'Kirim Usulan',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _agreeCheck ? AppColors.primary800 : AppColors.outlineVariant,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton.icon(
              onPressed: _goPrev,
              icon: const Icon(Icons.arrow_back, color: AppColors.primary800, size: 14),
              label: Text('Edit Kandidat',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.primary800, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {int maxLines = 2}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: AppTypography.captionBold,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary800,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
        child: Text(label,
            style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
      ),
    );
  }
}
