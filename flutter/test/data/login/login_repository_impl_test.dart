import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';
import 'package:phone_finder/data/login/login_api.dart' as auth_api;

class MockAuthApi extends Mock implements AuthApi {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

void main() {
  setUpAll(() {
    // Register fallback values for named parameters
    registerFallbackValue(auth_api.User(
      accessToken: 'test_access',
      refreshToken: 'test_refresh',
    ));
  });

  group('LoginRepositoryImpl', () {
    late LoginRepositoryImpl repository;
    late MockAuthApi mockApi;
    late MockPreferencesRepository mockPrefs;

    setUp(() {
      mockApi = MockAuthApi();
      mockPrefs = MockPreferencesRepository();
      repository = LoginRepositoryImpl(mockApi, mockPrefs);
    });

    group('login', () {
      test('should store user tokens and return user on successful login',
          () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final apiUser = auth_api.User(
          accessToken: 'access_token_123',
          refreshToken: 'refresh_token_123',
        );

        when(() => mockApi.login(email: email, password: password))
            .thenAnswer((_) async => apiUser);
        when(() => mockPrefs.setString(key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.login(email: email, password: password);

        // Assert
        expect(result.accessToken, 'access_token_123');
        expect(result.refreshToken, 'refresh_token_123');
        verify(() => mockPrefs.setString(
              key: 'accessToken',
              value: 'access_token_123',
            )).called(1);
        verify(() => mockPrefs.setString(
              key: 'refreshToken',
              value: 'refresh_token_123',
            )).called(1);
      });

      test('should throw exception when login fails', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrong_password';

        when(() => mockApi.login(email: email, password: password))
            .thenThrow(Exception('Unauthorized'));

        // Act & Assert
        expect(
          () => repository.login(email: email, password: password),
          throwsException,
        );
      });
    });

    group('logout', () {
      test('should call api logout and clear stored tokens', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'accessToken'))
            .thenAnswer((_) async => 'access_token_123');
        when(() => mockPrefs.getString(key: 'refreshToken'))
            .thenAnswer((_) async => 'refresh_token_123');
        when(() => mockApi.logout(user: any(named: 'user')))
            .thenAnswer((_) async => {});
        when(() => mockPrefs.remove(key: any(named: 'key')))
            .thenAnswer((_) async => {});

        // Act
        await repository.logout();

        // Assert
        verify(() => mockApi.logout(user: any(named: 'user'))).called(1);
        verify(() => mockPrefs.remove(key: 'accessToken')).called(1);
        verify(() => mockPrefs.remove(key: 'refreshToken')).called(1);
      });

      test('should throw exception when no user is stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => repository.logout(),
          throwsException,
        );
      });
    });

    group('getCurrentUser', () {
      test('should return user when tokens are stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'accessToken'))
            .thenAnswer((_) async => 'access_token_123');
        when(() => mockPrefs.getString(key: 'refreshToken'))
            .thenAnswer((_) async => 'refresh_token_123');

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isNotNull);
        expect(result!.accessToken, 'access_token_123');
        expect(result.refreshToken, 'refresh_token_123');
      });

      test('should return null when no tokens are stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'accessToken'))
            .thenAnswer((_) async => null);
        when(() => mockPrefs.getString(key: 'refreshToken'))
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isNull);
      });
    });
  });
}
