import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/create_account_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/invalid_email_screen.dart';
import '../screens/missing_email_screen.dart';
import '../screens/auth_loading_screen.dart';
import '../screens/auth_progress_screen.dart';
import '../screens/account_success_screen.dart';
import '../screens/mobile_register_screen.dart';
import '../screens/mobile_verification_screen.dart';
import '../screens/otp_error_screen.dart';
import '../screens/mobile_verified_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/reset_confirmation_screen.dart';
import '../screens/main_navigation_shell.dart';
import '../screens/weather_screen.dart';
import '../screens/sugarcane_advisory_screen.dart';
import '../screens/ask_question_screen.dart';
import '../screens/sugarcane_care_guide_screen.dart';
import '../screens/farmer_community_screen.dart';

/// Centralized route definitions for CaneCare AI Authentication frontend
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String createAccount = '/create-account';
  static const String signIn = '/sign-in';
  static const String invalidEmail = '/invalid-email';
  static const String missingEmail = '/missing-email';
  static const String authLoading = '/auth-loading';
  static const String authProgress = '/auth-progress';
  static const String accountSuccess = '/account-success';
  static const String mobileRegister = '/mobile-register';
  static const String mobileVerify = '/mobile-verify';
  static const String otpError = '/otp-error';
  static const String mobileVerified = '/mobile-verified';
  static const String forgotPassword = '/forgot-password';
  static const String resetConfirmation = '/reset-confirmation';
  static const String home = '/home';
  static const String weather = '/weather';
  static const String advisory = '/advisory';
  static const String askQuestion = '/ask-question';
  static const String careGuide = '/care-guide';
  static const String community = '/community';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        language: (_) => const LanguageSelectionScreen(),
        createAccount: (_) => const CreateAccountScreen(),
        signIn: (_) => const SignInScreen(),
        invalidEmail: (_) => const InvalidEmailScreen(),
        missingEmail: (_) => const MissingEmailScreen(),
        authLoading: (_) => const AuthLoadingScreen(),
        authProgress: (_) => const AuthProgressScreen(),
        accountSuccess: (_) => const AccountSuccessScreen(),
        mobileRegister: (_) => const MobileRegisterScreen(),
        mobileVerify: (_) => const MobileVerificationScreen(),
        otpError: (_) => const OtpErrorScreen(),
        mobileVerified: (_) => const MobileVerifiedScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        resetConfirmation: (_) => const ResetConfirmationScreen(),
        home: (_) => const MainNavigationShell(),
        weather: (_) => const WeatherScreen(),
        advisory: (_) => const SugarcaneAdvisoryScreen(),
        askQuestion: (_) => const AskQuestionScreen(),
        careGuide: (_) => const SugarcaneCareGuideScreen(),
        community: (_) => const FarmerCommunityScreen(),
      };
}
