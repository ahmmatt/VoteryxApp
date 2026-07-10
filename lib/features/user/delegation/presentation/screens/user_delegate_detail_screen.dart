import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/features/user/delegation/domain/entities/delegate.dart';
import 'package:voteryxapp/features/user/delegation/presentation/providers/delegation_provider.dart';

class UserDelegateDetailScreen extends ConsumerWidget {
  final String delegateId;
  const UserDelegateDetailScreen({super.key, required this.delegateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delegateAsync = ref.watch(delegateDetailProvider(delegateId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detail Delegator',
          style: AppTypography.headerTitle.copyWith(color: Colors.white),
        ),
      ),
      body: delegateAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goldMid),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                const SizedBox(height: 12),
                Text('Gagal memuat profil delegator', style: AppTypography.cardTitle),
                const SizedBox(height: 8),
                Text(e.toString(), style: AppTypography.caption, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        data: (delegate) {
          if (delegate == null) {
            return Center(child: Text('Delegator tidak ditemukan.', style: AppTypography.bodyText));
          }
          return _DelegateBody(delegate: delegate);
        },
      ),
    );
  }
}

class _DelegateBody extends StatelessWidget {
  final Delegate delegate;
  const _DelegateBody({required this.delegate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile Card ──────────────────────────────────────────
          _buildProfileCard(),
          const SizedBox(height: AppSpacing.xl),

          // ── Expertise ─────────────────────────────────────────────
          if (delegate.expertise != null && delegate.expertise!.isNotEmpty) ...[
            _buildSectionTitle(Icons.bolt_rounded, 'Bidang Keahlian'),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary800.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary800.withValues(alpha: 0.2)),
              ),
              child: Text(
                delegate.expertise!,
                style: AppTypography.captionBold.copyWith(color: AppColors.primary800),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Bio ───────────────────────────────────────────────────
          if ((delegate.bio ?? delegate.delegateBio) != null &&
              (delegate.bio ?? delegate.delegateBio)!.isNotEmpty) ...[
            _buildSectionTitle(Icons.person_outline, 'Bio'),
            const SizedBox(height: AppSpacing.sm),
            _buildCard(
              child: Text(
                (delegate.bio ?? delegate.delegateBio)!,
                style: AppTypography.bodyText.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Track Record ──────────────────────────────────────────
          if (delegate.trackRecord != null && delegate.trackRecord!.isNotEmpty) ...[
            _buildSectionTitle(Icons.show_chart, 'Track Record'),
            const SizedBox(height: AppSpacing.sm),
            _buildCard(
              child: Text(
                delegate.trackRecord!,
                style: AppTypography.bodyText.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ] else if (delegate.trackRecords.isNotEmpty) ...[
            // Fallback ke JSONB track records lama
            _buildSectionTitle(Icons.show_chart, 'Track Record'),
            const SizedBox(height: AppSpacing.sm),
            ...delegate.trackRecords.asMap().entries.map((entry) {
              final i = entry.key;
              final tr = entry.value;
              final isLast = i == delegate.trackRecords.length - 1;
              return _buildTimelineItem(
                year: tr['year']?.toString() ?? '',
                title: tr['title']?.toString() ?? '',
                description: tr['description']?.toString() ?? '',
                isLast: isLast,
              );
            }),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Portfolio URL ─────────────────────────────────────────
          if (delegate.portfolioUrl != null && delegate.portfolioUrl!.isNotEmpty) ...[
            _buildSectionTitle(Icons.link, 'Portofolio'),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: delegate.portfolioUrl!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('URL disalin ke clipboard!')),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.open_in_new, size: 18, color: AppColors.primary800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        delegate.portfolioUrl!,
                        style: AppTypography.bodyText.copyWith(
                          color: AppColors.primary800,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Visi Delegasi (dari kolom users) ──────────────────────
          if (delegate.delegateVision != null && delegate.delegateVision!.isNotEmpty) ...[
            _buildSectionTitle(Icons.remove_red_eye_outlined, 'Visi Delegasi'),
            const SizedBox(height: AppSpacing.sm),
            _buildCard(
              child: Text(delegate.delegateVision!, style: AppTypography.bodyText.copyWith(height: 1.5)),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // ── Pesan jika semua kosong ───────────────────────────────
          if ((delegate.expertise == null || delegate.expertise!.isEmpty) &&
              (delegate.bio == null || delegate.bio!.isEmpty) &&
              (delegate.delegateBio == null || delegate.delegateBio!.isEmpty) &&
              (delegate.trackRecord == null || delegate.trackRecord!.isEmpty) &&
              delegate.trackRecords.isEmpty &&
              (delegate.portfolioUrl == null || delegate.portfolioUrl!.isEmpty) &&
              (delegate.delegateVision == null || delegate.delegateVision!.isEmpty)) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Delegator ini belum mengisi profil delegasinya.',
                      style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final hasPhoto = delegate.photoUrl != null && delegate.photoUrl!.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [BoxShadow(color: Color(0x080F1F3D), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.navyMid,
            backgroundImage: hasPhoto ? NetworkImage(delegate.photoUrl!) : null,
            onBackgroundImageError: hasPhoto ? (_, __) {} : null,
            child: !hasPhoto
                ? Text(
                    delegate.initials,
                    style: AppTypography.headerTitle.copyWith(color: Colors.white, fontSize: 24),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delegate.fullName,
                  style: AppTypography.headerTitle.copyWith(fontSize: 18, color: AppColors.primary800),
                ),
                if (delegate.faculty != null) ...[
                  const SizedBox(height: 4),
                  Text(delegate.faculty!, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
                ],
                if (delegate.specialization != null) ...[
                  const SizedBox(height: 2),
                  Text(delegate.specialization!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
                if (delegate.nim != null && delegate.nim!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('NIM: ${delegate.nim!}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.goldMid, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Trust Score: ${delegate.trustScore.toStringAsFixed(1)}',
                      style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.navyMid, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTypography.cardTitle.copyWith(color: AppColors.navyMid)),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AppColors.navyMid,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.outlineVariant)),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (year.isNotEmpty)
                    Text(year, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  Text(title,
                      style: AppTypography.captionBold.copyWith(color: AppColors.primary800, fontSize: 13)),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(description,
                        style: AppTypography.bodyText
                            .copyWith(fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
