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
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import 'main_navigation_shell.dart';
import '../widgets/social_auth_sheets.dart';

/// Screen 2: Sign In (Login)
/// Allows logging in with Email or Phone Number and Password.
/// Includes direct Google and Apple authentication, forgot password, and switch to Sign Up.
class SignInScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialEmailError;
  final bool startInLoadingState;

  const SignInScreen({
    super.key,
    this.initialEmail,
    this.initialEmailError,
    this.startInLoadingState = false,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;

  String? _identifierError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(text: widget.initialEmail ?? '');
    _passwordController = TextEditingController(
      text: widget.startInLoadingState ? '••••••••' : '',
    );
    _identifierError = widget.initialEmailError;
    _isLoading = widget.startInLoadingState;
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    setState(() {
      // Validate Email or Phone
      if (identifier.isEmpty) {
        _identifierError = 'Email address or mobile number is required';
      } else if (identifier.contains('@')) {
        if (!identifier.contains('.')) {
          _identifierError = 'Please enter a valid email address';
        } else {
          _identifierError = null;
        }
      } else {
        // Numeric phone check
        final cleanPhone = identifier.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
        if (cleanPhone.length < 10) {
          _identifierError = 'Please enter a valid 10-digit mobile number or email';
        } else {
          _identifierError = null;
        }
      }

      // Validate Password
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });

    if (_identifierError != null || _passwordError != null) return;

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithEmail(identifier, password);

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
          content: Text(auth.errorMessage ?? 'Sign in failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onGoogleSignIn() {
    SocialAuthSheets.showGoogleSheet(context);
  }

  void _onAppleSignIn() {
    SocialAuthSheets.showAppleSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLoadingOverlay(
      isLoading: _isLoading,
      message: 'Signing in to CaneCare AI...',
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
                  const SizedBox(height: 12),

                  // CaneCare AI branding
                  const Center(
                    child: CaneCareBrandHeader(logoSize: 64),
                  ),

                  const SizedBox(height: 28),

                  // Heading: Sign In
                  const Text(
                    'Sign In',
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
                    'Welcome back! Enter your email or mobile number to continue.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5A7262),
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 14),

                  // Password input with show/hide toggle
                  PasswordField(
                    controller: _passwordController,
                    hintText: 'Password',
                    errorMessage: _passwordError,
                    onChanged: (val) {
                      if (_passwordError != null) {
                        setState(() => _passwordError = null);
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Sign In button
                  PrimaryButton(
                    text: 'Sign In',
                    onPressed: _isLoading ? null : _onSignIn,
                    isLoading: _isLoading,
                    loadingText: 'Signing in...',
                  ),

                  // Divider with "or"
                  const OrDivider(verticalPadding: 16),

                  // Continue with Google
                  GoogleSignInButton(
                    onPressed: _isLoading ? null : _onGoogleSignIn,
                  ),

                  const SizedBox(height: 12),

                  // Continue with Apple
                  AppleSignInButton(
                    onPressed: _isLoading ? null : _onAppleSignIn,
                  ),

                  const SizedBox(height: 24),

                  // Switch link: Don't have an account? Create account
                  AuthSwitchLink(
                    isSignIn: true,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
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
