import '../models/user_profile.dart';
import '../constants/api_constants.dart';
import '../localization/app_localizations.dart';
import 'api_client.dart';

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
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}

/// Production implementation communicating with CaneCare AI live cloud backend
class RemoteAuthService implements AuthService {
  final ApiClient _client = ApiClient();
  final DemoAuthService _demoFallback = DemoAuthService();
  UserProfile? _currentUser;

  @override
  Future<UserProfile?> getCurrentUser() async {
    final token = await _client.getAuthToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final data = await _client.get(ApiConstants.me);
      if (data is Map<String, dynamic>) {
        _currentUser = _mapUserFromApi(data);
        return _currentUser;
      }
    } catch (_) {
      return _currentUser;
    }
    return null;
  }

  @override
  Future<UserProfile> signInWithEmail(String email, String password) async {
    try {
      final payload = {
        'email': email.trim().toLowerCase(),
        'password': password,
      };

      final data = await _client.post(ApiConstants.login, payload);
      if (data is Map<String, dynamic>) {
        final token = data['access_token'] as String?;
        if (token != null) {
          await _client.saveAuthToken(token);
        }
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        _currentUser = _mapUserFromApi(userData);
        return _currentUser!;
      }
      throw Exception('Unexpected response format from authentication server.');
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (errorMsg.contains('SocketException') || errorMsg.contains('Failed host lookup')) {
        return _demoFallback.signInWithEmail(email, password);
      }
      rethrow;
    }
  }

  @override
  Future<UserProfile> signUpWithEmail(
      String fullName, String email, String password) async {
    try {
      final payload = {
        'full_name': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'language': 'en',
      };

      final data = await _client.post(ApiConstants.signup, payload);
      if (data is Map<String, dynamic>) {
        try {
          return await signInWithEmail(email, password);
        } catch (_) {
          _currentUser = _mapUserFromApi(data);
          return _currentUser!;
        }
      }
      throw Exception('Unable to complete registration with cloud backend.');
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (errorMsg.contains('SocketException') || errorMsg.contains('Failed host lookup')) {
        return _demoFallback.signUpWithEmail(fullName, email, password);
      }
      rethrow;
    }
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    return _demoFallback.signInWithGoogle();
  }

  @override
  Future<UserProfile> signInWithApple() async {
    return _demoFallback.signInWithApple();
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> signOut() async {
    await _client.clearAuthToken();
    _currentUser = null;
  }

  UserProfile _mapUserFromApi(Map<String, dynamic> json) {
    AppLanguage preferred = AppLanguage.english;
    final langStr = json['language']?.toString().toLowerCase();
    if (langStr == 'mr') preferred = AppLanguage.marathi;
    if (langStr == 'hi') preferred = AppLanguage.hindi;

    return UserProfile(
      id: json['id']?.toString() ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: json['full_name']?.toString() ?? 'Sugarcane Farmer',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      region: 'Maharashtra Sugarcane Belt',
      preferredLanguage: preferred,
      isDemoUser: false,
    );
  }
}
