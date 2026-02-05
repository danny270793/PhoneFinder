import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/state/router/router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  final RouterUseCase routerUseCase;

  RouterCubit(this.routerUseCase) : super(RouterIdle()) {
    init();
  }

  Future<void> init() async {
    emit(RouterCheckAuthRequested());

    try {
      await Future.delayed(const Duration(seconds: 1));
      final isLogged = await routerUseCase.execute();
      emit(RouterCheckAuthSuccess(isLogged));
    } catch (e) {
      emit(RouterCheckAuthError(e.toString()));
    }
  }

  void onLoginSuccess() {
    emit(RouterCheckAuthSuccess(true));
  }

  void onLogoutSuccess() {
    emit(RouterCheckAuthSuccess(false));
  }
}
