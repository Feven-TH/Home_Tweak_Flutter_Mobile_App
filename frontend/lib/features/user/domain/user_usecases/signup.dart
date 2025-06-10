import '../user_repository_interface.dart';

class SignUpUser {
  final UserRepositoryInterface repository;

  SignUpUser(this.repository);

  Future<Map<String, dynamic>> call(
      String username,
      String email,
      String password,
      String role,
      ) {
    return repository.signUp(
      username: username,
      email: email,
      password: password,
      role: role,
    );
  }
}
