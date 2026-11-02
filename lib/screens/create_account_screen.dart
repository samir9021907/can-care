import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/apple_sign_in_button.dart';
import '../widgets/auth_footer_links.dart';
import 'sign_in_screen.dart';
import 'auth_progress_screen.dart';
import 'mobile_register_screen.dart';
import 'google_account_selection_screen.dart';

/// Screen 1: Create Account matching the reference specification (Phone 1)
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() async {
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

    // Simulated account setup
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthProgressScreen(
          userEmail: email,
          isSignUp: true,
        ),
      ),
    );
  }

  void _onGoogleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GoogleAccountSelectionScreen(isSignUp: true),
      ),
    );
  }

  void _onAppleSignUp() async {
    final auth = context.read<AuthProvider>();
    await auth.signInWithApple();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthProgressScreen(
          userEmail: 'samir.apple@icloud.com',
          isSignUp: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Centered CaneCare AI logo + app name
                    const Center(
                      child: CaneCareBrandHeader(logoSize: 64),
                    ),

                    const SizedBox(height: 32),

                    // Heading: Create an account
                    const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                        letterSpacing: -0.3,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle: Enter your email to sign up for this app
                    const Text(
                      'Enter your email to sign up for this app',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5A7262),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email input with envelope icon
                    AuthTextField(
                      controller: _emailController,
                      hintText: 'Email address',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      errorMessage: _emailError,
                      onChanged: (val) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Continue button (Primary deep green)
                    PrimaryButton(
                      text: 'Continue',
                      onPressed: _onContinue,
                      isLoading: _isLoading,
                      loadingText: 'Creating account...',
                    ),

                    // Divider with "or"
                    const OrDivider(verticalPadding: 18),

                    // Continue with Google
                    GoogleSignInButton(
                      onPressed: _onGoogleSignUp,
                    ),

                    const SizedBox(height: 12),

                    // Continue with Apple
                    AppleSignInButton(
                      onPressed: _onAppleSignUp,
                    ),

                    const SizedBox(height: 16),

                    // Register with mobile number option
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MobileRegisterScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.phone_android_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'Register with Mobile Number (+91)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Terms and Privacy Policy links
                    const AuthTermsText(),

                    const SizedBox(height: 12),

                    // Already have an account? Sign In
                    AuthSwitchLink(
                      isSignIn: false,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
