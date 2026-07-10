// lib/features/admin/election_management/presentation/screens/admin_create_election_candidates_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import 'package:voteryxapp/features/user/election_proposal/domain/entities/election_proposal.dart';
import 'package:voteryxapp/features/user/election_proposal/presentation/providers/election_proposal_provider.dart';

class AdminCreateElectionCandidatesScreen extends ConsumerStatefulWidget {
  const AdminCreateElectionCandidatesScreen({super.key});

  @override
  ConsumerState<AdminCreateElectionCandidatesScreen> createState() =>
      _AdminCreateElectionCandidatesScreenState();
}

class _AdminCreateElectionCandidatesScreenState
    extends ConsumerState<AdminCreateElectionCandidatesScreen> {
  final _searchController = TextEditingController();
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(candidateSearchQueryProvider.notifier).state = value;
    setState(() => _showResults = value.trim().length >= 2);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(proposalDraftProvider);
    final selectedCandidates = draft.selectedCandidates;
    final searchResults = ref.watch(candidateSearchResultsProvider);

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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStepper(),
                  const SizedBox(height: AppSpacing.xxl),

                  Text('Daftar Kandidat',
                      style: AppTypography.displayHeading
                          .copyWith(fontSize: 22, color: AppColors.primary900)),
                  const SizedBox(height: 8),
                  Text(
                    'Cari kandidat berdasarkan nama atau NIM. Kandidat yang diajukan akan menerima notifikasi untuk melengkapi berkas mereka.',
                    style: AppTypography.bodyText
                        .copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.navy600.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.navy600.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary900, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Minimal 2 kandidat diperlukan. Kandidat yang ditambahkan akan mendapat notifikasi wajib melengkapi berkas.',
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary900,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.sm),

                  // Search Results Dropdown
                  if (_showResults) _buildSearchResults(searchResults, selectedCandidates),

                  const SizedBox(height: AppSpacing.xl),

                  // Daftar Kandidat Terpilih
                  if (selectedCandidates.isNotEmpty) ...[
                    Row(
                      children: [
                        Text('Kandidat Terpilih',
                            style: AppTypography.captionBold
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${selectedCandidates.length}',
                            style: AppTypography.captionBold
                                .copyWith(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...selectedCandidates.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final c = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _buildSelectedCandidateCard(c, idx + 1),
                      );
                    }),
                  ] else
                    _buildEmptyCandidateState(),
                ],
              ),
            ),
          ),

          // Bottom Nav Buttons
          _buildBottomBar(selectedCandidates.length),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: AppTypography.bodyText
            .copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan nama atau NIM...',
          hintStyle: AppTypography.bodyText
              .copyWith(color: AppColors.textSecondary),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.primary800, size: 22),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18,
                      color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    AsyncValue<List<ProposalCandidate>> searchResults,
    List<ProposalCandidate> selected,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: searchResults.when(
        data: (results) {
          if (results.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(Icons.person_search, color: AppColors.textSecondary.withOpacity(0.5), size: 20),
                  const SizedBox(width: 12),
                  Text('Tidak ada user ditemukan.',
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
                Divider(height: 1, color: AppColors.outlineVariant),
            itemBuilder: (context, i) {
              final c = results[i];
              final isAlreadyAdded = selected.any((s) => s.userId == c.userId);
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
                trailing: isAlreadyAdded
                    ? const Icon(Icons.check_circle,
                        color: AppColors.successTeal, size: 20)
                    : IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.primary800, size: 22),
                        onPressed: () {
                          ref
                              .read(proposalDraftProvider.notifier)
                              .addCandidate(c);
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      ),
                onTap: isAlreadyAdded
                    ? null
                    : () {
                        ref
                            .read(proposalDraftProvider.notifier)
                            .addCandidate(c);
                        _searchController.clear();
                        _onSearchChanged('');
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
              style:
                  AppTypography.caption.copyWith(color: AppColors.errorRed)),
        ),
      ),
    );
  }

  Widget _buildSelectedCandidateCard(ProposalCandidate c, int index) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary800,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: AppTypography.captionBold
                    .copyWith(color: Colors.white, fontSize: 13),
              ),
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
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          // Notif badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFFFFD166).withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.notifications_active_outlined,
                    size: 11, color: Color(0xFF856404)),
                const SizedBox(width: 4),
                Text('Akan Dinotif',
                    style: AppTypography.captionBold.copyWith(
                        fontSize: 9, color: const Color(0xFF856404))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.errorRed, size: 20),
            onPressed: () =>
                ref.read(proposalDraftProvider.notifier).removeCandidate(c.userId),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCandidateState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
            color: AppColors.outlineVariant, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.person_search,
              size: 48, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text('Belum ada kandidat',
              style: AppTypography.captionBold
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Gunakan kolom pencarian di atas untuk mencari dan menambahkan kandidat.',
              textAlign: TextAlign.center,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int candidateCount) {
    final isEnough = candidateCount >= 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.primary800),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button)),
              ),
              child: Text('Kembali',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.primary800)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isEnough
                  ? () => context.push('/proposal/review')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isEnough ? AppColors.primary800 : AppColors.outlineVariant,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnough
                        ? 'Lanjut Review ($candidateCount kandidat)'
                        : 'Min. 2 Kandidat',
                    style: AppTypography.bodyMedium.copyWith(
                        color: isEnough
                            ? Colors.white
                            : AppColors.textSecondary),
                  ),
                  if (isEnough) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep(1, isCompleted: true),
        _buildLine(isCompleted: true),
        _buildStep(2, isActive: true),
        _buildLine(),
        _buildStep(3),
      ],
    );
  }

  Widget _buildStep(int n, {bool isCompleted = false, bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.primary800
            : isActive
                ? AppColors.goldMid
                : AppColors.outlineVariant,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text('$n',
                style: AppTypography.captionBold.copyWith(
                    color: isActive ? AppColors.primary900 : Colors.white)),
      ),
    );
  }

  Widget _buildLine({bool isCompleted = false}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? AppColors.primary800 : AppColors.outlineVariant,
      ),
    );
  }
}
