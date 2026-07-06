import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../application/delegate_application_provider.dart';

class DelegateRegistrationFormScreen extends ConsumerStatefulWidget {
  const DelegateRegistrationFormScreen({super.key});

  @override
  ConsumerState<DelegateRegistrationFormScreen> createState() => _DelegateRegistrationFormScreenState();
}

class _DelegateRegistrationFormScreenState extends ConsumerState<DelegateRegistrationFormScreen> {
  final _nameController = TextEditingController(text: 'Bima Pradana');
  final _bioController = TextEditingController();
  final _portfolioController = TextEditingController(text: 'https://linkedin.com/in/bima-pradana');
  final _nimController = TextEditingController(text: '221011088');
  String _expertise = 'Kebijakan Kampus';
  bool _isStudent = true;
  bool _acceptedDeclaration = false;

  static const _expertiseOptions = [
    'Kebijakan Kampus',
    'Akademik & Kurikulum',
    'Kesejahteraan Mahasiswa',
    'Teknologi & Data',
    'Lingkungan & Keberlanjutan',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _portfolioController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (!_acceptedDeclaration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Centang deklarasi kebenaran data terlebih dahulu.')),
      );
      return;
    }

    ref.read(delegateApplicationProvider.notifier).submit(
          name: _nameController.text,
          expertise: _expertise,
          bio: _bioController.text,
          portfolioUrl: _portfolioController.text,
          isStudent: _isStudent,
          nim: _nimController.text,
        );
    context.pushNamed('delegate-review');
  }

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Pendaftaran Delegasi', style: AppTypography.headerTitle),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Tambahan', style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
              const SizedBox(height: 8),
              Text(
                'Lengkapi profil dan status mahasiswa. Pengajuan akan masuk ke dashboard admin untuk proses approval.',
                style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Lengkap', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextField(controller: _nameController, hint: 'Nama sesuai data kampus', icon: Icons.badge_outlined),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Status Mahasiswa', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(AppRadius.input), border: Border.all(color: AppColors.outlineVariant)),
                      child: Row(
                        children: [
                          Expanded(child: _buildStatusOption('Mahasiswa Aktif', true)),
                          Expanded(child: _buildStatusOption('Non-Mahasiswa', false)),
                        ],
                      ),
                    ),
                    if (_isStudent) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text('NIM', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                      const SizedBox(height: AppSpacing.xs),
                      _buildTextField(controller: _nimController, hint: 'Contoh: 221011088', icon: Icons.school_outlined),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Text('Bidang Keahlian (Expertise)', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.outlineVariant), borderRadius: BorderRadius.circular(AppRadius.input)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _expertise,
                          isExpanded: true,
                          items: _expertiseOptions.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                          onChanged: (val) => setState(() => _expertise = val ?? _expertise),
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Latar Belakang / Bio', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextField(
                      controller: _bioController,
                      hint: 'Ceritakan pengalaman organisasi, visi, dan alasan Anda layak menjadi delegasi...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 6),
                    Align(alignment: Alignment.centerRight, child: Text('MAKSIMUM 500 KATA', style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.outline))),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Link Portofolio / LinkedIn', style: AppTypography.captionBold.copyWith(color: AppColors.navyMid)),
                    const SizedBox(height: AppSpacing.xs),
                    _buildTextField(controller: _portfolioController, hint: 'https://linkedin.com/in/username', icon: Icons.link),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _acceptedDeclaration,
                            onChanged: (v) => setState(() => _acceptedDeclaration = v ?? false),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Saya menyatakan bahwa semua informasi yang diberikan adalah benar dan bersedia diverifikasi oleh admin kampus.',
                            style: AppTypography.bodyText.copyWith(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildSubmitButton(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.75,
                        child: Container(
                          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFF57F17)]), borderRadius: BorderRadius.circular(2)),
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

  Widget _buildStatusOption(String label, bool value) {
    final selected = _isStudent == value;
    return InkWell(
      onTap: () => setState(() => _isStudent = value),
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary900 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Text(label, textAlign: TextAlign.center, style: AppTypography.captionBold.copyWith(color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, IconData? icon, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.outlineVariant), borderRadius: BorderRadius.circular(AppRadius.input)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outline),
          prefixIcon: icon == null ? null : Icon(icon, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE5B540), Color(0xFF9E7719)]), borderRadius: BorderRadius.circular(AppRadius.button)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _submitApplication,
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
    );
  }
}
