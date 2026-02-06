import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/data/settings/locale_storage.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

void main() {
  group('LocaleStorageImpl', () {
    late LocaleStorageImpl storage;
    late MockPreferencesRepository mockPrefs;

    setUp(() {
      mockPrefs = MockPreferencesRepository();
      storage = LocaleStorageImpl(mockPrefs);
    });

    group('saveLocale', () {
      test('should save language code to preferences', () async {
        // Arrange
        const languageCode = 'es';
        when(() => mockPrefs.setString(key: 'selected_locale', value: 'es'))
            .thenAnswer((_) async => {});

        // Act
        await storage.saveLocale(languageCode: languageCode);

        // Assert
        verify(() => mockPrefs.setString(key: 'selected_locale', value: 'es')).called(1);
      });
    });

    group('getLocale', () {
      test('should return language code when stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'selected_locale'))
            .thenAnswer((_) async => 'es');

        // Act
        final result = await storage.getLocale();

        // Assert
        expect(result, 'es');
      });

      test('should return null when no locale is stored', () async {
        // Arrange
        when(() => mockPrefs.getString(key: 'selected_locale'))
            .thenAnswer((_) async => null);

        // Act
        final result = await storage.getLocale();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearLocale', () {
      test('should remove locale from preferences', () async {
        // Arrange
        when(() => mockPrefs.remove(key: 'selected_locale'))
            .thenAnswer((_) async => {});

        // Act
        await storage.clearLocale();

        // Assert
        verify(() => mockPrefs.remove(key: 'selected_locale')).called(1);
      });
    });
  });
}
