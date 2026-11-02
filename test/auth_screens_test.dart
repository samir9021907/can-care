import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/auth_provider.dart';
import 'package:canecare/providers/locale_provider.dart';
import 'package:canecare/screens/create_account_screen.dart';
import 'package:canecare/screens/sign_in_screen.dart';
import 'package:canecare/screens/invalid_email_screen.dart';
import 'package:canecare/screens/missing_email_screen.dart';
import 'package:canecare/screens/auth_loading_screen.dart';
import 'package:canecare/screens/auth_progress_screen.dart';
import 'package:canecare/screens/account_success_screen.dart';
import 'package:canecare/screens/mobile_verification_screen.dart';
import 'package:canecare/screens/otp_error_screen.dart';
import 'package:canecare/screens/mobile_verified_screen.dart';
import 'package:canecare/screens/forgot_password_screen.dart';
import 'package:canecare/screens/reset_confirmation_screen.dart';
import 'package:canecare/screens/mobile_register_screen.dart';
import 'package:canecare/screens/google_account_selection_screen.dart';
import 'package:canecare/screens/google_verifying_screen.dart';

Widget createTestApp(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  testWidgets('Screen 1: CreateAccountScreen renders all required elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const CreateAccountScreen()));

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Enter your email to sign up for this app'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Terms of Service'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.textContaining('Already have an account?'), findsOneWidget);
  });

  testWidgets('Screen 2: SignInScreen renders all required elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const SignInScreen()));

    expect(find.text('Sign In'), findsNWidgets(2)); // Heading & Button
    expect(find.text('Welcome back! Please sign in to continue.'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.textContaining("Don't have an account?"), findsOneWidget);
  });

  testWidgets('Screen 3: InvalidEmailScreen shows validation error',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const InvalidEmailScreen()));

    expect(find.text('samir@123'), findsOneWidget);
    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('Screen 4: MissingEmailScreen shows required validation error',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const MissingEmailScreen()));

    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('Screen 5: AuthLoadingScreen displays active loading overlay',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const AuthLoadingScreen()));

    expect(find.text('Signing in...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Screen 6: AuthProgressScreen renders verification steps',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const AuthProgressScreen()));

    expect(find.text('Verifying your account...'), findsOneWidget);
    expect(find.text('Checking your information'), findsOneWidget);
    expect(find.text('Verifying email address'), findsOneWidget);
    expect(find.text('Setting up your account'), findsOneWidget);
  });

  testWidgets('Screen 7: AccountSuccessScreen renders welcome and home button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const AccountSuccessScreen()));

    expect(find.text('Welcome to CaneCare AI!'), findsOneWidget);
    expect(find.text('Your account has been created\nsuccessfully.'), findsOneWidget);
    expect(find.text('Continue to Home'), findsOneWidget);
    expect(find.text('Happy farming!'), findsOneWidget);
  });

  testWidgets('Screen 8: MobileVerificationScreen renders OTP inputs and countdown',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const MobileVerificationScreen(
      mobileNumber: '+91 98765 43210',
    )));

    expect(find.text('Verify your mobile number'), findsOneWidget);
    expect(find.text('Verify & Continue'), findsOneWidget);
    expect(find.text('Change Mobile Number'), findsOneWidget);
  });

  testWidgets('Screen 9: OtpErrorScreen displays error feedback',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const OtpErrorScreen(
      mobileNumber: '+91 98765 43210',
    )));

    expect(find.text('Invalid OTP code. Please enter the correct 6-digit code.'),
        findsOneWidget);
  });

  testWidgets('Screen 10: MobileVerifiedScreen renders confirmation',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const MobileVerifiedScreen(
      mobileNumber: '+91 98765 43210',
    )));

    expect(find.text('Mobile Number Verified!'), findsOneWidget);
    expect(find.text('Continue to Home'), findsOneWidget);
  });

  testWidgets('Screen 11 & 12: Forgot password flow renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const ForgotPasswordScreen()));

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(find.text('Back to Sign In'), findsOneWidget);

    await tester.pumpWidget(createTestApp(const ResetConfirmationScreen(
      email: 'farmer.patil@canecare.ai',
    )));

    expect(find.text('Check Your Email'), findsOneWidget);
    expect(find.text('Return to Sign In'), findsOneWidget);
  });

  testWidgets('Screen 13: MobileRegisterScreen opens country picker and displays countries',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const MobileRegisterScreen()));

    expect(find.text('Register Account'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    // Tap country dropdown pill
    await tester.tap(find.text('+91'));
    await tester.pumpAndSettle();

    // Verify modal sheet opened
    expect(find.text('Select Country'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('Brazil'), findsOneWidget);

    // Select United States (+1)
    await tester.tap(find.text('United States'));
    await tester.pumpAndSettle();

    // Verify country is now +1
    expect(find.text('+1'), findsOneWidget);
  });

  testWidgets('Screen 4 & 5: Google sign-in flow renders account selection and verifying screens',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp(const GoogleAccountSelectionScreen()));

    expect(find.text('Choose an account'), findsOneWidget);
    expect(find.text('to continue to CaneCare AI'), findsOneWidget);
    expect(find.text('Samir Rahane'), findsOneWidget);
    expect(find.text('Rahane Farm'), findsOneWidget);
    expect(find.text('Use another account'), findsOneWidget);

    // Test Screen 5 directly
    await tester.pumpWidget(createTestApp(const GoogleVerifyingScreen(
      userName: 'Samir Rahane',
      userEmail: 'samir@gmail.com',
    )));

    expect(find.text('Signing you in...'), findsOneWidget);
    expect(find.text('Please wait while we verify\nyour account.'), findsOneWidget);
    expect(find.text("This won't take long."), findsOneWidget);
  });
}
