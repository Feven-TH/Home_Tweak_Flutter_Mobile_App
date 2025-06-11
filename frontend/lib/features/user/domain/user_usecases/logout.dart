import '../user_repository_interface.dart';

class LogoutUser {
  final UserRepositoryInterface repository;

  LogoutUser(this.repository);

  Future<void> call(int userId) {
    return repository.logout(userId);
  }
}
