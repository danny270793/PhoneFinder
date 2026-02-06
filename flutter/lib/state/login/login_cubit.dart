import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/state/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginIdle());

  Future<void> login(String email, String password) async {
    emit(LoginRequested());

    try {
      await loginUseCase.execute(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
