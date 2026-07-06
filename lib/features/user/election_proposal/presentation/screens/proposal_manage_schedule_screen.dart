import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/gold_button.dart';

class ProposalManageScheduleScreen extends StatelessWidget {
  const ProposalManageScheduleScreen({super.key});

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
        title: Text('Kelola Jadwal', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.pageGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Timeline Pemilihan',
              style: AppTypography.displayHeading.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'Tetapkan tanggal penting untuk proses pemilihan ini.',
              style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateField(
                    label: 'Pendaftaran Kandidat',
                    hintText: 'Pilih rentang tanggal',
                    initialValue: '15 Okt 2025 - 20 Okt 2025',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  _buildDateField(
                    label: 'Masa Kampanye',
                    hintText: 'Pilih rentang tanggal',
                    initialValue: '22 Okt 2025 - 28 Okt 2025',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  _buildDateField(
                    label: 'Masa Tenang',
                    hintText: 'Pilih tanggal mulai',
                    initialValue: '29 Okt 2025 - 30 Okt 2025',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  _buildDateField(
                    label: 'Hari Pemilihan',
                    hintText: 'Pilih tanggal pemilihan',
                    initialValue: '31 Okt 2025',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            GoldButton(
              label: 'Simpan Jadwal',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jadwal berhasil disimpan')),
                );
                context.pop();
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({required String label, required String hintText, String? initialValue}) {
    return AppTextField(
      label: label.toUpperCase(),
      hint: hintText,
      readOnly: true,
      controller: TextEditingController(text: initialValue),
      suffixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary800, size: 20),
      onTap: () {
        // Placeholder for date picker
      },
    );
  }
}
