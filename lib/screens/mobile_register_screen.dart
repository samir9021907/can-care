import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/mobile_number_field.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_footer_links.dart';
import 'mobile_verification_screen.dart';
import 'sign_in_screen.dart';

/// Mobile Number Registration Screen (Extension of Screen 1 as per Section 4)
/// Provides Full Name, Email, Indian Mobile (+91), Password, and Confirm Password.
class MobileRegisterScreen extends StatefulWidget {
  const MobileRegisterScreen({super.key});

  @override
  State<MobileRegisterScreen> createState() => _MobileRegisterScreenState();
}

class _MobileRegisterScreenState extends State<MobileRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  CountryCode _selectedCountry = kSupportedCountries.first;
  String? _nameError;
  String? _emailError;
  String? _mobileError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Full name is required' : null;

      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }

      if (mobile.isEmpty) {
        _mobileError = 'Mobile number is required';
      } else if (mobile.length < _selectedCountry.minLength ||
          mobile.length > _selectedCountry.maxLength) {
        _mobileError = _selectedCountry.minLength == _selectedCountry.maxLength
            ? 'Please enter a valid ${_selectedCountry.maxLength}-digit mobile number'
            : 'Please enter a valid ${_selectedCountry.minLength}-${_selectedCountry.maxLength} digit mobile number';
      } else {
        _mobileError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });

    if (_nameError != null ||
        _emailError != null ||
        _mobileError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MobileVerificationScreen(
          mobileNumber: '${_selectedCountry.code} $mobile',
          userEmail: email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // CaneCare AI Logo & Title
            const Center(
              child: CaneCareBrandHeader(logoSize: 60),
            ),

            const SizedBox(height: 24),

            // Heading: Register Account
            const Text(
              'Register Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
                letterSpacing: -0.3,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Fill in your details to create your CaneCare account',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF5A7262),
              ),
            ),

            const SizedBox(height: 20),

            // Full Name Field
            AuthTextField(
              controller: _nameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person_outline_rounded,
              errorMessage: _nameError,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),

            const SizedBox(height: 12),

            // Email Field
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

            const SizedBox(height: 12),

            // Mobile Number Field with Country Selector Dropdown
            MobileNumberField(
              controller: _mobileController,
              selectedCountry: _selectedCountry,
              onCountryChanged: (country) {
                setState(() => _selectedCountry = country);
              },
              errorMessage: _mobileError,
              onChanged: (_) {
                if (_mobileError != null) setState(() => _mobileError = null);
              },
            ),

            const SizedBox(height: 12),

            // Password Field
            PasswordField(
              controller: _passwordController,
              hintText: 'Password',
              errorMessage: _passwordError,
              onChanged: (_) {
                if (_passwordError != null) {
                  setState(() => _passwordError = null);
                }
              },
            ),

            const SizedBox(height: 12),

            // Confirm Password Field
            PasswordField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              errorMessage: _confirmPasswordError,
              onChanged: (_) {
                if (_confirmPasswordError != null) {
                  setState(() => _confirmPasswordError = null);
                }
              },
            ),

            const SizedBox(height: 22),

            // Register & Send OTP Button
            PrimaryButton(
              text: 'Register & Send OTP',
              onPressed: _onRegister,
              isLoading: _isLoading,
              loadingText: 'Sending verification code...',
            ),

            const SizedBox(height: 16),

            // Terms Text
            const AuthTermsText(),

            const SizedBox(height: 12),

            // Already have account? Sign in
            AuthSwitchLink(
              isSignIn: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
