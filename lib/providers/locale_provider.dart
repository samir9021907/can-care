import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.marathi;
  static const String _prefKey = 'selected_language';

  AppLanguage get currentLanguage => _currentLanguage;
  Locale get locale => Locale(_currentLanguage.code);

  LocaleProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code != null) {
        if (code == 'mr') {
          _currentLanguage = AppLanguage.marathi;
        } else if (code == 'hi') {
          _currentLanguage = AppLanguage.hindi;
        } else {
          _currentLanguage = AppLanguage.english;
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, language.code);
    } catch (_) {}
  }
}
