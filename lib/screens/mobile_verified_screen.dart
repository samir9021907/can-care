import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_success_badges.dart';
import '../widgets/primary_button.dart';
import 'main_navigation_shell.dart';

/// Screen 10: Mobile Number Verified matching Section 4 specification.
class MobileVerifiedScreen extends StatelessWidget {
  final String mobileNumber;

  const MobileVerifiedScreen({
    super.key,
    this.mobileNumber = '+91 9021590368',
  });

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // CaneCare AI Logo & Title
              const CaneCareBrandHeader(logoSize: 64),

              const Spacer(flex: 2),

              // Green success badge with checkmark and festive flecks
              const WelcomeSuccessGraphic(size: 96),

              const SizedBox(height: 32),

              // Heading: Mobile Number Verified!
              const Text(
                'Mobile Number Verified!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Confirmation message
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A7262),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Your mobile number ',
                    ),
                    TextSpan(
                      text: mobileNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const TextSpan(
                      text: '\nhas been linked to your account.',
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Continue to Home button
              PrimaryButton(
                text: 'Continue to Home',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationShell(),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 16),

              // Farmer-friendly greeting
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌱 ', style: TextStyle(fontSize: 15)),
                  Text(
                    'Happy farming!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C6A54),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
