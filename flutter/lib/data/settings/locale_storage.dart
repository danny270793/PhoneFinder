import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const _localeKey = 'selected_locale';
  final SharedPreferences _prefs;

  LocaleStorage(this._prefs);

  /// Save the selected locale language code (e.g., 'en', 'es')
  Future<void> saveLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }

  /// Get the saved locale language code, returns null if not set
  String? getLocale() {
    return _prefs.getString(_localeKey);
  }

  /// Clear the saved locale
  Future<void> clearLocale() async {
    await _prefs.remove(_localeKey);
  }
}
