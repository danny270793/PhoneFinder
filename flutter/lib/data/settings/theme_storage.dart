import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const _themeModeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeStorage(this._prefs);

  /// Save the selected theme mode
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
  }

  /// Get the saved theme mode, returns null if not set
  ThemeMode? getThemeMode() {
    final savedMode = _prefs.getString(_themeModeKey);
    if (savedMode == null) return null;

    switch (savedMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  /// Clear the saved theme mode
  Future<void> clearThemeMode() async {
    await _prefs.remove(_themeModeKey);
  }
}
