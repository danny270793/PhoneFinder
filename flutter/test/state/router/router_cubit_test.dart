import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/router/router_state.dart';

class MockRouterUseCase extends Mock implements RouterUseCase {}

void main() {
  group('RouterCubit', () {
    late RouterCubit cubit;
    late MockRouterUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockRouterUseCase();
      cubit = RouterCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is RouterIdle', () {
      expect(cubit.state, isA<RouterIdle>());
    });

    blocTest<RouterCubit, RouterState>(
      'emits [RouterCheckAuthRequested, RouterCheckAuthSuccess] when user is logged in',
      build: () {
        when(() => mockUseCase.execute()).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        isA<RouterCheckAuthRequested>(),
        isA<RouterCheckAuthSuccess>()
            .having((s) => s.isLogged, 'isLogged', true),
      ],
      verify: (_) {
        verify(() => mockUseCase.execute()).called(1);
      },
    );

    blocTest<RouterCubit, RouterState>(
      'emits [RouterCheckAuthRequested, RouterCheckAuthSuccess] when user is not logged in',
      build: () {
        when(() => mockUseCase.execute()).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        isA<RouterCheckAuthRequested>(),
        isA<RouterCheckAuthSuccess>()
            .having((s) => s.isLogged, 'isLogged', false),
      ],
    );

    blocTest<RouterCubit, RouterState>(
      'emits [RouterCheckAuthRequested, RouterCheckAuthError] when check fails',
      build: () {
        when(() => mockUseCase.execute())
            .thenThrow(Exception('Auth check failed'));
        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        isA<RouterCheckAuthRequested>(),
        isA<RouterCheckAuthError>(),
      ],
    );

    blocTest<RouterCubit, RouterState>(
      'emits [RouterCheckAuthSuccess(true)] on login success',
      build: () => cubit,
      act: (cubit) => cubit.onLoginSuccess(),
      expect: () => [
        isA<RouterCheckAuthSuccess>()
            .having((s) => s.isLogged, 'isLogged', true),
      ],
    );

    blocTest<RouterCubit, RouterState>(
      'emits [RouterCheckAuthSuccess(false)] on logout success',
      build: () => cubit,
      act: (cubit) => cubit.onLogoutSuccess(),
      expect: () => [
        isA<RouterCheckAuthSuccess>()
            .having((s) => s.isLogged, 'isLogged', false),
      ],
    );
  });
}
