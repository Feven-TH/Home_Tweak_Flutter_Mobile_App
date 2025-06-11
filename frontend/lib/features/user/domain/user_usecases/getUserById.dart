import '../user_repository_interface.dart';
import '../../data/user_model.dart';

class GetUserById {
  final UserRepositoryInterface repository;

  GetUserById(this.repository);

  Future<User> call(int id, String token) {
    return repository.getUserById(id: id, token: token);
  }
}
