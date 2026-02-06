sealed class LoginState {}

class LoginIdle extends LoginState {}

class LoginRequested extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError({required this.message});
}
