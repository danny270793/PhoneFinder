import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/config/dependency_injection.dart';
import 'package:phone_finder/ui/pages/error_page.dart';

class AppEventsObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    print('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent: ${bloc.runtimeType} - $event');
  }
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('onChange: ${bloc.runtimeType} - $change');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    print('onTransition: ${bloc.runtimeType} - $transition');
  }
  
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('onError: ${bloc.runtimeType} - $error');
    
    // Navigate to error page on any unhandled error
    _navigateToError();
  }

  @override
  void onDone(Bloc<dynamic, dynamic> bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    super.onDone(bloc, event, error, stackTrace);
    print('onDone: ${bloc.runtimeType} - $event - $error - $stackTrace');
  }
  
  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    print('onClose: ${bloc.runtimeType}');
  }

  void _navigateToError() {
    try {
      final router = getIt<GoRouter>();
      // Avoid navigating if already on error page
      if (router.routerDelegate.currentConfiguration.last.matchedLocation != ErrorPage.routeName) {
        router.go(ErrorPage.routeName);
      }
    } catch (e) {
      print('Failed to navigate to error page: $e');
    }
  }
}
