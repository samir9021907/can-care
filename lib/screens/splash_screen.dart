import 'package:flutter/material.dart';
import '../widgets/cane_logo.dart';

import 'language_selection_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Top-Right Soft Amber Sun Glow
          Positioned(
            top: -45,
            right: -45,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFF9C4).withValues(alpha: 0.9),
                    const Color(0xFFFFFDE7).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. High-Definition Sugarcane Farm Landscape at bottom with Soft Gradient Blend
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 290,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/splash_sugarcane_farm.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFE8F5E9),
                          Color(0xFF81C784),
                          Color(0xFF2E7D32),
                        ],
                      ),
                    ),
                  ),
                ),
                // Smooth gradient overlay to blend into the pale mint background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFF7FAF5),
                        const Color(0xFFF7FAF5).withValues(alpha: 0.82),
                        const Color(0xFFF7FAF5).withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.20, 0.45, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Left Sugarcane Leaf Branch Accent
          Positioned(
            left: 0,
            bottom: 230,
            child: Image.asset(
              'assets/images/splash_leaf_left.png',
              width: 65,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),

          // 4. Floating Right Sugarcane Leaf Accent
          Positioned(
            right: 18,
            bottom: 290,
            child: Image.asset(
              'assets/images/splash_leaf_right.png',
              width: 58,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),

          // 5. Main Center Branding, Subtitle, Motto & Get Started Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // CaneCare AI Logo Squircle
                  const CaneLogo(size: 84),
                  const SizedBox(height: 14),

                  // Title: CaneCare AI
                  const Text(
                    'CaneCare AI',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Research Subtitle
                  const Text(
                    'AI-Based Sugarcane Disease Detection\nUsing Leaf Image Analysis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E6539),
                      height: 1.35,
                      letterSpacing: -0.1,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Headline Motto: Healthy leaves, better harvest
                  const Text(
                    'Healthy leaves,\nbetter harvest',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14451D),
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Early disease detection, made simple\nfor every farmer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF45634D),
                      height: 1.35,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // "➔ Get Started" Pill Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor:
                            const Color(0xFF1B5E20).withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Note: Built for Maharashtra's farmers
                  const Text(
                    "Built for Maharashtra's farmers",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
