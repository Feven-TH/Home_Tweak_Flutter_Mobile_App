import '../user_repository_interface.dart';

class LoginUser {
  final UserRepositoryInterface repository;

  LoginUser(this.repository);

  Future<Map<String, dynamic>> call(
      String email,
      String password,
      ) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
