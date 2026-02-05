import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/state/router/router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  final RouterUseCase routerUseCase;

  RouterCubit(this.routerUseCase) : super(RouterIdle());

  Future<void> init() async {
    emit(RouterInitRequested());

    try {
      final isLogged = await routerUseCase.execute();
      emit(RouterInitSuccess(isLogged));
    } catch (e) {
      emit(RouterInitError(e.toString()));
    }
  }
}
