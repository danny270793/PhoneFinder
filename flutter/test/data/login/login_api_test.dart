import 'package:flutter_test/flutter_test.dart';
import 'package:phone_finder/data/login/login_api.dart';

void main() {
  group('AuthApi', () {
    late AuthApi api;

    setUp(() {
      api = AuthApi();
    });

    group('login', () {
      test('should return user when credentials are valid', () async {
        // Arrange
        const email = 'email@example.com';
        const password = 'password';

        // Act
        final result = await api.login(email: email, password: password);

        // Assert
        expect(result.accessToken, 'accessToken');
        expect(result.refreshToken, 'refreshToken');
      });

      test('should throw exception when email is invalid', () async {
        // Arrange
        const email = 'wrong@example.com';
        const password = 'password';

        // Act & Assert
        expect(
          () => api.login(email: email, password: password),
          throwsException,
        );
      });

      test('should throw exception when password is invalid', () async {
        // Arrange
        const email = 'email@example.com';
        const password = 'wrongpassword';

        // Act & Assert
        expect(
          () => api.login(email: email, password: password),
          throwsException,
        );
      });
    });

    group('logout', () {
      test('should complete successfully', () async {
        // Arrange
        final user = await api.login(
          email: 'email@example.com',
          password: 'password',
        );

        // Act & Assert
        expect(
          api.logout(user: user),
          completes,
        );
      });
    });
  });
}
