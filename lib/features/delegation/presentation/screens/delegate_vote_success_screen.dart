import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateVoteSuccessScreen extends StatelessWidget {
  const DelegateVoteSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Delegate Portal', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              // Success Badge
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.goldMid,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.goldMid.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.how_to_vote, color: Colors.white, size: 48),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(10, -5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary900,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text('×47', style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Text('47 Suara Berhasil Dikunci!', style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
              const SizedBox(height: 8),
              Text(
                'Eksekusi mandat anda telah tercatat permanen\ndi sistem.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              
              // Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('BUKTI EKSEKUSI DELEGATE', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('BATCH ID: #VOTE-DELEG-9921-X', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                          const SizedBox(width: 8),
                          const Icon(Icons.content_copy, size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.outlineVariant),
                    const SizedBox(height: 24),
                    
                    _buildReceiptRow('Waktu', '14 Okt 2023, 14:22 WIB'),
                    const SizedBox(height: 16),
                    _buildReceiptRow('Pemilihan', 'Ketua BEM UI 2024'),
                    const SizedBox(height: 16),
                    _buildReceiptRowWithBadge('Dieksekusi sebagai', 'Ahmad Rizki', 'DELEGATE'),
                    const SizedBox(height: 16),
                    _buildReceiptRow('Bobot Dieksekusi', '47 Suara', valueColor: AppColors.goldDark),
                    const SizedBox(height: 16),
                    _buildReceiptRow('Mandator', '12 Orang'),
                    const SizedBox(height: 24),
                    
                    // Detail Mandator Utama
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DETAIL MANDATOR UTAMA', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.0)),
                          const SizedBox(height: 16),
                          _buildMandatorItem('Siti Rahmawati', 'https://i.pravatar.cc/150?img=5'),
                          const SizedBox(height: 12),
                          _buildMandatorItem('Budi Santoso', 'https://i.pravatar.cc/150?img=11'),
                          const SizedBox(height: 12),
                          _buildMandatorItem('Rizal Pratama', 'https://i.pravatar.cc/150?img=12'),
                          const SizedBox(height: 16),
                          const Divider(color: AppColors.outlineVariant),
                          const SizedBox(height: 16),
                          Center(
                            child: Text('+9 mandator lainnya', style: AppTypography.captionBold.copyWith(color: AppColors.primary900)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // QR Code mock
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.qr_code_2, size: 80, color: AppColors.primary900.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Scan untuk memvalidasi', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDEBB2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.goldDark, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kandidat yang dipilih tetap dirahasiakan oleh sistem enkripsi Civic Glass. Riwayat ini hanya mencatat bahwa suara telah sukses dieksekusi.',
                        style: AppTypography.caption.copyWith(color: AppColors.goldDark, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldMid,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Simpan Bukti Eksekusi ke Galeri', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    context.pushNamed('delegate-history');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary900,
                    side: const BorderSide(color: AppColors.primary900),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  ),
                  child: Text('Kembali ke Dashboard', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor ?? AppColors.primary900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRowWithBadge(String label, String value, String badge) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge, style: AppTypography.captionBold.copyWith(color: Colors.white, fontSize: 9)),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMandatorItem(String name, String imageUrl) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(name, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.w600)),
        ),
        Text('Verified', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
      ],
    );
  }
}
