import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_success_badges.dart';
import 'account_success_screen.dart';

/// Screen 6: Authentication in Progress matching Phone 6 in the reference specification.
/// Features the green shield graphic, "Verifying your account...", and 3 animated progress steps.
class AuthProgressScreen extends StatefulWidget {
  final String userEmail;
  final bool isSignUp;

  const AuthProgressScreen({
    super.key,
    this.userEmail = 'farmer@canecare.ai',
    this.isSignUp = true,
  });

  @override
  State<AuthProgressScreen> createState() => _AuthProgressScreenState();
}

class _AuthProgressScreenState extends State<AuthProgressScreen> {
  int _completedSteps = 1; // 1: step 1 done, 2: step 2 done, 3: all done
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;

  @override
  void initState() {
    super.initState();
    // Progressive step animations
    _timer1 = Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _completedSteps = 2);
    });

    _timer2 = Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _completedSteps = 3);
    });

    _timer3 = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSuccessScreen(
              userEmail: widget.userEmail,
              isSignUp: widget.isSignUp,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

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

              // Large circular green verification illustration matching Image 1
              VerifyingShieldGraphic(
                size: 180,
                progress: _completedSteps / 3.0,
              ),

              const SizedBox(height: 30),

              // Heading: Verifying your account...
              const Text(
                'Verifying your account...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle: Please wait while we confirm your details.
              const Text(
                'Please wait while we confirm\nyour details.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Three progress steps matching Image 1 (clean rows directly on background)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepRow(
                      title: 'Checking your information',
                      isCompleted: _completedSteps >= 1,
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow(
                      title: 'Verifying email address',
                      isCompleted: _completedSteps >= 2,
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow(
                      title: 'Setting up your account',
                      isCompleted: _completedSteps >= 3,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String title,
    required bool isCompleted,
  }) {
    final leading = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: isCompleted
          ? Container(
              key: const ValueKey('completed'),
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              ),
            )
          : Container(
              key: const ValueKey('pending'),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6B8A73),
                  width: 1.8,
                ),
                color: Colors.transparent,
              ),
            ),
    );

    return Row(
      children: [
        leading,
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w500,
              color: isCompleted ? const Color(0xFF1B4324) : const Color(0xFF5A7262),
              fontFamily: 'Poppins',
            ),
            child: Text(title),
          ),
        ),
      ],
    );
  }
}
