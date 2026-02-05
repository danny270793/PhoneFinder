class User {
  final String accessToken;
  final String refreshToken;
  User({
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthApi {
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email != 'email@example.com' || password != 'password') {
      throw Exception('Unauthorized');
    }
    return User(
      accessToken: 'accessToken',
      refreshToken: 'refreshToken',
    );
  }
  Future<void> logout(User user) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
