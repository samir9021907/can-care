import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

/// Screen 5: Loading State matching Phone 5 in the reference specification.
/// Explicit standalone screen showcasing the active loading state with subtle
/// translucent dark overlay, visible spinner, disabled buttons, and "Signing in...".
class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      initialEmail: 'samir.farmer@gmail.com',
      startInLoadingState: true,
    );
  }
}
