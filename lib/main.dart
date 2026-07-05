// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Entry point Voteryx.
///
/// Catatan setup yang belum selesai:
/// - Supabase.initialize() akan ditambahkan setelah project
///   Supabase siap (lihat core/network/supabase_client.dart).
/// - Drift database initialization akan ditambahkan saat
///   fitur offline pertama dibangun.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Uncomment setelah Supabase project siap:
  // await SupabaseConfig.initialize();

  runApp(
    // ProviderScope adalah root dari Riverpod state management.
    // Semua Provider hanya bisa diakses di dalam ProviderScope.
    const ProviderScope(
      child: VoteryxApp(),
    ),
  );
}

/// Root widget aplikasi Voteryx.
class VoteryxApp extends StatelessWidget {
  const VoteryxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Voteryx',
      debugShowCheckedModeBanner: false,

      // Tema menggunakan design tokens Voteryx
      theme: AppTheme.light,

      // Navigation menggunakan GoRouter
      routerConfig: appRouter,

      builder: (context, child) => _MobileViewport(child: child),
    );
  }
}

class _MobileViewport extends StatelessWidget {
  const _MobileViewport({required this.child});

  final Widget? child;

  static const double _maxMobileWidth = 430;

  @override
  Widget build(BuildContext context) {
    final content = child ?? const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 480) {
          return content;
        }

        return ColoredBox(
          color: const Color(0xFFE8ECF3),
          child: Center(
            child: SizedBox(
              width: _maxMobileWidth,
              child: content,
            ),
          ),
        );
      },
    );
  }
}
