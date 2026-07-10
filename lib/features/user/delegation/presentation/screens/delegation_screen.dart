// lib/features/user/delegation/presentation/screens/delegation_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/utils/app_snackbar.dart';
import 'package:voteryxapp/core/widgets/gold_button.dart';

import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';
import 'package:voteryxapp/features/user/delegation/presentation/providers/delegation_provider.dart';
import 'package:voteryxapp/features/user/election/presentation/providers/election_provider.dart';

class DelegationScreen extends ConsumerStatefulWidget {
  const DelegationScreen({super.key});

  @override
  ConsumerState<DelegationScreen> createState() => _DelegationScreenState();
}

class _DelegationScreenState extends ConsumerState<DelegationScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final delegatesAsync = ref.watch(publicDelegatesProvider);

    // Listen untuk delegasi action
    ref.listen<DelegationActionState>(delegationActionProvider, (_, next) {
      if (next.error != null) {
        AppSnackBar.showError(context, next.error!);
        ref.read(delegationActionProvider.notifier).clearError();
      }
      if (next.isSuccess) {
        AppSnackBar.showSuccess(
          context,
          'Suaramu berhasil didelegasikan ke ${next.selectedDelegateName}!',
        );
        ref.invalidate(dashboardProvider);
        ref.read(delegationActionProvider.notifier).reset();
      }
    });

    return ColoredBox(
      color: AppColors.background,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            backgroundColor: AppColors.primary800,
            expandedHeight: kToolbarHeight,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Text(
              'Delegasi Suara',
              style: AppTypography.headerTitle.copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => ref.invalidate(publicDelegatesProvider),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // Hero info card
                  _buildHeroCard(),

                  const SizedBox(height: AppSpacing.xl),

                  // Search bar
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v.toLowerCase().trim()),
                    decoration: InputDecoration(
                      hintText: 'Cari delegate...',
                      hintStyle: AppTypography.bodyText.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.outlineVariant),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'DAFTAR DELEGATE',
                    style: AppTypography.captionBold.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Delegate list
                  delegatesAsync.when(
                    data: (delegates) {
                      final filtered = delegates
                          .where((d) =>
                              _searchQuery.isEmpty ||
                              d.fullName
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              (d.faculty ?? '')
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              (d.specialization ?? '')
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              (d.delegateBio ?? '')
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              (d.delegateVision ?? '')
                                  .toLowerCase()
                                  .contains(_searchQuery))
                          .toList();

                      if (filtered.isEmpty) {
                        return _EmptyDelegateState(searchQuery: _searchQuery);
                      }

                      return Column(
                        children: filtered
                            .map((d) => _DelegateCard(
                                  delegate: d,
                                  onDelegate: () =>
                                      _showDelegateConfirmation(context, d),
                                  onDetailTap: () {
                                    context.pushNamed(
                                      'user-delegate-detail',
                                      pathParameters: {'delegateId': d.id},
                                    );
                                  },
                                ))
                            .toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xxl),
                        child: CircularProgressIndicator(color: AppColors.goldMid),
                      ),
                    ),
                    error: (err, _) => _ErrorState(
                      onRetry: () => ref.invalidate(publicDelegatesProvider),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.delegateGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.transfer_within_a_station_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'LIQUID DEMOCRACY',
                style: AppTypography.captionBold.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Delegasikan Suaramu\nke Pakar Terpercaya',
            style: AppTypography.displayHeading.copyWith(
              color: Colors.white,
              fontSize: 20,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pilih delegate yang kamu percaya untuk mewakili suaramu. Delegasi dapat dicabut selama pemilihan masih berlangsung.',
            style: AppTypography.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDelegateConfirmation(BuildContext context, Delegate delegate) {
    ref.read(delegationActionProvider.notifier).selectDelegate(
          delegateId: delegate.id,
          delegateName: delegate.fullName,
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DelegationConfirmModal(
        delegate: delegate,
        onConfirm: (electionId) {
          Navigator.pop(context);
          ref.read(delegationActionProvider.notifier).createDelegation(
                electionId: electionId,
              );
        },
      ),
    );
  }
}

class _DelegateCard extends StatelessWidget {
  const _DelegateCard({
    required this.delegate,
    required this.onDelegate,
    required this.onDetailTap,
  });

  final Delegate delegate;
  final VoidCallback onDelegate;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = delegate.photoUrl != null && delegate.photoUrl!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──────────────────────────────────
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.navyMid,
            backgroundImage: hasPhoto ? NetworkImage(delegate.photoUrl!) : null,
            onBackgroundImageError: hasPhoto
                ? (_, __) {}
                : null,
            child: !hasPhoto
                ? Text(
                    delegate.initials,
                    style: AppTypography.headerTitle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),

          // ── Info ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delegate.fullName,
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                ),
                if (delegate.faculty != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    delegate.faculty!,
                    style: AppTypography.bodyText.copyWith(fontSize: 12),
                  ),
                ],
                if (delegate.delegateBio != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    delegate.delegateBio!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyText.copyWith(fontSize: 11, height: 1.4),
                  ),
                ],
                const SizedBox(height: 8),
                // Trust score row
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.goldMid, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      delegate.trustScore.toStringAsFixed(1),
                      style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Action row: Lihat Detail | Delegasikan
                Row(
                  children: [
                    GestureDetector(
                      onTap: onDetailTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat Detail',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.primary800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward, size: 13, color: AppColors.primary800),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onDelegate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.delegateGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Delegasikan',
                              style: AppTypography.captionBold.copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DelegationConfirmModal extends StatefulWidget {
  const _DelegationConfirmModal({
    required this.delegate,
    required this.onConfirm,
  });

  final Delegate delegate;
  final void Function(String electionId) onConfirm;

  @override
  State<_DelegationConfirmModal> createState() =>
      _DelegationConfirmModalState();
}

class _DelegationConfirmModalState extends State<_DelegationConfirmModal> {
  // Untuk saat ini, minta user ketik election ID secara manual.
  // Idealnya ini di-inject dari halaman detail pemilihan.
  final _electionController = TextEditingController();

  @override
  void dispose() {
    _electionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            'Konfirmasi Delegasi',
            style: AppTypography.cardTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: AppTypography.bodyText,
              children: [
                const TextSpan(text: 'Kamu akan mendelegasikan suaramu kepada '),
                TextSpan(
                  text: widget.delegate.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary900,
                  ),
                ),
                const TextSpan(text: '. Tindakan ini dapat dicabut selama pemilihan masih berlangsung.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            'ID PEMILIHAN',
            style: AppTypography.captionBold.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _electionController,
            decoration: InputDecoration(
              hintText: 'Masukkan ID pemilihan',
              hintStyle: AppTypography.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          GoldButton(
            label: 'Konfirmasi Delegasi',
            icon: Icons.check_circle_outline,
            onPressed: () {
              final id = _electionController.text.trim();
              if (id.isEmpty) return;
              widget.onConfirm(id);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
            child: Text(
              'Batal',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDelegateState extends StatelessWidget {
  const _EmptyDelegateState({this.searchQuery});
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final isSearching = searchQuery != null && searchQuery!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.groups_outlined,
            size: 56,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isSearching ? 'Delegate Tidak Ditemukan' : 'Belum Ada Delegate Tersedia',
            style: AppTypography.cardTitle.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isSearching
                ? 'Tidak ada delegate yang cocok dengan kata kunci "$searchQuery".'
                : 'Delegate akan muncul ketika ada user yang mengaktifkan profil publik mereka.',
            style: AppTypography.bodyText.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.errorRed),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Gagal Memuat Delegate',
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Coba Lagi',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark),
            ),
          ),
        ],
      ),
    );
  }
}
