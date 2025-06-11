import '../../data/user_model.dart';
import '../user_repository_interface.dart';

class SignUpUser {
  final UserRepositoryInterface repository;

  SignUpUser(this.repository);

  Future<UserModel> call(String username, String email, String password, String role) {
    return repository.signUp(username, email, password, role);
  }
}
