import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_success_badges.dart';
import '../widgets/primary_button.dart';
import 'main_navigation_shell.dart';

/// Screen 7: Account Created / Welcome matching Phone 7 in the reference specification.
/// Features the large success checkmark, celebratory particles, "Continue to Home ➔",
/// and "🌱 Happy farming!".
class AccountSuccessScreen extends StatelessWidget {
  final String userEmail;
  final bool isSignUp;

  const AccountSuccessScreen({
    super.key,
    this.userEmail = 'farmer@canecare.ai',
    this.isSignUp = true,
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

              // CaneCare AI logo + app name
              const CaneCareBrandHeader(logoSize: 64),

              const Spacer(flex: 2),

              // Large green success circle with white checkmark & festive flecks
              const WelcomeSuccessGraphic(size: 96),

              const SizedBox(height: 32),

              // Heading: Welcome to CaneCare AI!
              const Text(
                'Welcome to CaneCare AI!',
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

              // Subtitle: Your account has been created successfully.
              const Text(
                'Your account has been created\nsuccessfully.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Green button: Continue to Home ➔
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

              // Farmer-friendly greeting: 🌱 Happy farming!
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🌱 ',
                    style: TextStyle(fontSize: 15),
                  ),
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
