import 'package:flutter/material.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_radius.dart';
import 'package:voteryxapp/core/widgets/app_text_field.dart';

import 'delegate_detail_screen.dart';

class DelegationScreen extends StatelessWidget {
  const DelegationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  _buildHeroCard(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTopExpertsHeader(),
                  const SizedBox(height: AppSpacing.md),
                  _buildTopExpertsList(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.md),
                  _buildFilterChips(),
                  const SizedBox(height: AppSpacing.xl),
                  Text('All Delegates', style: AppTypography.screenTitle),
                  const SizedBox(height: AppSpacing.md),
                  _buildAllDelegatesList(context),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primary800,
      expandedHeight: kToolbarHeight,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Delegasi', style: AppTypography.headerTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: ClipOval(
            child: Image.network(
              'https://ui-avatars.com/api/?name=User&background=random',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 32,
                height: 32,
                color: AppColors.goldMid,
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E5E), // Approximate from image
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: const LinearGradient(
          colors: [Color(0xFF384666), Color(0xFF2C3E5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info, color: AppColors.warningAmber, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text('LIQUID DEMOCRACY', style: AppTypography.labelSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your Power, Shared.',
            style: AppTypography.displayHeading.copyWith(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Delegate your voting power to experts you trust. They vote on your behalf, but you can revoke or change your delegate at any time instantly.',
            style: AppTypography.bodyText.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTopExpertsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Top Experts', style: AppTypography.screenTitle.copyWith(fontSize: 20)),
        Row(
          children: [
            Text('View all', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark)),
            const Icon(Icons.arrow_forward, size: 16, color: AppColors.goldDark),
          ],
        )
      ],
    );
  }

  Widget _buildTopExpertsList(BuildContext context) {
    final experts = [
      {'name': 'Dr. Sarah K.', 'faculty': 'ECONOMY', 'img': 'https://ui-avatars.com/api/?name=Sarah+K&background=random'},
      {'name': 'Prof. James', 'faculty': 'TECHNOLOGY', 'img': 'https://ui-avatars.com/api/?name=James&background=random'},
      {'name': 'Maya Indah', 'faculty': 'SOCIAL', 'img': 'https://ui-avatars.com/api/?name=Maya+Indah&background=random'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: experts.map((e) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DelegateDetailScreen()),
            );
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.goldMid, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        e['img']!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.primary800,
                          child: const Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.verified, color: AppColors.goldMid, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(e['name']!, style: AppTypography.bodyMedium),
              Text(e['faculty']!, style: AppTypography.captionBold.copyWith(color: AppColors.goldMid)),
            ],
          ),
        ),
          );
      }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.input),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name or faculty',
          hintStyle: AppTypography.bodyText.copyWith(color: AppColors.outlineVariant),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Semua', 'BEM Aktif', 'Akademik', 'Lingkungan'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((c) {
          final isSelected = c == 'Semua';
          return Container(
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary900 : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? null : Border.all(color: AppColors.outlineVariant, width: 1),
            ),
            child: Text(
              c,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAllDelegatesList(BuildContext context) {
    final delegates = [
      {'name': 'Dian Sastro', 'faculty': 'Fakultas Hukum • BEM Aktif', 'trust': '98%', 'img': 'https://ui-avatars.com/api/?name=Dian+Sastro&background=random'},
      {'name': 'Rizky Ahmad', 'faculty': 'Fakultas Teknik • Akademik', 'trust': '95%', 'img': 'https://ui-avatars.com/api/?name=Rizky+Ahmad&background=random'},
      {'name': 'Putri Amalia', 'faculty': 'Fakultas Ekonomi • Sosial', 'trust': '99%', 'img': 'https://ui-avatars.com/api/?name=Putri+Amalia&background=random'},
    ];

    return Column(
      children: delegates.map((d) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DelegateDetailScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Image.network(
                    d['img']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.primary800,
                      child: const Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['name']!, style: AppTypography.cardTitle.copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(d['faculty']!, style: AppTypography.captionBold.copyWith(color: AppColors.textSecondary, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${d['trust']} Amanah', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldDark, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Lihat\nDetail', textAlign: TextAlign.right, style: AppTypography.caption.copyWith(fontSize: 10)),
                        const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}
