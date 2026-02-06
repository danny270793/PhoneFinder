import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';

class MockLocaleRepository extends Mock implements LocaleRepository {}

void main() {
  // Ensure Flutter binding is initialized for tests that need it
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleUseCase', () {
    late LocaleUseCase useCase;
    late MockLocaleRepository mockRepository;

    setUp(() {
      mockRepository = MockLocaleRepository();
      useCase = LocaleUseCase(mockRepository);
    });

    group('saveLocale', () {
      test('should save language code to repository', () async {
        // Arrange
        const languageCode = 'es';
        when(() => mockRepository.saveLocale(languageCode: languageCode))
            .thenAnswer((_) async => {});

        // Act
        await useCase.saveLocale(languageCode: languageCode);

        // Assert
        verify(() => mockRepository.saveLocale(languageCode: languageCode))
            .called(1);
      });
    });

    group('getLocale', () {
      test('should return language code from repository', () async {
        // Arrange
        when(() => mockRepository.getLocale())
            .thenAnswer((_) async => 'es');

        // Act
        final result = await useCase.getLocale();

        // Assert
        expect(result, 'es');
      });

      test('should return null when no locale is stored', () async {
        // Arrange
        when(() => mockRepository.getLocale())
            .thenAnswer((_) async => null);

        // Act
        final result = await useCase.getLocale();

        // Assert
        expect(result, isNull);
      });
    });

    group('getLocaleOrDefault', () {
      test('should return stored locale as Locale object', () async {
        // Arrange
        when(() => mockRepository.getLocale())
            .thenAnswer((_) async => 'es');

        // Act
        final result = await useCase.getLocaleOrDefault();

        // Assert
        expect(result, const Locale('es'));
      });

      test('should return default device locale when none is stored',
          () async {
        // Arrange
        when(() => mockRepository.getLocale())
            .thenAnswer((_) async => null);

        // Act
        final result = await useCase.getLocaleOrDefault();

        // Assert
        // Device locale could be en, en_US, etc. - just verify it's a valid Locale
        expect(result, isA<Locale>());
        expect(result.languageCode, 'en'); // Language code should be 'en'
      });
    });

    group('clearLocale', () {
      test('should clear locale from repository', () async {
        // Arrange
        when(() => mockRepository.clearLocale())
            .thenAnswer((_) async => {});

        // Act
        await useCase.clearLocale();

        // Assert
        verify(() => mockRepository.clearLocale()).called(1);
      });
    });
  });
}
