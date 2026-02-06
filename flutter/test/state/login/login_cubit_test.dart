import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/login_state.dart';
import 'package:phone_finder/data/login/login_repository.dart' as repo;

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('LoginCubit', () {
    late LoginCubit cubit;
    late MockLoginUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockLoginUseCase();
      cubit = LoginCubit(mockUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is LoginIdle', () {
      expect(cubit.state, isA<LoginIdle>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginRequested, LoginSuccess] when login succeeds',
      build: () {
        final user = repo.User(
          accessToken: 'access_token',
          refreshToken: 'refresh_token',
        );
        when(() => mockUseCase.execute(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => user);
        return cubit;
      },
      act: (cubit) => cubit.login(
        email: 'test@example.com',
        password: 'password123',
      ),
      expect: () => [
        isA<LoginRequested>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() => mockUseCase.execute(
              email: 'test@example.com',
              password: 'password123',
            )).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginRequested, LoginError] when login fails',
      build: () {
        when(() => mockUseCase.execute(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Invalid credentials'));
        return cubit;
      },
      act: (cubit) => cubit.login(
        email: 'test@example.com',
        password: 'wrong_password',
      ),
      expect: () => [
        isA<LoginRequested>(),
        isA<LoginError>(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginRequested, LoginError] when email is empty',
      build: () {
        when(() => mockUseCase.execute(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Invalid credentials'));
        return cubit;
      },
      act: (cubit) => cubit.login(
        email: '',
        password: 'password123',
      ),
      expect: () => [
        isA<LoginRequested>(),
        isA<LoginError>(),
      ],
    );
  });
}
