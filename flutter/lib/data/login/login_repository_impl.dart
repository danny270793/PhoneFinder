import 'package:phone_finder/data/login/login_api.dart' as auth_api;
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositoryImpl implements LoginRepository {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final auth_api.AuthApi api;
  final SharedPreferences prefs;

  LoginRepositoryImpl(this.api, this.prefs);

  @override
  Future<User> login({required String email, required String password}) async {
    final auth_api.User user = await api.login(email, password);

    await prefs.setString(_accessTokenKey, user.accessToken);
    await prefs.setString(_refreshTokenKey, user.refreshToken);

    return User(accessToken: user.accessToken, refreshToken: user.refreshToken);
  }

  @override
  Future<void> logout() async {
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      final auth_api.User apiUser = auth_api.User(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await api.logout(apiUser);
    }

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return User(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
