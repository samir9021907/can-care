import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../localization/app_localizations.dart';
import '../widgets/app_buttons.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'AI-Powered Sugarcane Analysis',
      'subtitle':
          'Capture or upload high-resolution leaf photos to detect symptoms of Rust, Red Rot, Smut, and Yellow Leaf Disease in seconds.',
      'badge': 'Visual Diagnostics',
      'image': 'assets/images/onboarding_preview.png',
    },
    {
      'title': 'Actionable Cultural Guidance',
      'subtitle':
          'Receive structured organic solutions, sanitation steps, and field advisories separated from verified agricultural recommendations.',
      'badge': 'Safe & Expert Care',
      'image': 'assets/images/figma_thumbnail.png',
    },
    {
      'title': 'Field History & Crop Health Tracking',
      'subtitle':
          'Keep detailed records of all your scanned sugarcane blocks across Maharashtra, saving diagnosis reports for offline reference.',
      'badge': 'Smart Harvest',
      'image': 'assets/images/onboarding_preview.png',
    },
  ];

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate('app_name'),
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 16,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      loc.translate('skip'),
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image Card
                        Container(
                          width: double.infinity,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusCard),
                            boxShadow: AppDimensions.cardShadow,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusCard),
                            child: Image.asset(
                              page['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.mintSurface,
                                child: const Icon(
                                  Icons.eco,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Badge Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.mintSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.lightGreen),
                          ),
                          child: Text(
                            page['badge']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          page['title']!,
                          style: AppTypography.heading2.copyWith(
                            fontSize: 22,
                            color: AppColors.darkGreen,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        // Subtitle
                        Text(
                          page['subtitle']!,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                text: _currentPage == _pages.length - 1
                    ? loc.translate('get_started')
                    : loc.translate('continue'),
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
