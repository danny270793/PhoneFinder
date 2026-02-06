import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('ThemeUseCase', () {
    late ThemeUseCase useCase;
    late MockThemeRepository mockRepository;

    setUp(() {
      mockRepository = MockThemeRepository();
      useCase = ThemeUseCase(mockRepository);
    });

    group('saveThemeMode', () {
      test('should save light theme mode to repository', () async {
        // Arrange
        when(() => mockRepository.saveThemeMode(mode: ThemeMode.light))
            .thenAnswer((_) async => {});

        // Act
        await useCase.saveThemeMode(mode: ThemeMode.light);

        // Assert
        verify(() => mockRepository.saveThemeMode(mode: ThemeMode.light))
            .called(1);
      });

      test('should save dark theme mode to repository', () async {
        // Arrange
        when(() => mockRepository.saveThemeMode(mode: ThemeMode.dark))
            .thenAnswer((_) async => {});

        // Act
        await useCase.saveThemeMode(mode: ThemeMode.dark);

        // Assert
        verify(() => mockRepository.saveThemeMode(mode: ThemeMode.dark))
            .called(1);
      });

      test('should save system theme mode to repository', () async {
        // Arrange
        when(() => mockRepository.saveThemeMode(mode: ThemeMode.system))
            .thenAnswer((_) async => {});

        // Act
        await useCase.saveThemeMode(mode: ThemeMode.system);

        // Assert
        verify(() => mockRepository.saveThemeMode(mode: ThemeMode.system))
            .called(1);
      });
    });

    group('getThemeMode', () {
      test('should return light theme mode from repository', () async {
        // Arrange
        when(() => mockRepository.getThemeMode())
            .thenAnswer((_) async => ThemeMode.light);

        // Act
        final result = await useCase.getThemeMode();

        // Assert
        expect(result, ThemeMode.light);
      });

      test('should return dark theme mode from repository', () async {
        // Arrange
        when(() => mockRepository.getThemeMode())
            .thenAnswer((_) async => ThemeMode.dark);

        // Act
        final result = await useCase.getThemeMode();

        // Assert
        expect(result, ThemeMode.dark);
      });

      test('should return null when no theme is stored', () async {
        // Arrange
        when(() => mockRepository.getThemeMode())
            .thenAnswer((_) async => null);

        // Act
        final result = await useCase.getThemeMode();

        // Assert
        expect(result, isNull);
      });
    });

    group('getThemeModeOrDefault', () {
      test('should return stored theme mode', () async {
        // Arrange
        when(() => mockRepository.getThemeMode())
            .thenAnswer((_) async => ThemeMode.dark);

        // Act
        final result = await useCase.getThemeModeOrDefault();

        // Assert
        expect(result, ThemeMode.dark);
      });

      test('should return system theme mode when none is stored', () async {
        // Arrange
        when(() => mockRepository.getThemeMode())
            .thenAnswer((_) async => null);

        // Act
        final result = await useCase.getThemeModeOrDefault();

        // Assert
        expect(result, ThemeMode.system);
      });
    });

    group('clearThemeMode', () {
      test('should clear theme mode from repository', () async {
        // Arrange
        when(() => mockRepository.clearThemeMode())
            .thenAnswer((_) async => {});

        // Act
        await useCase.clearThemeMode();

        // Assert
        verify(() => mockRepository.clearThemeMode()).called(1);
      });
    });
  });
}
