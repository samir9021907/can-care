import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

/// Screen 4: Missing Email matching Phone 4 in the reference specification.
/// Explicit standalone screen showcasing missing required email validation with
/// red border and inline message: "Email is required".
class MissingEmailScreen extends StatelessWidget {
  const MissingEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      initialEmail: '',
      initialEmailError: 'Email is required',
    );
  }
}
