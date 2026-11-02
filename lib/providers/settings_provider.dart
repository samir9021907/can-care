import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService;
  NotificationPreferences _prefs = const NotificationPreferences();
  bool _isSubmittingFeedback = false;
  bool _feedbackSubmitted = false;
  String? _feedbackError;

  SettingsProvider({SettingsService? settingsService})
      : _settingsService = settingsService ?? LocalSettingsService();

  NotificationPreferences get preferences => _prefs;
  bool get isSubmittingFeedback => _isSubmittingFeedback;
  bool get feedbackSubmitted => _feedbackSubmitted;
  String? get feedbackError => _feedbackError;

  void toggleDiseaseAlerts(bool value) {
    _prefs = _prefs.copyWith(diseaseOutbreakAlerts: value);
    _settingsService.updateNotificationPreferences(_prefs);
    notifyListeners();
  }

  void toggleWeatherAlerts(bool value) {
    _prefs = _prefs.copyWith(weatherForecastAlerts: value);
    _settingsService.updateNotificationPreferences(_prefs);
    notifyListeners();
  }

  void toggleCropTips(bool value) {
    _prefs = _prefs.copyWith(weeklyCropCareTips: value);
    _settingsService.updateNotificationPreferences(_prefs);
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _prefs = _prefs.copyWith(pushNotificationsEnabled: value);
    _settingsService.updateNotificationPreferences(_prefs);
    notifyListeners();
  }

  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String feedbackType,
    required String message,
  }) async {
    _isSubmittingFeedback = true;
    _feedbackError = null;
    notifyListeners();

    try {
      final success = await _settingsService.submitFeedback(
        name: name,
        email: email,
        feedbackType: feedbackType,
        message: message,
      );
      _isSubmittingFeedback = false;
      _feedbackSubmitted = success;
      notifyListeners();
      return success;
    } catch (e) {
      _isSubmittingFeedback = false;
      _feedbackError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void resetFeedbackStatus() {
    _feedbackSubmitted = false;
    _feedbackError = null;
    notifyListeners();
  }
}
