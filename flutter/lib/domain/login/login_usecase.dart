import 'package:phone_finder/data/login/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<User> execute(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }
    return repository.login(
      email: email,
      password: password,
    );
  }
}
