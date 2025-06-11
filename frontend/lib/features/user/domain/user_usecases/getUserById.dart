import '../../data/user_model.dart';
import '../user_repository_interface.dart';

class GetUserById {
  final UserRepositoryInterface repository;

  GetUserById(this.repository);

  Future<UserModel> call(int id) {
    return repository.getUserById(id);
  }
}
