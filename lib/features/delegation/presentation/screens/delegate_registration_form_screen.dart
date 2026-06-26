import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateRegistrationFormScreen extends StatelessWidget {
  const DelegateRegistrationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Pendaftaran Delegasi', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Tambahan', style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
              const SizedBox(height: 8),
              Text(
                'Lengkapi profil Anda untuk memberikan konteks lebih mendalam bagi proses seleksi delegasi mahasiswa tahun ini.',
                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown
                    Text('Bidang Keahlian (Expertise)', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Pilih Bidang Keahlian Utama', style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary)),
                          items: const [],
                          onChanged: (val) {},
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Bio
                    Text('Latar Belakang / Bio', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Ceritakan pengalaman organisasi, visi Anda, dan mengapa Anda layak menjadi delegasi...',
                          hintStyle: AppTypography.bodyText.copyWith(color: const Color(0xFFD1D5DB)), // Light gray hint
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('MAKSIMUM 500 KATA', style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.outline)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Portofolio
                    Text('Link Portofolio / LinkedIn', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineVariant),
                        borderRadius: BorderRadius.circular(AppRadius.input),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'https://linkedin.com/in/username',
                          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
                          prefixIcon: const Icon(Icons.link, color: AppColors.textSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Checkbox declaration
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: false,
                            onChanged: (v) {},
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Saya menyatakan bahwa semua informasi yang diberikan adalah benar dan bersedia mengikuti seluruh rangkaian seleksi secara transparan.',
                            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFE5B540), Color(0xFF9E7719)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.pushNamed('delegate-review');
                          },
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('KIRIM PENGAJUAN', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                             const SizedBox(width: 8),
                             const Icon(Icons.send, color: Colors.white, size: 18),
                           ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Bottom Progress Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.75, // Tahap 3/4
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD54F), Color(0xFFF57F17)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('TAHAP 3/4', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark)),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
