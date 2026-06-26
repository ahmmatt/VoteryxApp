import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_radius.dart';

class DelegateVoteExecutionScreen extends StatelessWidget {
  const DelegateVoteExecutionScreen({super.key});

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
        title: Text('Eksekusi Suara', style: AppTypography.headerTitle.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.pageGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Warning Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDEBB2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.goldMid, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_user, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kamu bertindak sebagai Delegate terverifikasi',
                        style: AppTypography.captionBold.copyWith(color: AppColors.goldDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Detail Bobot Suara
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DETAIL BOBOT SUARA', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Suara Milikmu', style: AppTypography.bodyText.copyWith(color: AppColors.primary900)),
                              Text('+1', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mandat Kolektif', style: AppTypography.bodyText.copyWith(color: AppColors.primary900)),
                                  const SizedBox(height: 2),
                                  Text('Siti, Budi, Rizal +9 lainnya', style: AppTypography.caption.copyWith(color: AppColors.outline)),
                                ],
                              ),
                              Text('+46', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3E7CA),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(AppRadius.card), bottomRight: Radius.circular(AppRadius.card)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Kekuatan Suara', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark, fontWeight: FontWeight.bold)),
                          Text('47 Suara', style: AppTypography.captionBold.copyWith(color: AppColors.goldDark, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              Text('Pilih Kandidat', style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              
              // Candidate 1
              _buildCandidateCard(
                name: 'Siti Rahayu',
                vision: 'Visi Indonesia Inklusif',
                isSelected: false,
                imageUrl: 'https://i.pravatar.cc/150?img=5',
              ),
              const SizedBox(height: AppSpacing.md),
              // Candidate 2
              _buildCandidateCard(
                name: 'Arjuna Pratama',
                vision: 'Akselerasi Digital Kampus',
                isSelected: true,
                imageUrl: 'https://i.pravatar.cc/150?img=11',
              ),
              
              const SizedBox(height: 48),
              
              // Confirmation Area
              Center(
                child: Column(
                  children: [
                    Text('Konfirmasi Pilihan Anda', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('Arjuna Pratama', style: AppTypography.displayHeading.copyWith(fontSize: 24, color: AppColors.primary900)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('47 Suara akan diberikan', style: AppTypography.captionBold.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text('Tindakan Tidak Dapat Dibatalkan', style: AppTypography.captionBold.copyWith(color: Colors.red)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Swipe to vote
                    Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'GESER UNTUK MENGUNCI 47 SUARA',
                              style: AppTypography.captionBold.copyWith(color: AppColors.outline, fontSize: 10, letterSpacing: 1.0),
                            ),
                          ),
                          Positioned(
                            left: 4,
                            top: 4,
                            bottom: 4,
                            child: GestureDetector(
                              onPanEnd: (details) {
                                // Dummy swipe action
                                context.pushNamed('delegate-vote-processing');
                              },
                              child: Container(
                                width: 56,
                                decoration: const BoxDecoration(
                                  color: AppColors.goldDark,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.lock_outline, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCandidateCard({
    required String name,
    required String vision,
    required bool isSelected,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: isSelected ? AppColors.goldMid : AppColors.outlineVariant, width: isSelected ? 2 : 1),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColors.goldMid.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.displayHeading.copyWith(fontSize: 18, color: AppColors.primary900)),
                const SizedBox(height: 4),
                Text(vision, style: AppTypography.captionBold.copyWith(color: isSelected ? AppColors.goldDark : AppColors.outline)),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.goldMid : Colors.transparent,
              border: Border.all(color: isSelected ? AppColors.goldMid : AppColors.outlineVariant),
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Beranda', false, () {
                context.pushNamed('delegate-home');
              }),
              _buildNavItem(Icons.gavel_outlined, 'Mandat', false, () {
                context.pop();
              }),
              _buildNavItem(Icons.how_to_vote_outlined, 'Eksekusi', true, () {}),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppColors.goldDark : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? AppColors.goldDark : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
