/// Centralized API configuration for CaneCare AI Cloud Backend.
class ApiConstants {
  // Live Production Cloud Backend URL (Render Cloud)
  static const String baseUrl = 'https://cancare-backend.onrender.com';

  // Alternative URLs (for offline/local development):
  // For Localhost PC:      'http://127.0.0.1:8000'
  // For Android Emulator:  'http://10.0.2.2:8000'

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

  // Feedback (Prediction ground-truth & General app feedback)
  static const String feedback = '$baseUrl/api/v1/feedback';
  static const String appFeedback = '$baseUrl/api/v1/feedback/app';

  // Agro-Medical Shops & Recommended Products
  static const String shops = '$baseUrl/api/v1/shops';
  static const String products = '$baseUrl/api/v1/shops/products';

  // Sugarcane Market & Mandi Rates
  static const String marketRates = '$baseUrl/api/v1/market/rates';

  // Farmer Advisory & Community Questions
  static const String advisoryQuestions = '$baseUrl/api/v1/advisory/questions';

  // Notifications
  static const String notifications = '$baseUrl/api/v1/notifications';

  // Health
  static const String health = '$baseUrl/api/v1/health';

  // Shared preferences storage keys
  static const String tokenKey = 'canecare_auth_token';
  static const String userKey = 'canecare_cached_user';
}
