sealed class RouterState {}

class RouterIdle extends RouterState {}

class RouterCheckAuthRequested extends RouterState {}

class RouterCheckAuthSuccess extends RouterState {
  final bool isLogged;
  RouterCheckAuthSuccess({required this.isLogged});
}

class RouterCheckAuthError extends RouterState {
  final String message;
  RouterCheckAuthError({required this.message});
}
