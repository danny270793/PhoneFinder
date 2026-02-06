import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class MockLocaleUseCase extends Mock implements LocaleUseCase {}

void main() {
  group('LocaleCubit', () {
    late LocaleCubit cubit;
    late MockLocaleUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockLocaleUseCase();
      cubit = LocaleCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is LocaleIdle', () {
      expect(cubit.state, isA<LocaleIdle>());
    });

    test('currentLocale returns English when state is idle', () {
      expect(cubit.currentLocale, const Locale('en'));
    });

    blocTest<LocaleCubit, LocaleState>(
      'emits [LocaleLoaded] when loadLocale succeeds',
      build: () {
        when(() => mockUseCase.getLocaleOrDefault())
            .thenAnswer((_) async => const Locale('es'));
        return cubit;
      },
      act: (cubit) => cubit.loadLocale(),
      expect: () => [
        isA<LocaleLoaded>().having((s) => s.locale, 'locale', const Locale('es')),
      ],
      verify: (_) {
        verify(() => mockUseCase.getLocaleOrDefault()).called(1);
      },
    );

    blocTest<LocaleCubit, LocaleState>(
      'emits [LocaleChanged] when changeLocale is called',
      build: () {
        when(() => mockUseCase.saveLocale(languageCode: any(named: 'languageCode')))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.changeLocale(languageCode: 'es'),
      expect: () => [
        isA<LocaleChanged>().having((s) => s.locale, 'locale', const Locale('es')),
      ],
      verify: (_) {
        verify(() => mockUseCase.saveLocale(languageCode: 'es')).called(1);
      },
    );

    test('currentLocale returns correct locale after loading', () async {
      when(() => mockUseCase.getLocaleOrDefault())
          .thenAnswer((_) async => const Locale('es'));

      await cubit.loadLocale();

      expect(cubit.currentLocale, const Locale('es'));
    });

    test('currentLocale returns correct locale after changing', () async {
      when(() => mockUseCase.saveLocale(languageCode: any(named: 'languageCode')))
          .thenAnswer((_) async => {});

      await cubit.changeLocale(languageCode: 'es');

      expect(cubit.currentLocale, const Locale('es'));
    });
  });
}
