sealed class RouterState {}

class RouterIdle extends RouterState {}

class RouterInitRequested extends RouterState {}

class RouterInitSuccess extends RouterState {
  final bool isLogged;
  RouterInitSuccess(this.isLogged);
}

class RouterInitError extends RouterState {
  final String message;
  RouterInitError(this.message);
}
