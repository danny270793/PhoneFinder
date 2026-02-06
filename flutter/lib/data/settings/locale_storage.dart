import 'package:phone_finder/domain/settings/locale_repository.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';

class LocaleStorageImpl implements LocaleRepository {
  static const _localeKey = 'selected_locale';
  final PreferencesRepository _prefs;

  LocaleStorageImpl(this._prefs);

  @override
  Future<void> saveLocale({required String languageCode}) async {
    await _prefs.setString(key: _localeKey, value: languageCode);
  }

  @override
  String? getLocale() {
    return _prefs.getString(key: _localeKey);
  }

  @override
  Future<void> clearLocale() async {
    await _prefs.remove(key: _localeKey);
  }
}
