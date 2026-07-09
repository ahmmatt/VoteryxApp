import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../user/profile/presentation/providers/profile_provider.dart';
import '../../../../user/profile/presentation/screens/profile_settings_screen.dart';

class DelegateTermsScreen extends ConsumerStatefulWidget {
  const DelegateTermsScreen({super.key});

  @override
  ConsumerState<DelegateTermsScreen> createState() => _DelegateTermsScreenState();
}

class _DelegateTermsScreenState extends ConsumerState<DelegateTermsScreen> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.valueOrNull;

    final hasFullName = profile != null && profile.fullName.trim().isNotEmpty;
    final hasFaculty = profile != null && profile.faculty != null && profile.faculty!.trim().isNotEmpty;
    final hasMajor = profile != null && profile.major != null && profile.major!.trim().isNotEmpty;
    final isKycVerified = profile != null && profile.kycStatus == 'verified';

    final isProfileComplete = hasFullName && hasFaculty && hasMajor && isKycVerified;
    final canProceed = isProfileComplete && _acceptedTerms;

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
        title: Text('Syarat & Pakta Integritas', style: AppTypography.headerTitle),
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
              Text(
                'Langkah 1: Pakta Integritas & Data Diri',
                style: AppTypography.displayHeading.copyWith(
                  fontSize: 22,
                  color: AppColors.primary900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pastikan data diri Anda lengkap dan pelajari komitmen moral sebelum mendaftar sebagai delegasi publik.',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Kartu Verifikasi Data Diri
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isProfileComplete ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isProfileComplete ? Icons.verified : Icons.error_outline,
                          color: isProfileComplete ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Status Kelengkapan Data Diri',
                            style: AppTypography.cardTitle.copyWith(
                              color: AppColors.primary900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isProfileComplete
                                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isProfileComplete ? 'Lengkap' : 'Perlu Perhatian',
                            style: AppTypography.captionBold.copyWith(
                              color: isProfileComplete ? const Color(0xFF10B981) : const Color(0xFFD97706),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.outlineVariant),
                    const SizedBox(height: 12),
                    _buildDataCheckItem(
                      label: 'Nama Lengkap',
                      value: profile?.fullName ?? 'Belum terisi',
                      isComplete: hasFullName,
                    ),
                    const SizedBox(height: 8),
                    _buildDataCheckItem(
                      label: 'Fakultas / Unit',
                      value: profile?.faculty ?? 'Belum diisi (Diperlukan)',
                      isComplete: hasFaculty,
                    ),
                    const SizedBox(height: 8),
                    _buildDataCheckItem(
                      label: 'Jurusan / Keahlian',
                      value: profile?.major ?? 'Belum diisi (Diperlukan)',
                      isComplete: hasMajor,
                    ),
                    const SizedBox(height: 8),
                    _buildDataCheckItem(
                      label: 'Status Verifikasi KTP',
                      value: profile?.kycStatus == 'verified'
                          ? 'Terverifikasi'
                          : (profile?.kycStatus == 'pending' ? 'Sedang Diperiksa Admin' : 'Belum Terverifikasi'),
                      isComplete: isKycVerified,
                    ),
                    if (!isProfileComplete) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data diri yang lengkap dan valid sangat penting agar pengajuan delegasi Anda disetujui oleh Admin Kampus.',
                              style: AppTypography.bodyText.copyWith(
                                color: const Color(0xFF92400E),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileSettingsScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Lengkapi di Pengaturan Profil',
                                    style: AppTypography.captionBold.copyWith(
                                      color: const Color(0xFFD97706),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: Color(0xFFD97706),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Kartu Pakta Integritas
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gavel_rounded, color: AppColors.primary800, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Pakta Integritas Delegator',
                          style: AppTypography.cardTitle.copyWith(
                            color: AppColors.primary900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTermItem(
                      number: '1',
                      title: 'Representasi yang Jujur & Bertanggung Jawab',
                      description:
                          'Delegator berkewajiban menggunakan suara mandat dari pemilih secara bijak demi kepentingan dan kemajuan bersama.',
                    ),
                    const SizedBox(height: 14),
                    _buildTermItem(
                      number: '2',
                      title: 'Transparansi Visi & Profil',
                      description:
                          'Profil, bidang keahlian, visi, dan riwayat voting Anda sebagai delegasi akan bersifat publik agar pemilih dapat menilai rekam jejak Anda.',
                    ),
                    const SizedBox(height: 14),
                    _buildTermItem(
                      number: '3',
                      title: 'Independensi & Menolak Suap',
                      description:
                          'Delegator dilarang keras menerima suap, kompensasi finansial, atau menyalahgunakan bobot suara delegasi untuk keuntungan pribadi.',
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.outlineVariant),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _acceptedTerms,
                            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                            child: Text(
                              'Saya menyatakan setuju untuk mematuhi seluruh Syarat & Pakta Integritas Delegator di atas serta menyatakan bahwa data diri saya sudah akurat.',
                              style: AppTypography.bodyText.copyWith(
                                color: AppColors.primary900,
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Button Lanjut
              GestureDetector(
                onTap: () {
                  if (!isProfileComplete) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap lengkapi seluruh Status Kelengkapan Data Diri (Nama, Fakultas, Jurusan, dan KTP) terlebih dahulu melalui Pengaturan Profil.'),
                      ),
                    );
                    return;
                  }
                  if (!_acceptedTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap centang persetujuan Syarat & Pakta Integritas terlebih dahulu.'),
                      ),
                    );
                    return;
                  }
                  context.pushNamed('delegate-registration');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: canProceed
                        ? const LinearGradient(colors: [Color(0xFFF6C85F), Color(0xFFD9A028)])
                        : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade500]),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    boxShadow: canProceed
                        ? [
                            BoxShadow(
                              color: const Color(0xFFD9A028).withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjutkan Isi Formulir Portofolio',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Progress Bar (Tahap 1/3)
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
                        widthFactor: 0.33,
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
                  Text(
                    'TAHAP 1/3',
                    style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCheckItem({
    required String label,
    required String value,
    required bool isComplete,
  }) {
    return Row(
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isComplete ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodyText.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.captionBold.copyWith(
              color: isComplete ? AppColors.primary900 : const Color(0xFFD97706),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.primary800.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTypography.captionBold.copyWith(
                color: AppColors.primary800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.captionBold.copyWith(
                  color: AppColors.primary900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
