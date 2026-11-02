import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'auth_progress_screen.dart';
import 'google_account_selection_screen.dart';

/// Screen 2: Sign In matching the reference specification (Phone 2)
/// Also seamlessly renders Phone 3 (Invalid Email), Phone 4 (Missing Email),
/// and Phone 5 (Loading State) based on interactive states or initial props.
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
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _passwordController = TextEditingController(
      text: widget.startInLoadingState ? '••••••••' : '',
    );
    _emailError = widget.initialEmailError;
    _isLoading = widget.startInLoadingState;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      // Validate Email (Matching Phone 3 and Phone 4)
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }

      // Validate Password
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });

    if (_emailError != null || _passwordError != null) return;

    // Trigger Phone 5: Loading State
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithEmail(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Navigate to Phone 6: Authentication in Progress
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AuthProgressScreen(
            userEmail: email,
            isSignUp: false,
          ),
        ),
      );
    }
  }

  void _onGoogleSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GoogleAccountSelectionScreen(isSignUp: false),
      ),
    );
  }

  void _onAppleSignIn() async {
    final auth = context.read<AuthProvider>();
    await auth.signInWithApple();
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthProgressScreen(
          userEmail: 'samir.apple@icloud.com',
          isSignUp: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLoadingOverlay(
      isLoading: _isLoading,
      message: 'Signing in to CaneCare AI...',
      child: AuthBackground(
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

                      // Heading: Sign In
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkGreen,
                          letterSpacing: -0.3,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle: Welcome back! Please sign in to continue.
                      const Text(
                        'Welcome back! Please sign in to continue.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5A7262),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Email input
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

                      const SizedBox(height: 14),

                      // Password input with lock icon and show/hide control
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

                      // Forgot password link (Right aligned)
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Sign In button (Primary deep green)
                      PrimaryButton(
                        text: 'Sign In',
                        onPressed: _isLoading ? null : _onSignIn,
                        isLoading: _isLoading,
                        loadingText: 'Signing in...',
                      ),

                      // Divider with "or"
                      const OrDivider(verticalPadding: 18),

                      // Continue with Google
                      GoogleSignInButton(
                        onPressed: _isLoading ? null : _onGoogleSignIn,
                      ),

                      const SizedBox(height: 12),

                      // Continue with Apple
                      AppleSignInButton(
                        onPressed: _isLoading ? null : _onAppleSignIn,
                      ),

                      const Spacer(),

                      // Don't have an account? Create account
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

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
