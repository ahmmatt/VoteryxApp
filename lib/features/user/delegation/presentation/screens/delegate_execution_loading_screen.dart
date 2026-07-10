import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class DelegateExecutionLoadingScreen extends StatefulWidget {
  final String electionId;
  const DelegateExecutionLoadingScreen({super.key, required this.electionId});

  @override
  State<DelegateExecutionLoadingScreen> createState() => _DelegateExecutionLoadingScreenState();
}

class _DelegateExecutionLoadingScreenState extends State<DelegateExecutionLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  int _currentStep = 0;
  Timer? _stepTimer;

  final List<String> _steps = [
    'Mengekstrak profil delegate',
    'Menghitung bobot suara mandat',
    'Mengeksekusi surat suara gabungan',
  ];

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _startProcess();
  }

  void _startProcess() {
    _stepTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        timer.cancel();
        // Go to success screen after short delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            context.goNamed('delegate-execution-success', pathParameters: {'id': widget.electionId});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8), // Soft light blue-grey
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePad,
            vertical: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              // Ripples & Lock/Folder Icon
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _rippleController,
                        builder: (context, child) {
                          final progress =
                              (_rippleController.value + (index * 0.33)) % 1.0;
                          return Transform.scale(
                            scale: 1.0 + (progress * 1.5),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.goldDark.withValues(
                                    alpha: (1.0 - progress) * 0.5,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.primary800,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x330F1F3D),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_shared,
                            color: Color(0xFFFDE68A), // Light gold
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'EXECUTING',
                            style: AppTypography.captionBold.copyWith(
                              color: AppColors.goldDark,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              Text(
                'Mengamankan Mandat',
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sistem sedang memproses suara kolektif Anda',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 64),

              // Steps List
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final isCompleted = index < _currentStep;
                    final isActive = index == _currentStep;
                    final isPending = index > _currentStep;

                    Color iconColor = AppColors.outline;
                    IconData iconData = Icons.radio_button_unchecked;

                    if (isCompleted) {
                      iconColor = AppColors.successTeal;
                      iconData = Icons.check_circle;
                    } else if (isActive) {
                      iconColor = AppColors.goldDark;
                      iconData = Icons.autorenew; // Spinner-like
                    }

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: isPending ? 0.4 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isActive)
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 1),
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 2 * 3.14159,
                                      child: Icon(iconData, color: iconColor),
                                    );
                                  },
                                ),
                              )
                            else
                              Icon(iconData, color: iconColor, size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _steps[index],
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isActive
                                      ? AppColors.primary800
                                      : isPending
                                          ? AppColors.outline
                                          : AppColors.textSecondary,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
