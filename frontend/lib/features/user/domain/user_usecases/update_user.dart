import '../../data/user_model.dart';
import '../user_repository_interface.dart';

class UpdateUser {
  final UserRepositoryInterface repository;

  UpdateUser(this.repository);

  Future<UserModel> call(int id, UserModel user) {
    return repository.updateUser(id, user);
  }
}
