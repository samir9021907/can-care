class NotificationPreferences {
  final bool diseaseOutbreakAlerts;
  final bool weatherForecastAlerts;
  final bool weeklyCropCareTips;
  final bool pushNotificationsEnabled;

  const NotificationPreferences({
    this.diseaseOutbreakAlerts = true,
    this.weatherForecastAlerts = true,
    this.weeklyCropCareTips = true,
    this.pushNotificationsEnabled = true,
  });

  NotificationPreferences copyWith({
    bool? diseaseOutbreakAlerts,
    bool? weatherForecastAlerts,
    bool? weeklyCropCareTips,
    bool? pushNotificationsEnabled,
  }) {
    return NotificationPreferences(
      diseaseOutbreakAlerts:
          diseaseOutbreakAlerts ?? this.diseaseOutbreakAlerts,
      weatherForecastAlerts:
          weatherForecastAlerts ?? this.weatherForecastAlerts,
      weeklyCropCareTips: weeklyCropCareTips ?? this.weeklyCropCareTips,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}

abstract class SettingsService {
  Future<NotificationPreferences> getNotificationPreferences();
  Future<void> updateNotificationPreferences(NotificationPreferences prefs);
  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String feedbackType,
    required String message,
  });
}

class LocalSettingsService implements SettingsService {
  NotificationPreferences _prefs = const NotificationPreferences();

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    return _prefs;
  }

  @override
  Future<void> updateNotificationPreferences(
      NotificationPreferences prefs) async {
    _prefs = prefs;
  }

  @override
  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String feedbackType,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }
}
