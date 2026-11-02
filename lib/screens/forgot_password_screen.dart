import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import 'reset_confirmation_screen.dart';

/// Screen 11: Forgot Password matching Section 5 specification
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendReset() async {
    final email = _emailController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });

    if (_emailError != null) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResetConfirmationScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // CaneCare AI Logo & Title
              const Center(
                child: CaneCareBrandHeader(logoSize: 64),
              ),

              const SizedBox(height: 36),

              // Heading: Forgot Password
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Enter your registered email address to receive password reset instructions.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // Email input field
              AuthTextField(
                controller: _emailController,
                hintText: 'Email address',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                errorMessage: _emailError,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),

              const SizedBox(height: 24),

              // Send Reset Link button
              PrimaryButton(
                text: 'Send Reset Link',
                onPressed: _onSendReset,
                isLoading: _isLoading,
                loadingText: 'Sending link...',
              ),

              const SizedBox(height: 20),

              // Back to Sign In link
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
