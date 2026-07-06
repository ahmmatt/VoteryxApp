import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

class DelegateMainLayout extends StatelessWidget {
  const DelegateMainLayout({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(color: AppColors.outlineVariant.withOpacity(0.5))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => _onTap(context, 0),
                  activeColor: AppColors.goldDark,
                ),
                _NavItem(
                  icon: Icons.gavel_outlined,
                  label: 'Mandat',
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => _onTap(context, 1),
                  activeColor: AppColors.goldDark,
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  isSelected: navigationShell.currentIndex == 2,
                  onTap: () => _onTap(context, 2),
                  activeColor: AppColors.goldDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldMid.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? activeColor : AppColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: isSelected ? activeColor : AppColors.textSecondary,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
