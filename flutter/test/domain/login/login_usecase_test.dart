import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockLoginRepository mockRepository;

    setUp(() {
      mockRepository = MockLoginRepository();
      useCase = LoginUseCase(mockRepository);
    });

    test('should return user when credentials are valid', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final user = User(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
      );

      when(() => mockRepository.login(email: email, password: password))
          .thenAnswer((_) async => user);

      // Act
      final result = await useCase.execute(email: email, password: password);

      // Assert
      expect(result, user);
      verify(() => mockRepository.login(email: email, password: password))
          .called(1);
    });

    test('should throw exception when email is empty', () async {
      // Arrange
      const email = '';
      const password = 'password123';

      // Act & Assert
      expect(
        () => useCase.execute(email: email, password: password),
        throwsException,
      );
      verifyNever(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('should throw exception when password is empty', () async {
      // Arrange
      const email = 'test@example.com';
      const password = '';

      // Act & Assert
      expect(
        () => useCase.execute(email: email, password: password),
        throwsException,
      );
      verifyNever(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('should throw exception when both email and password are empty',
        () async {
      // Arrange
      const email = '';
      const password = '';

      // Act & Assert
      expect(
        () => useCase.execute(email: email, password: password),
        throwsException,
      );
      verifyNever(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });
  });
}
