sealed class LogoutState {}

class LogoutIdle extends LogoutState {}

class LogoutRequested extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {
  final String message;
  LogoutError(this.message);
}
