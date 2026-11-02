/// Centralized API configuration for CaneCare AI Cloud Backend.
class ApiConstants {
  // Live Render production URL
  static const String baseUrl = 'https://cancare-nrjr.onrender.com';

  // Auth endpoints
  static const String signup = '$baseUrl/api/v1/auth/signup';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String me = '$baseUrl/api/v1/auth/me';

  // User endpoints
  static const String updateUser = '$baseUrl/api/v1/users/me';

  // Prediction endpoint
  static const String predict = '$baseUrl/api/v1/predict';

  // Disease library
  static const String diseases = '$baseUrl/api/v1/diseases';

  // Scan history & management
  static const String history = '$baseUrl/api/v1/history';
  static String deleteScan(String scanId) => '$baseUrl/api/v1/scans/$scanId';

  // Feedback
  static const String feedback = '$baseUrl/api/v1/feedback';

  // Agro-Medical Shops
  static const String shops = '$baseUrl/api/v1/shops';

  // Health
  static const String health = '$baseUrl/api/v1/health';

  // Shared preferences storage keys
  static const String tokenKey = 'canecare_auth_token';
  static const String userKey = 'canecare_cached_user';
}

