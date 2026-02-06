import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/state/base_cubit.dart';
import 'package:phone_finder/state/login/logout_state.dart';

class LogoutCubit extends BaseCubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutIdle());

  @override
  LogoutState createErrorState(String message) => LogoutError(message);

  Future<void> logout() async {
    emit(LogoutRequested());

    await safeExecute(() async {
      await logoutUseCase.execute();
      emit(LogoutSuccess());
    });
  }
}
