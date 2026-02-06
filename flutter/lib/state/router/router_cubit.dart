import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/state/router/router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  final RouterUseCase routerUseCase;

  RouterCubit(this.routerUseCase) : super(RouterIdle()) {}

  Future<void> init() async {
    emit(RouterCheckAuthRequested());

    try {
      final isLogged = await routerUseCase.execute();
      emit(RouterCheckAuthSuccess(isLogged));
    } catch (e, stackTrace) {
      addError(e, stackTrace); // Notify AppEventsObserver
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
