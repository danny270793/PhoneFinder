class User {
  final String accessToken;
  final String refreshToken;
  User({
    required this.accessToken,
    required this.refreshToken,
  });
}

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
}
