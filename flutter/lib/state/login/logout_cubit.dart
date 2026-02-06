import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/state/login/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutIdle());

  Future<void> logout() async {
    emit(LogoutRequested());

    try {
      await logoutUseCase.execute();
      emit(LogoutSuccess());
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(LogoutError(message: e.toString()));
    }
  }
}
