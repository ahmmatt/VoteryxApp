import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
import 'package:voteryxapp/core/constants/app_spacing.dart';
import 'package:voteryxapp/core/constants/app_typography.dart';
import 'package:voteryxapp/core/router/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Kenali Pemimpinmu :',
      'description': '"Baca rekam jejak dan visi misi secara transparan."',
      'image': 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?q=80&w=1200&auto=format&fit=crop',
    },
    {
      'title': 'Delegasikan Suaramu:',
      'description': '"Ragu? Percayakan suaramu pada pakar di bidangnya."',
      'image': 'https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?q=80&w=1200&auto=format&fit=crop',
    },
    {
      'title': '100% Rahasia & Aman:',
      'description': '"Teknologi kriptografi memastikan suaramu tidak dapat dilacak."',
      'image': 'https://images.unsplash.com/photo-1523908511403-7fc7b25592f4?q=80&w=1200&auto=format&fit=crop',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                  // White Gradient Overlay at the bottom
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.4),
                          const Color(0xFFE8EEF5), // Light gray-blue tint from image
                          const Color(0xFFE8EEF5),
                        ],
                        stops: const [0.5, 0.7, 0.85, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Content Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Page Indicator Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.how_to_vote, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voteryx',
                            style: AppTypography.headerTitle.copyWith(
                              color: AppColors.primary900,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      
                      // Page Indicators
                      Row(
                        children: List.generate(
                          _onboardingData.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: _currentPage == index ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index 
                                  ? AppColors.primary900 
                                  : AppColors.primary900.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Text Content
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${_onboardingData[_currentPage]['title']} ',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary900,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: _onboardingData[_currentPage]['description'],
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // CTA Button
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.login);
                      // In reality, this might go to KYC directly or a Login/Register chooser.
                      // Since user requested KYC register, we'll go to KYC input.
                      context.go(AppRoutes.kycNikInput);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mulai Amankan Suaramu',
                      style: AppTypography.buttonText.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
