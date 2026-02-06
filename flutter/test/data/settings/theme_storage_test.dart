import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/data/settings/theme_storage.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

void main() {
  group('ThemeStorageImpl', () {
    late ThemeStorageImpl storage;
    late MockPreferencesRepository mockPrefs;

    setUp(() {
      mockPrefs = MockPreferencesRepository();
      storage = ThemeStorageImpl(mockPrefs);
    });

    group('saveThemeMode', () {
      test('should save light theme mode to preferences', () async {
        // Arrange
        when(() => mockPrefs.setString(key: 'theme_mode', value: 'light'))
            .thenAnswer((_) async => {});

        // Act
        await storage.saveThemeMode(mode: ThemeMode.light);

        // Assert
        verify(() => mockPrefs.setString(key: 'theme_mode', value: 'light'))
            .called(1);
      });

      test('should save dark theme mode to preferences', () async {
        // Arrange
        when(() => mockPrefs.setString(key: 'theme_mode', value: 'dark'))
            .thenAnswer((_) async => {});

        // Act
        await storage.saveThemeMode(mode: ThemeMode.dark);

        // Assert
        verify(() => mockPrefs.setString(key: 'theme_mode', value: 'dark'))
            .called(1);
      });

      test('should save system theme mode to preferences', () async {
        // Arrange
        when(() => mockPrefs.setString(key: 'theme_mode', value: 'system'))
            .thenAnswer((_) async => {});

        // Act
        await storage.saveThemeMode(mode: ThemeMode.system);

        // Assert
        verify(() => mockPrefs.setString(key: 'theme_mode', value: 'system'))
            .called(1);
      });
    });

    group('getThemeMode', () {
      test('should return light mode when stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'theme_mode'))
            .thenAnswer((_) async => 'light');

        // Act
        final result = await storage.getThemeMode();

        // Assert
        expect(result, ThemeMode.light);
      });

      test('should return dark mode when stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'theme_mode'))
            .thenAnswer((_) async => 'dark');

        // Act
        final result = await storage.getThemeMode();

        // Assert
        expect(result, ThemeMode.dark);
      });

      test('should return system mode when stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'theme_mode'))
            .thenAnswer((_) async => 'system');

        // Act
        final result = await storage.getThemeMode();

        // Assert
        expect(result, ThemeMode.system);
      });

      test('should return null when no theme is stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'theme_mode'))
            .thenAnswer((_) async => null);

        // Act
        final result = await storage.getThemeMode();

        // Assert
        expect(result, isNull);
      });

      test('should return null when invalid theme is stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'theme_mode'))
            .thenAnswer((_) async => 'invalid');

        // Act
        final result = await storage.getThemeMode();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearThemeMode', () {
      test('should remove theme mode from preferences', () async {
        // Arrange
        when(() => mockPrefs.remove(key: 'theme_mode'))
            .thenAnswer((_) async => {});

        // Act
        await storage.clearThemeMode();

        // Assert
        verify(() => mockPrefs.remove(key: 'theme_mode')).called(1);
      });
    });
  });
}
