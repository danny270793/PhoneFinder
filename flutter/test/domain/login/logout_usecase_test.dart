import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  group('LogoutUseCase', () {
    late LogoutUseCase useCase;
    late MockLoginRepository mockRepository;

    setUp(() {
      mockRepository = MockLoginRepository();
      useCase = LogoutUseCase(mockRepository);
    });

    test('should call repository logout', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer((_) async => {});

      // Act
      await useCase.execute();

      // Assert
      verify(() => mockRepository.logout()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenThrow(Exception('Logout failed'));

      // Act & Assert
      expect(() => useCase.execute(), throwsException);
    });
  });
}
