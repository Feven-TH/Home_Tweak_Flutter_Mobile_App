import '../../data/user_model.dart';
import '../user_repository_interface.dart';

class LoginUser {
  final UserRepositoryInterface repository;

  LoginUser(this.repository);

  Future<UserModel> call(String email, String password) {
    return repository.login(email, password);
  }
}
