// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../election/presentation/widgets/elections_tab.dart';
import '../widgets/home_tab.dart';

/// Halaman utama setelah login.
/// Mengelola BottomNavigationBar dan menampilkan tab yang sesuai.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Daftar tab untuk Bottom Navigation
  final List<Widget> _tabs = [
    const HomeTab(),
    const ElectionsTab(),
    const Center(child: Text('Delegations Tab')), // TODO: implement tab Delegations
    const Center(child: Text('Profile Tab')), // TODO: implement tab Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0D0F1F3D),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.goldDark,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: AppTypography.captionBold.copyWith(
            fontSize: 10,
          ),
          unselectedLabelStyle: AppTypography.captionBold.copyWith(
            fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              activeIcon: Icon(Icons.list_alt),
              label: 'Elections',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'Delegations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
