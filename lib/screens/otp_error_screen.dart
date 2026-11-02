import 'package:flutter/material.dart';
import 'mobile_verification_screen.dart';

/// Screen 9: Invalid OTP / Expired OTP matching Section 4 specification.
/// Explicit standalone screen showcasing the red error highlight state for OTP.
class OtpErrorScreen extends StatelessWidget {
  final String mobileNumber;

  const OtpErrorScreen({
    super.key,
    this.mobileNumber = '+91 9021590368',
  });

  @override
  Widget build(BuildContext context) {
    return MobileVerificationScreen(
      mobileNumber: mobileNumber,
      startWithError: true,
    );
  }
}
