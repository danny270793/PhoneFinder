import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/state/base_cubit.dart';
import 'package:phone_finder/state/router/router_state.dart';

class RouterCubit extends BaseCubit<RouterState> {
  final RouterUseCase routerUseCase;

  RouterCubit(this.routerUseCase) : super(RouterIdle()) {}

  Future<void> init() async {
    emit(RouterCheckAuthRequested());

    await safeExecute(
      () async {
        await Future.delayed(const Duration(seconds: 1));
        final isLogged = await routerUseCase.execute();
        emit(RouterCheckAuthSuccess(isLogged));
      },
      onError: (error, stackTrace) {
        emit(RouterCheckAuthError(error.toString()));
      },
    );
  }

  void onLoginSuccess() {
    emit(RouterCheckAuthSuccess(true));
  }

  void onLogoutSuccess() {
    emit(RouterCheckAuthSuccess(false));
  }
}
