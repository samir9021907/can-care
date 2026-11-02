import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

enum AuthLoadingType {
  none,
  emailAuth,
  googleAuth,
  appleAuth,
  passwordReset,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  UserProfile? _currentUser;
  bool _isAuthenticated = true; // Set to true by default for easy demo navigation
  AuthLoadingType _loadingType = AuthLoadingType.none;
  String? _errorMessage;
  String? _successMessage;

  // Demo state simulator
  String? _googleDemoStatus; // 'loading', 'success', 'cancelled', 'error'
  String? _appleDemoStatus;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? DemoAuthService() {
    _currentUser = UserProfile.defaultDemo();
  }

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _loadingType != AuthLoadingType.none;
  AuthLoadingType get loadingType => _loadingType;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get googleDemoStatus => _googleDemoStatus;
  String? get appleDemoStatus => _appleDemoStatus;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    _googleDemoStatus = null;
    _appleDemoStatus = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _loadingType = AuthLoadingType.emailAuth;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithEmail(email, password);
      _currentUser = user;
      _isAuthenticated = true;
      _successMessage = 'Welcome back, ${user.fullName}!';
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(
      String fullName, String email, String password) async {
    _loadingType = AuthLoadingType.emailAuth;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final user =
          await _authService.signUpWithEmail(fullName, email, password);
      _currentUser = user;
      _isAuthenticated = true;
      _successMessage = 'Account created successfully! Welcome to CaneCare AI.';
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInWithGoogle({String demoOutcome = 'success'}) async {
    _loadingType = AuthLoadingType.googleAuth;
    _googleDemoStatus = 'loading';
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (demoOutcome == 'cancelled') {
      _loadingType = AuthLoadingType.none;
      _googleDemoStatus = 'cancelled';
      _errorMessage = 'Google Sign-In was cancelled by user.';
      notifyListeners();
      return;
    }

    if (demoOutcome == 'error') {
      _loadingType = AuthLoadingType.none;
      _googleDemoStatus = 'error';
      _errorMessage = 'Google Play Services authentication failed (Code: 12500).';
      notifyListeners();
      return;
    }

    // Success demo
    _currentUser = UserProfile(
      id: 'usr_g_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Samir Rahane',
      email: 'samir.farmer@gmail.com',
      phone: '+91 9021590368',
      region: 'Kolhapur, Maharashtra',
      isDemoUser: true,
    );
    _isAuthenticated = true;
    _googleDemoStatus = 'success';
    _loadingType = AuthLoadingType.none;
    _successMessage = 'Connected via Google demo account!';
    notifyListeners();
  }

  Future<void> signInWithApple({String demoOutcome = 'success'}) async {
    _loadingType = AuthLoadingType.appleAuth;
    _appleDemoStatus = 'loading';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (demoOutcome == 'error') {
      _loadingType = AuthLoadingType.none;
      _appleDemoStatus = 'error';
      _errorMessage = 'Apple ID authorization unavailable on this device.';
      notifyListeners();
      return;
    }

    _currentUser = UserProfile(
      id: 'usr_apple_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Samir Rahane',
      email: 'samir.rahane@privaterelay.appleid.com',
      phone: '+91 9021590368',
      region: 'Satara, Maharashtra',
      isDemoUser: true,
    );
    _isAuthenticated = true;
    _appleDemoStatus = 'success';
    _loadingType = AuthLoadingType.none;
    _successMessage = 'Connected via Apple demo account!';
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    _loadingType = AuthLoadingType.passwordReset;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordReset(email);
      _successMessage =
          'Password reset link has been sent to $email. Please check your inbox.';
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _loadingType = AuthLoadingType.none;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void updateProfileName(String newName, String newEmail, String region) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: newName,
        email: newEmail,
        region: region,
      );
      notifyListeners();
    }
  }
}
