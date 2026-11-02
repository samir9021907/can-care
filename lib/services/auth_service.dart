import '../models/user_profile.dart';

abstract class AuthService {
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> signInWithEmail(String email, String password);
  Future<UserProfile> signUpWithEmail(
      String fullName, String email, String password);
  Future<UserProfile> signInWithGoogle();
  Future<UserProfile> signInWithApple();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

enum DemoAuthFailureType {
  none,
  invalidCredentials,
  networkError,
  userCancelled,
  accountDisabled,
}

class DemoAuthService implements AuthService {
  UserProfile? _currentUser;
  DemoAuthFailureType simulatedFailure = DemoAuthFailureType.none;

  DemoAuthService() {
    _currentUser = UserProfile.defaultDemo();
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<UserProfile> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (simulatedFailure == DemoAuthFailureType.invalidCredentials) {
      throw Exception('Invalid email or password. Please try again.');
    }
    if (simulatedFailure == DemoAuthFailureType.networkError) {
      throw Exception('Network connection timed out. Please check your data connection.');
    }

    _currentUser = UserProfile(
      id: 'farmer_usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: email.split('@').first.toUpperCase(),
      email: email,
      region: 'Kolhapur, Maharashtra',
      isDemoUser: true,
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signUpWithEmail(
      String fullName, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (simulatedFailure == DemoAuthFailureType.networkError) {
      throw Exception('Unable to reach demo authentication service.');
    }

    _currentUser = UserProfile(
      id: 'farmer_new_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      region: 'Western Maharashtra',
      isDemoUser: true,
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (simulatedFailure == DemoAuthFailureType.userCancelled) {
      throw Exception('Google Sign-In cancelled by user.');
    }
    if (simulatedFailure == DemoAuthFailureType.networkError) {
      throw Exception('Google Sign-In service unavailable. Try email login.');
    }

    _currentUser = UserProfile(
      id: 'google_demo_farmer_99',
      fullName: 'Samir Rahane',
      email: 'samir.farmer@gmail.com',
      phone: '+91 9021590368',
      region: 'Pune, Maharashtra',
      isDemoUser: true,
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = UserProfile(
      id: 'apple_demo_farmer_88',
      fullName: 'Samir Rahane',
      email: 'samir.rahane@privaterelay.appleid.com',
      phone: '+91 9021590368',
      region: 'Satara, Maharashtra',
      isDemoUser: true,
    );
    return _currentUser!;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulated demo email dispatch
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
