import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/apple_sign_in_button.dart';
import '../widgets/auth_footer_links.dart';
import '../widgets/auth_loading_overlay.dart';
import 'sign_in_screen.dart';
import 'main_navigation_shell.dart';
import '../widgets/social_auth_sheets.dart';

/// Screen 1: Create Account (Sign Up)
/// Allows full registration with Full Name, Email / Mobile Number, Password, and Confirm Password.
/// Also supports direct Google and Apple sign in, terms & privacy, and quick switch to Sign In.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _identifierError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    final name = _nameController.text.trim();
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      // Name validation
      if (name.isEmpty) {
        _nameError = 'Full name is required';
      } else {
        _nameError = null;
      }

      // Email or Phone validation
      if (identifier.isEmpty) {
        _identifierError = 'Email address or mobile number is required';
      } else if (identifier.contains('@')) {
        if (!identifier.contains('.')) {
          _identifierError = 'Please enter a valid email address';
        } else {
          _identifierError = null;
        }
      } else {
        final cleanPhone = identifier.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
        if (cleanPhone.length < 10) {
          _identifierError = 'Please enter a valid 10-digit mobile number or email';
        } else {
          _identifierError = null;
        }
      }

      // Password validation
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      // Confirm Password validation
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });

    if (_nameError != null ||
        _identifierError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.signUpWithEmail(name, identifier, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('canecare_is_logged_in', true);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Sign up failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onGoogleSignUp() {
    SocialAuthSheets.showGoogleSheet(context);
  }

  void _onAppleSignUp() {
    SocialAuthSheets.showAppleSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLoadingOverlay(
      isLoading: _isLoading,
      message: 'Creating your account...',
      child: AuthBackground(
        showBottomLeaves: false, // Prevents leaf decoration from overlapping form text
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // Centered CaneCare AI logo + app name
                  const Center(
                    child: CaneCareBrandHeader(logoSize: 64),
                  ),

                  const SizedBox(height: 24),

                  // Heading: Create an account
                  const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                      letterSpacing: -0.3,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  const Text(
                    'Join CaneCare AI to protect and monitor your sugarcane crop.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5A7262),
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 22),

                  // Full Name input
                  AuthTextField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline_rounded,
                    errorMessage: _nameError,
                    onChanged: (val) {
                      if (_nameError != null) {
                        setState(() => _nameError = null);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Email or Mobile Number input
                  AuthTextField(
                    controller: _identifierController,
                    hintText: 'Email address or mobile number',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    errorMessage: _identifierError,
                    onChanged: (val) {
                      if (_identifierError != null) {
                        setState(() => _identifierError = null);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Password input
                  PasswordField(
                    controller: _passwordController,
                    hintText: 'Password (min. 6 characters)',
                    errorMessage: _passwordError,
                    onChanged: (val) {
                      if (_passwordError != null) {
                        setState(() => _passwordError = null);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Confirm Password input
                  PasswordField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    errorMessage: _confirmPasswordError,
                    onChanged: (val) {
                      if (_confirmPasswordError != null) {
                        setState(() => _confirmPasswordError = null);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sign Up / Continue button
                  PrimaryButton(
                    text: 'Create Account',
                    onPressed: _isLoading ? null : _onSignUp,
                    isLoading: _isLoading,
                    loadingText: 'Creating account...',
                  ),

                  // Divider with "or"
                  const OrDivider(verticalPadding: 16),

                  // Continue with Google
                  GoogleSignInButton(
                    onPressed: _isLoading ? null : _onGoogleSignUp,
                  ),

                  const SizedBox(height: 12),

                  // Continue with Apple
                  AppleSignInButton(
                    onPressed: _isLoading ? null : _onAppleSignUp,
                  ),

                  const SizedBox(height: 18),

                  // Terms and Privacy Policy links
                  const AuthTermsText(),

                  const SizedBox(height: 14),

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

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
