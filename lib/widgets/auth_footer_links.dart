import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/terms_screen.dart';
import '../screens/privacy_policy_screen.dart';

/// Terms and privacy agreement text matching Phone 1
class AuthTermsText extends StatelessWidget {
  const AuthTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'By creating an account, you agree to our ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7E9284),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsScreen()),
                );
              },
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
            const Text(
              ' and ',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7E9284),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                );
              },
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Switch link between "Sign In" and "Create Account"
class AuthSwitchLink extends StatelessWidget {
  final bool isSignIn;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.isSignIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text.rich(
            TextSpan(
              text: isSignIn
                  ? "Don't have an account? "
                  : "Already have an account? ",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A7262),
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: isSignIn ? 'Create account' : 'Sign In',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
