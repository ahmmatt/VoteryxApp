import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class MyElectionProposalsScreen extends StatelessWidget {
  const MyElectionProposalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Usulan Pemilihan Saya', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Monitor Usulan',
              style: AppTypography.displayHeading.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'Status real-time untuk proposal pemilihan aktif Anda.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            _buildReviewCard(),
            const SizedBox(height: AppSpacing.lg),
            
            _buildApprovedCard(),
            const SizedBox(height: AppSpacing.lg),
            
            _buildRejectedCard(),
            const SizedBox(height: AppSpacing.xxl),
            
            // New Proposal Button
            _buildNewProposalButton(context),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProposalButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary800.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed('proposal-create');
          },
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ajukan Pemilihan Baru',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6EE), // Light cream/yellowish background
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.warningAmber,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Direview',
                  style: AppTypography.captionBold.copyWith(color: AppColors.textPrimary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Pemilihan Ketua HIMA TI 2026',
            style: AppTypography.screenTitle.copyWith(fontSize: 18, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Diajukan pada 14 Okt 2025',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Action Button
          Container(
            width: double.infinity,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF4C464), // Yellowish button
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lacak Detail',
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Custom Stepper
          _buildCustomStepper(),
        ],
      ),
    );
  }

  Widget _buildCustomStepper() {
    return Column(
      children: [
        Row(
          children: [
            _buildStepperDot(active: true, past: true, color: const Color(0xFF28B498)),
            _buildStepperLine(active: true, color: AppColors.warningAmber),
            _buildStepperDot(active: true, past: false, color: AppColors.warningAmber, isLarge: true),
            _buildStepperLine(active: false, color: const Color(0xFFE5E7EB)),
            _buildStepperDot(active: false, past: false, color: const Color(0xFFE5E7EB)),
            _buildStepperLine(active: false, color: const Color(0xFFE5E7EB)),
            _buildStepperDot(active: false, past: false, color: const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Diajukan', textAlign: TextAlign.center, style: AppTypography.captionBold.copyWith(fontSize: 10, color: const Color(0xFF28B498)))),
            Expanded(child: Text('Review Admin', textAlign: TextAlign.center, style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.warningAmber))),
            Expanded(child: Text('Disetujui', textAlign: TextAlign.center, style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.outline))),
            Expanded(child: Text('Live', textAlign: TextAlign.center, style: AppTypography.captionBold.copyWith(fontSize: 10, color: AppColors.outline))),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperDot({required bool active, required bool past, required Color color, bool isLarge = false}) {
    double size = isLarge ? 16.0 : 12.0;
    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.2) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Expanded _buildStepperLine({required bool active, required Color color}) {
    return Expanded(
      child: Container(
        height: 3,
        color: color,
      ),
    );
  }

  Widget _buildApprovedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFF0D695), width: 1.5), // Yellowish border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F2),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: const Color(0xFFB5E3D8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 12, color: Color(0xFF139971)),
                    const SizedBox(width: 4),
                    Text(
                      'Disetujui',
                      style: AppTypography.captionBold.copyWith(color: const Color(0xFF139971), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                'ID: VTX-8821',
                style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Pemilihan Ketua BEM FE 2026',
            style: AppTypography.screenTitle.copyWith(fontSize: 18, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Warning box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              border: Border(
                left: BorderSide(color: AppColors.warningAmber, width: 3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warningAmber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '2 dari 3 kandidat belum melengkapi profil',
                    style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kelengkapan Kandidat', style: AppTypography.captionBold.copyWith(color: AppColors.textPrimary)),
              Text('33%', style: AppTypography.captionBold.copyWith(color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F9),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.33,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4C464),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Button
          Container(
            width: double.infinity,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: const Color(0xFFF4C464)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lihat Detail Kandidat',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.people_outline, color: AppColors.textPrimary, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Link
          Center(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Kelola Jadwal',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Very light grey
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5), style: BorderStyle.solid), // In real app, dashed border can be implemented via custom package, fallback to solid.
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE8E8),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel_outlined, size: 12, color: AppColors.errorRed),
                const SizedBox(width: 4),
                Text(
                  'Ditolak',
                  style: AppTypography.captionBold.copyWith(color: AppColors.errorRed, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Pemilihan Ketua Senat FH',
            style: AppTypography.screenTitle.copyWith(fontSize: 18, height: 1.3, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Reason Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE8E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Alasan: Periode pemilihan bertabrakan dengan jadwal kalender akademik (Libur Semester Ganjil). Silakan sesuaikan tanggal pelaksanaan.',
              style: AppTypography.captionBold.copyWith(color: AppColors.errorRed, height: 1.4),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Button Ajukan Ulang
          Container(
            width: double.infinity,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary800,
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Ajukan Ulang',
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Button Banding
          Container(
            width: double.infinity,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: Center(
                  child: Text(
                    'Banding',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
