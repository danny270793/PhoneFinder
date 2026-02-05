import 'package:phone_finder/domain/auth/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute(User user) {
    return repository.logout(user);
  }
}
