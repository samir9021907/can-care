import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _loadProfileFromPrefs();
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

  Future<void> _loadProfileFromPrefs() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_full_name');
      if (name != null && name.isNotEmpty && _currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          fullName: name,
          email: prefs.getString('user_email') ?? _currentUser!.email,
          phone: prefs.getString('user_phone') ?? _currentUser!.phone,
          region: prefs.getString('user_region') ?? _currentUser!.region,
          village: prefs.getString('user_village') ?? _currentUser!.village,
          avatarPath: prefs.getString('user_avatar_path') ?? _currentUser!.avatarPath,
          farmSize: prefs.getString('user_farm_size') ?? _currentUser!.farmSize,
          sugarcaneVariety: prefs.getString('user_sugarcane_variety') ?? _currentUser!.sugarcaneVariety,
          irrigationType: prefs.getString('user_irrigation_type') ?? _currentUser!.irrigationType,
          plantingSeason: prefs.getString('user_planting_season') ?? _currentUser!.plantingSeason,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _persistProfileToPrefs(UserProfile user) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_full_name', user.fullName);
      await prefs.setString('user_email', user.email);
      if (user.phone != null) await prefs.setString('user_phone', user.phone!);
      await prefs.setString('user_region', user.region);
      if (user.village != null) await prefs.setString('user_village', user.village!);
      if (user.avatarPath != null) await prefs.setString('user_avatar_path', user.avatarPath!);
      if (user.farmSize != null) await prefs.setString('user_farm_size', user.farmSize!);
      if (user.sugarcaneVariety != null) await prefs.setString('user_sugarcane_variety', user.sugarcaneVariety!);
      if (user.irrigationType != null) await prefs.setString('user_irrigation_type', user.irrigationType!);
      if (user.plantingSeason != null) await prefs.setString('user_planting_season', user.plantingSeason!);
    } catch (_) {}
  }

  void updateFarmerProfile({
    required String fullName,
    String? email,
    String? phone,
    String? region,
    String? village,
    String? avatarPath,
    String? farmSize,
    String? sugarcaneVariety,
    String? irrigationType,
    String? plantingSeason,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        region: region ?? _currentUser!.region,
        village: village ?? _currentUser!.village,
        avatarPath: avatarPath ?? _currentUser!.avatarPath,
        farmSize: farmSize ?? _currentUser!.farmSize,
        sugarcaneVariety: sugarcaneVariety ?? _currentUser!.sugarcaneVariety,
        irrigationType: irrigationType ?? _currentUser!.irrigationType,
        plantingSeason: plantingSeason ?? _currentUser!.plantingSeason,
      );
      _persistProfileToPrefs(_currentUser!);
      notifyListeners();
    }
  }

  void updateProfileName(String newName, String newEmail, String region) {
    updateFarmerProfile(
      fullName: newName,
      email: newEmail,
      region: region,
    );
  }
}
