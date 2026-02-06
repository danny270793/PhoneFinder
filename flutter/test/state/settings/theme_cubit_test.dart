import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/state/settings/theme_cubit.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class MockThemeUseCase extends Mock implements ThemeUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('ThemeCubit', () {
    late ThemeCubit cubit;
    late MockThemeUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockThemeUseCase();
      cubit = ThemeCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ThemeIdle', () {
      expect(cubit.state, isA<ThemeIdle>());
    });

    test('currentThemeMode returns system when state is idle', () {
      expect(cubit.currentThemeMode, ThemeMode.system);
    });

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeLoaded] when loadThemeMode succeeds with light',
      build: () {
        when(() => mockUseCase.getThemeModeOrDefault())
            .thenAnswer((_) async => ThemeMode.light);
        return cubit;
      },
      act: (cubit) => cubit.loadThemeMode(),
      expect: () => [
        isA<ThemeLoaded>().having((s) => s.themeMode, 'themeMode', ThemeMode.light),
      ],
      verify: (_) {
        verify(() => mockUseCase.getThemeModeOrDefault()).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeLoaded] when loadThemeMode succeeds with dark',
      build: () {
        when(() => mockUseCase.getThemeModeOrDefault())
            .thenAnswer((_) async => ThemeMode.dark);
        return cubit;
      },
      act: (cubit) => cubit.loadThemeMode(),
      expect: () => [
        isA<ThemeLoaded>().having((s) => s.themeMode, 'themeMode', ThemeMode.dark),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeChanged] when changeThemeMode is called with light',
      build: () {
        when(() => mockUseCase.saveThemeMode(mode: any(named: 'mode')))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.changeThemeMode(mode: ThemeMode.light),
      expect: () => [
        isA<ThemeChanged>().having((s) => s.themeMode, 'themeMode', ThemeMode.light),
      ],
      verify: (_) {
        verify(() => mockUseCase.saveThemeMode(mode: ThemeMode.light))
            .called(1);
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeChanged] when changeThemeMode is called with dark',
      build: () {
        when(() => mockUseCase.saveThemeMode(mode: any(named: 'mode')))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.changeThemeMode(mode: ThemeMode.dark),
      expect: () => [
        isA<ThemeChanged>().having((s) => s.themeMode, 'themeMode', ThemeMode.dark),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeChanged] when changeThemeMode is called with system',
      build: () {
        when(() => mockUseCase.saveThemeMode(mode: any(named: 'mode')))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.changeThemeMode(mode: ThemeMode.system),
      expect: () => [
        isA<ThemeChanged>().having((s) => s.themeMode, 'themeMode', ThemeMode.system),
      ],
    );

    test('currentThemeMode returns correct mode after loading', () async {
      when(() => mockUseCase.getThemeModeOrDefault())
          .thenAnswer((_) async => ThemeMode.dark);

      await cubit.loadThemeMode();

      expect(cubit.currentThemeMode, ThemeMode.dark);
    });

    test('currentThemeMode returns correct mode after changing', () async {
      when(() => mockUseCase.saveThemeMode(mode: any(named: 'mode')))
          .thenAnswer((_) async => {});

      await cubit.changeThemeMode(mode: ThemeMode.dark);

      expect(cubit.currentThemeMode, ThemeMode.dark);
    });
  });
}
