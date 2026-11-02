import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/primary_button.dart';
import 'sign_in_screen.dart';

/// Screen 12: Reset Link Confirmation matching Section 5 specification
class ResetConfirmationScreen extends StatelessWidget {
  final String email;

  const ResetConfirmationScreen({
    super.key,
    this.email = 'farmer@canecare.ai',
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

              // Green circular illustration with mail read icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.paleGreen,
                  border: Border.all(color: AppColors.lightGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    color: AppColors.primary,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Heading: Check Your Email
              const Text(
                'Check Your Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Subtitle
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
                      text: 'We have sent password reset instructions to:\n',
                    ),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Demo mode notice pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5DFA9)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFF57F17),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Demo Mode: This is a frontend demonstration. No real email has been sent.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D5100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Return to Sign In button
              PrimaryButton(
                text: 'Return to Sign In',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
