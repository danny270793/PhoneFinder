import 'package:phone_finder/data/auth/auth_api.dart' as auth_api;
import 'package:phone_finder/domain/auth/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final auth_api.AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final auth_api.User user = await api.login(email, password);
    return User(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );
  }
}
