// lib/features/auth/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voteryxapp/core/constants/app_colors.dart';
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
  bool _isNavigating = false;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      title: 'Kenali Pemimpinmu : ',
      quote: '"Baca rekam jejak dan visi misi secara transparan."',
      imageUrl: 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80&w=1000',
      fallbackGradient: [Color(0xFF0F1F3D), Color(0xFF1A3260)],
    ),
    _OnboardingSlide(
      title: 'Delegasikan Suaramu: ',
      quote: '"Ragu? Percayakan suaramu pada pakar di bidangnya."',
      imageUrl: 'https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?auto=format&fit=crop&q=80&w=1000',
      fallbackGradient: [Color(0xFF0F5A4D), Color(0xFF1A3260)],
    ),
    _OnboardingSlide(
      title: '100% Rahasia & Aman: ',
      quote: '"Teknologi kriptografi memastikan suaramu tidak dapat dilacak."',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&q=80&w=1000',
      fallbackGradient: [Color(0xFF1A3260), Color(0xFF00071B)],
    ),
  ];

  Future<void> _handleGetStarted() async {
    if (_isNavigating) return;
    _isNavigating = true;

    // Simpan flag bahwa onboarding sudah dilihat
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF3),
      body: Stack(
        children: [
          // Background PageView with Photos
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _SlideBackground(slide: _slides[index]);
            },
          ),

          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar: Lewati button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: GestureDetector(
                      onTap: _handleGetStarted,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'Lewati',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom Content Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row: Logo on left, Dots on right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo Voteryx
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary900,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.how_to_vote_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
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

                          // Page indicator dots
                          Row(
                            children: List.generate(
                              _slides.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(left: 6),
                                width: _currentPage == index ? 22 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? AppColors.primary900
                                      : AppColors.primary900.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Title and Quote Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: RichText(
                          key: ValueKey(_currentPage),
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _slides[_currentPage].title,
                                style: AppTypography.bodyText.copyWith(
                                  color: AppColors.primary900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: _slides[_currentPage].quote,
                                style: AppTypography.bodyText.copyWith(
                                  color: AppColors.primary900.withValues(alpha: 0.85),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // CTA Button: Mulai Amankan Suaramu
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < _slides.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _handleGetStarted();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary900,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Mulai Amankan Suaramu',
                            style: AppTypography.buttonText.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
             ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.quote,
    required this.imageUrl,
    required this.fallbackGradient,
  });

  final String title;
  final String quote;
  final String imageUrl;
  final List<Color> fallbackGradient;
}

class _SlideBackground extends StatelessWidget {
  const _SlideBackground({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image with fallback gradient
        Image.network(
          slide.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: slide.fallbackGradient,
              ),
            ),
          ),
        ),
        // Gradient fade overlay from top (transparent) to bottom (light grey/white)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 0.7, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
                const Color(0xFFE8ECF3).withValues(alpha: 0.9),
                const Color(0xFFE8ECF3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
