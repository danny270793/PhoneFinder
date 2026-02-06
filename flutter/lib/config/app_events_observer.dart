import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/config/dependency_injection.dart';
import 'package:phone_finder/core/logger.dart';
import 'package:phone_finder/ui/pages/error_page.dart';

class AppEventsObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    logger.d('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.d('onEvent: ${bloc.runtimeType} - $event');
  }
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.d('onChange: ${bloc.runtimeType} - $change');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    logger.d('onTransition: ${bloc.runtimeType} - $transition');
  }
  
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e('onError: ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    
    _navigateToError();
  }

  @override
  void onDone(Bloc<dynamic, dynamic> bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    super.onDone(bloc, event, error, stackTrace);
    logger.d('onDone: ${bloc.runtimeType} - event: $event - error: $error');
  }
  
  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    logger.d('onClose: ${bloc.runtimeType}');
  }

  void _navigateToError() {
    try {
      final router = getIt<GoRouter>();
      if (router.routerDelegate.currentConfiguration.last.matchedLocation != ErrorPage.routeName) {
        router.go(ErrorPage.routeName);
      }
    } catch (e) {
      logger.e('Failed to navigate to error page', error: e);
    }
  }
}
