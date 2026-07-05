// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../election/presentation/widgets/elections_tab.dart';
import '../widgets/home_tab.dart';
import '../../../delegation/presentation/screens/delegation_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// Halaman utama setelah login. (Beranda)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTab();
  }
}
