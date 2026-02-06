import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';

class ThemeStorageImpl implements ThemeRepository {
  static const _themeModeKey = 'theme_mode';
  final PreferencesRepository _prefs;

  ThemeStorageImpl(this._prefs);

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
  }

  @override
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

  @override
  Future<void> clearThemeMode() async {
    await _prefs.remove(_themeModeKey);
  }
}
