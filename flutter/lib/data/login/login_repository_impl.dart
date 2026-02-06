import 'package:phone_finder/data/login/login_api.dart' as auth_api;
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final auth_api.AuthApi api;
  final PreferencesRepository prefs;

  LoginRepositoryImpl(this.api, this.prefs);

  @override
  Future<User> login({required String email, required String password}) async {
    final auth_api.User user = await api.login(email: email, password: password);

    await prefs.setString(key: _accessTokenKey, value: user.accessToken);
    await prefs.setString(key: _refreshTokenKey, value: user.refreshToken);

    return User(accessToken: user.accessToken, refreshToken: user.refreshToken);
  }

  @override
  Future<void> logout() async {
    final accessToken = prefs.getString(key: _accessTokenKey);
    final refreshToken = prefs.getString(key: _refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      final auth_api.User apiUser = auth_api.User(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await api.logout(user: apiUser);
    }

    await prefs.remove(key: _accessTokenKey);
    await prefs.remove(key: _refreshTokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final accessToken = prefs.getString(key: _accessTokenKey);
    final refreshToken = prefs.getString(key: _refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return User(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
