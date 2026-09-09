import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user-chosen settings so they survive app restarts.
class SettingsStorageService {
  static const String _languageCodeKey = 'settings.languageCode';
  static const String _isDarkThemeKey = 'settings.isDarkTheme';

  Future<String?> getLanguageCode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_languageCodeKey);
  }

  Future<void> setLanguageCode(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageCodeKey, languageCode);
  }

  Future<Brightness?> getThemeBrightness() async {
    final preferences = await SharedPreferences.getInstance();
    final isDark = preferences.getBool(_isDarkThemeKey);
    return isDark == null
        ? null
        : (isDark ? Brightness.dark : Brightness.light);
  }

  Future<void> setThemeBrightness(Brightness brightness) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isDarkThemeKey, brightness == Brightness.dark);
  }
}
