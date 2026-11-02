import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/otp_input.dart';
import '../widgets/primary_button.dart';
import 'mobile_verified_screen.dart';

/// Screen 8: Mobile Number Verification matching Section 4 specification
class MobileVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String? userEmail;
  final bool startWithError;

  const MobileVerificationScreen({
    super.key,
    this.mobileNumber = '+91 9021590368',
    this.userEmail,
    this.startWithError = false,
  });

  @override
  State<MobileVerificationScreen> createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  String _enteredOtp = '';
  String? _otpError;
  bool _isLoading = false;
  int _countdownSeconds = 45;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    if (widget.startWithError) {
      _otpError = 'Invalid OTP code. Please enter the correct 6-digit code.';
    }
    _startCountdown();
  }

  void _startCountdown() {
    _countdownSeconds = 45;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        if (mounted) setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatCountdown() {
    final mins = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_countdownSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _onVerify() async {
    if (_enteredOtp.length < 6) {
      setState(() {
        _otpError = 'Please enter all 6 digits of the verification code.';
      });
      return;
    }

    setState(() {
      _otpError = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Demo: Any code except "000000" succeeds, "000000" triggers error state
    if (_enteredOtp == '000000') {
      setState(() {
        _otpError = 'Invalid verification code. Please check and try again.';
      });
      return;
    }

    // Success -> Screen 10
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MobileVerifiedScreen(
          mobileNumber: widget.mobileNumber,
        ),
      ),
    );
  }

  void _onResend() {
    if (_countdownSeconds > 0) return;
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A fresh demo OTP has been sent: 123456'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // CaneCare AI Logo & Title
              const CaneCareBrandHeader(logoSize: 64),

              const SizedBox(height: 36),

              // Heading: Verify your mobile number
              const Text(
                'Verify your mobile number',
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

              // Subtitle with masked mobile number
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
                      text: 'Enter the 6-digit code sent to\n',
                    ),
                    TextSpan(
                      text: widget.mobileNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Demo Helper pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5DFA9)),
                ),
                child: const Text(
                  'Demo OTP: 123456 (or 000000 for error demo)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF635600),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Six-digit OTP input boxes
              OtpInputWidget(
                length: 6,
                hasError: _otpError != null,
                errorMessage: _otpError,
                onChanged: (val) {
                  _enteredOtp = val;
                  if (_otpError != null) {
                    setState(() => _otpError = null);
                  }
                },
                onCompleted: (val) {
                  _enteredOtp = val;
                  _onVerify();
                },
              ),

              const SizedBox(height: 28),

              // Verify & Continue button
              PrimaryButton(
                text: 'Verify & Continue',
                onPressed: _onVerify,
                isLoading: _isLoading,
                loadingText: 'Verifying code...',
              ),

              const SizedBox(height: 24),

              // Resend OTP countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5A7262),
                    ),
                  ),
                  if (_countdownSeconds > 0)
                    Text(
                      'Resend in ${_formatCountdown()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreen,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _onResend,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Change Mobile Number link
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF5A7262),
                ),
                label: const Text(
                  'Change Mobile Number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A7262),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
