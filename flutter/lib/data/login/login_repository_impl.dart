import 'package:phone_finder/data/login/login_api.dart' as auth_api;
import 'package:phone_finder/data/login/login_storage.dart';
import 'package:phone_finder/data/login/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final auth_api.AuthApi api;
  final LoginStorage storage;

  LoginRepositoryImpl(this.api, this.storage);

  @override
  Future<User> login({required String email, required String password}) async {
    final auth_api.User user = await api.login(email, password);

    // Store user data locally
    await storage.saveUser(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );

    return User(accessToken: user.accessToken, refreshToken: user.refreshToken);
  }

  @override
  Future<void> logout() async {
    // Get the stored user
    final userData = await storage.getUser();

    if (userData != null) {
      final auth_api.User apiUser = auth_api.User(
        accessToken: userData['accessToken']!,
        refreshToken: userData['refreshToken']!,
      );
      await api.logout(apiUser);
    }

    // Clear stored user data
    await storage.clearUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await storage.getUser();

    if (userData == null) {
      return null;
    }

    return User(
      accessToken: userData['accessToken']!,
      refreshToken: userData['refreshToken']!,
    );
  }
}
