import 'package:shared_preferences/shared_preferences.dart';

class LoginStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final SharedPreferences _prefs;

  LoginStorage(this._prefs);

  Future<void> saveUser({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<Map<String, String>?> getUser() async {
    final accessToken = _prefs.getString(_accessTokenKey);
    final refreshToken = _prefs.getString(_refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Future<void> clearUser() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  bool hasUser() {
    return _prefs.containsKey(_accessTokenKey) &&
        _prefs.containsKey(_refreshTokenKey);
  }
}
