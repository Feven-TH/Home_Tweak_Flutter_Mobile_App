import '../user_repository_interface.dart';

class DeleteUser {
  final UserRepositoryInterface repository;

  DeleteUser(this.repository);

  Future<void> call(int id, String token) {
    return repository.deleteUser(id: id, token: token);
  }
}
