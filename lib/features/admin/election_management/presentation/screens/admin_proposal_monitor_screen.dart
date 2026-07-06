import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminProposalMonitorScreen extends StatelessWidget {
  const AdminProposalMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Usulan Pemilihan', style: AppTypography.headerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monitor Usulan', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
            const SizedBox(height: 4),
            Text(
              'Status real-time untuk proposal pemilihan aktif Anda.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Card 1: Direview
            _buildReviewCard(),
            const SizedBox(height: AppSpacing.lg),
            
            // Card 2: Disetujui
            _buildApprovedCard(),
            const SizedBox(height: AppSpacing.lg),
            
            // Card 3: Ditolak
            _buildRejectedCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF9F0), Color(0xFFF4ECE1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.goldMid.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.goldMid, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('Direview', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('Pemilihan Ketua HIMA TI 2026', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text('Diajukan pada 14 Okt 2025', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldMid,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lacak Detail', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        Row(
          children: [
            _buildTimelineNode(isActive: true, isCurrent: false),
            _buildTimelineLine(isActive: true),
            _buildTimelineNode(isActive: true, isCurrent: true),
            _buildTimelineLine(isActive: false),
            _buildTimelineNode(isActive: false, isCurrent: false),
            _buildTimelineLine(isActive: false),
            _buildTimelineNode(isActive: false, isCurrent: false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Diajukan', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal, fontSize: 10)),
            Text('Review Admin', style: AppTypography.captionBold.copyWith(color: AppColors.goldMid, fontSize: 10)),
            Text('Disetujui', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            Text('Live', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineNode({required bool isActive, required bool isCurrent}) {
    Color color;
    if (isCurrent) {
      color = AppColors.goldMid;
    } else if (isActive) {
      color = AppColors.successTeal;
    } else {
      color = AppColors.outlineVariant;
    }
    
    return Container(
      width: isCurrent ? 16 : 12,
      height: isCurrent ? 16 : 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isCurrent ? Border.all(color: AppColors.goldMid.withOpacity(0.3), width: 4) : Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildTimelineLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 4,
        color: isActive ? AppColors.goldMid : AppColors.outlineVariant.withOpacity(0.3),
      ),
    );
  }

  Widget _buildApprovedCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.goldMid.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.successTeal.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.successTeal, size: 14),
                    const SizedBox(width: 6),
                    Text('Disetujui', style: AppTypography.captionBold.copyWith(color: AppColors.successTeal)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('ID: VTX-8821', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Pemilihan Ketua BEM FE 2026', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.primary900)),
          const SizedBox(height: 16),
          
          // Warning box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.goldDark, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '2 dari 3 kandidat belum melengkapi profil',
                    style: AppTypography.caption.copyWith(color: AppColors.primary900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kelengkapan Kandidat', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
              Text('33%', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.33,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.goldMid,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.goldMid.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lihat Detail Kandidat', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.people_alt_outlined, color: AppColors.primary900, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('Kelola Jadwal', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Uses background with dashed border visual
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          color: const Color(0xFFF7F8FC),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAEA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel_outlined, color: Colors.red, size: 14),
                    const SizedBox(width: 6),
                    Text('Ditolak', style: AppTypography.captionBold.copyWith(color: Colors.red)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Pemilihan Ketua Senat FH', style: AppTypography.displayHeading.copyWith(fontSize: 20, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              
              // Error reason box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAEA).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Text(
                  'Alasan: Periode pemilihan bertabrakan dengan jadwal kalender akademik (Libur Semester Ganjil). Silakan sesuaikan tanggal pelaksanaan.',
                  style: AppTypography.captionBold.copyWith(color: Colors.red, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Ajukan Ulang', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Banding', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
