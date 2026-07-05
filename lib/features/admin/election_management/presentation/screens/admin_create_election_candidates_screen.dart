import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/constants/app_radius.dart';

class AdminCreateElectionCandidatesScreen extends StatelessWidget {
  const AdminCreateElectionCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Buat Pemilihan Baru', style: AppTypography.headerTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Daftar Kandidat', style: AppTypography.displayHeading.copyWith(fontSize: 22, color: AppColors.primary900)),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan nama dan NIM calon kandidat. Mereka akan menerima notifikasi untuk melengkapi profil setelah usulan disetujui.',
                    style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.navy600.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, color: AppColors.primary900, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Sistem pemilihan memerlukan minimal 2 kandidat terverifikasi untuk melanjutkan ke tahap peninjauan.',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Kandidat 1 (Valid)
                  _buildCandidateForm(
                    index: 1,
                    nama: 'Arjuna Pratama',
                    nim: '2021001234',
                    status: 'NIM terverifikasi',
                    statusColor: AppColors.successTeal,
                    statusIcon: Icons.check_circle,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Kandidat 2 (Invalid)
                  _buildCandidateForm(
                    index: 2,
                    nama: 'Joko Susilo',
                    nim: '2019998877',
                    status: 'NIM tidak ditemukan',
                    statusColor: Colors.red,
                    statusIcon: Icons.error,
                    hasError: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Kandidat 3 (Empty)
                  _buildCandidateForm(
                    index: 3,
                    nama: '',
                    nim: '',
                    isEmpty: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Tambah Kandidat Lain button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.navy600.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      // Mocking dashed border with a solid border for simplicity in placeholder, 
                      // in a real app we'd use a package like dotted_border.
                      border: Border.all(color: AppColors.outlineVariant, width: 1, style: BorderStyle.solid), 
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, color: AppColors.primary900, size: 20),
                          const SizedBox(width: 8),
                          Text('Tambah Kandidat Lain', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepNode(isActive: true, isCheck: true, label: ''),
          _buildStepLine(isActive: true),
          _buildStepNode(isActive: true, isCheck: true, label: ''),
          _buildStepLine(isActive: false),
          _buildStepNode(isActive: false, isCheck: false, label: '3'),
        ],
      ),
    );
  }

  Widget _buildStepNode({required bool isActive, required bool isCheck, required String label}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.goldMid : AppColors.background,
        shape: BoxShape.circle,
        border: Border.all(color: isActive ? AppColors.goldMid : AppColors.outlineVariant),
      ),
      child: Center(
        child: isCheck
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? AppColors.goldMid : AppColors.outlineVariant,
      ),
    );
  }

  Widget _buildCandidateForm({
    required int index,
    required String nama,
    required String nim,
    String? status,
    Color? statusColor,
    IconData? statusIcon,
    bool isEmpty = false,
    bool hasError = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: isEmpty 
            ? Border.all(color: AppColors.outlineVariant.withOpacity(0.5)) // Should be dashed in reality
            : Border.all(color: hasError ? Colors.red.withOpacity(0.5) : AppColors.outlineVariant.withOpacity(0.2)),
        boxShadow: isEmpty ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KANDIDAT $index', style: AppTypography.captionBold.copyWith(color: isEmpty ? AppColors.outlineVariant : AppColors.textSecondary, letterSpacing: 1.0)),
              Icon(Icons.delete_outline, color: isEmpty ? AppColors.outlineVariant : Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text('NAMA LENGKAP', style: AppTypography.captionBold.copyWith(color: isEmpty ? AppColors.outlineVariant : AppColors.textSecondary, fontSize: 10)),
          const SizedBox(height: 8),
          _buildTextField(initialValue: nama, hint: '', isEmpty: isEmpty),
          
          const SizedBox(height: 16),
          Text('NOMOR INDUK MAHASISWA (NIM)', style: AppTypography.captionBold.copyWith(color: isEmpty ? AppColors.outlineVariant : AppColors.textSecondary, fontSize: 10)),
          const SizedBox(height: 8),
          _buildTextField(initialValue: nim, hint: '', isEmpty: isEmpty, isError: hasError),
          
          if (status != null && statusColor != null && statusIcon != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 14),
                const SizedBox(width: 6),
                Text(status, style: AppTypography.captionBold.copyWith(color: statusColor)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTextField({required String initialValue, required String hint, bool isEmpty = false, bool isError = false}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: !isEmpty,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isEmpty ? AppColors.background : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isError ? Colors.red : AppColors.outlineVariant.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isError ? Colors.red : AppColors.outlineVariant.withOpacity(0.5)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            TextButton(
              onPressed: () => context.pop(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: AppColors.primary900, size: 18),
                  const SizedBox(width: 8),
                  Text('Kembali', style: AppTypography.bodyMedium.copyWith(color: AppColors.primary900, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('admin-create-review');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldMid,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Row(
                children: [
                  Text('Lanjut: Review', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
