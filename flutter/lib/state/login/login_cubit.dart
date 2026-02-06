import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/state/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginIdle());

  Future<void> login({required String email, required String password}) async {
    emit(LoginRequested());

    try {
      await loginUseCase.execute(email: email, password: password);
      emit(LoginSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(LoginError(message: e.toString()));
    }
  }
}
