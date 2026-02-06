import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/login/logout_state.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  group('LogoutCubit', () {
    late LogoutCubit cubit;
    late MockLogoutUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockLogoutUseCase();
      cubit = LogoutCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is LogoutIdle', () {
      expect(cubit.state, isA<LogoutIdle>());
    });

    blocTest<LogoutCubit, LogoutState>(
      'emits [LogoutRequested, LogoutSuccess] when logout succeeds',
      build: () {
        when(() => mockUseCase.execute()).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutRequested>(),
        isA<LogoutSuccess>(),
      ],
      verify: (_) {
        verify(() => mockUseCase.execute()).called(1);
      },
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits [LogoutRequested, LogoutError] when logout fails',
      build: () {
        when(() => mockUseCase.execute())
            .thenThrow(Exception('Logout failed'));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<LogoutRequested>(),
        isA<LogoutError>(),
      ],
    );
  });
}
