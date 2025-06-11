import '../user_repository_interface.dart';

class DeleteUser {
  final UserRepositoryInterface repository;

  DeleteUser(this.repository);

  Future<void> call(int id) {
    return repository.deleteUser(id);
  }
}
