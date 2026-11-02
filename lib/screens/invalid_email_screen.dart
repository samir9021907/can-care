import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

/// Screen 3: Invalid Email matching Phone 3 in the reference specification.
/// Explicit standalone screen showcasing invalid email validation with red border,
/// red error icon, and inline message: "Please enter a valid email address".
class InvalidEmailScreen extends StatelessWidget {
  const InvalidEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      initialEmail: 'samir@123',
      initialEmailError: 'Please enter a valid email address',
    );
  }
}
