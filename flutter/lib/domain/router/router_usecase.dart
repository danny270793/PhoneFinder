import 'package:phone_finder/data/login/login_repository.dart';

class RouterUseCase {
  final LoginRepository repository;

  RouterUseCase(this.repository);

  Future<bool> execute() async {
    return await repository.getCurrentUser()!= null;
  }
}
