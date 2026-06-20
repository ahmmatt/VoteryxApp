import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class VoteProcessingScreen extends StatefulWidget {
  const VoteProcessingScreen({super.key});

  @override
  State<VoteProcessingScreen> createState() => _VoteProcessingScreenState();
}

class _VoteProcessingScreenState extends State<VoteProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  int _currentStep = 0;
  Timer? _stepTimer;

  final List<String> _steps = [
    'Memvalidasi sertifikat digital',
    'Mengenkripsi suara...\nGenerating ephemeral keys',
    'Menyimpan ke kotak suara digital',
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
        // Go to receipt after short delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            context.goNamed('election-receipt', pathParameters: {'id': '1'});
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
              // Ripples & Lock
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
                            Icons.lock,
                            color: Color(0xFFFDE68A), // Light gold
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ENCRYPTING',
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
                'Mengamankan Suaramu',
                style: AppTypography.headerTitle.copyWith(
                  color: AppColors.primary800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Voteryx menggunakan enkripsi AES-256 untuk menjamin kerahasiaan pilihan Anda.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Stepper
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final isCompleted = index < _currentStep;
                    final isActive = index == _currentStep;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : isActive
                                        ? AppColors.goldMid
                                        : Colors.transparent,
                                border: Border.all(
                                  color: isCompleted
                                      ? const Color(0xFF10B981)
                                      : isActive
                                          ? AppColors.goldMid
                                          : AppColors.outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check,
                                      size: 14, color: Colors.white)
                                  : isActive
                                      ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : null,
                            ),
                            if (index < _steps.length - 1)
                              Container(
                                width: 2,
                                height: 40,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : AppColors.outlineVariant
                                        .withValues(alpha: 0.5),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: isActive
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _steps[index].split('\n').first,
                                        style:
                                            AppTypography.bodyMedium.copyWith(
                                          color: AppColors.primary800,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (_steps[index].contains('\n'))
                                        Text(
                                          _steps[index].split('\n').last,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.goldDark,
                                          ),
                                        ),
                                    ],
                                  )
                                : Text(
                                    _steps[index].replaceAll('\n', ' '),
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: isCompleted
                                          ? AppColors.textSecondary
                                          : AppColors.outline,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Hash ID Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F1F3D),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'HASH ID PILIHAN ANDA',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'e3b0c44298fc1c149afbAFCF ...',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Identitasmu tidak terhubung ke pilihan ini',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
