import 'package:phone_finder/domain/storage/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImpl implements PreferencesRepository {
  final SharedPreferences _prefs;

  SharedPreferencesImpl(this._prefs);

  @override
  Future<void> setString({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString({required String key}) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return _prefs.containsKey(key);
  }
}
