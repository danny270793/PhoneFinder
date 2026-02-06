import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/state/base_cubit.dart';
import 'package:phone_finder/state/login/login_state.dart';

class LoginCubit extends BaseCubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginIdle());

  Future<void> login(String email, String password) async {
    emit(LoginRequested());

    await safeExecute(
      () async {
        await loginUseCase.execute(email, password);
        emit(LoginSuccess());
      },
      onError: (error, stackTrace) {
        emit(LoginError(error.toString()));
      },
    );
  }
}
