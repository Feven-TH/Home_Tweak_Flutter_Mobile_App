import '../user_repository_interface.dart';

class ResetPassword {
  final UserRepositoryInterface repository;

  ResetPassword(this.repository);

  Future<void> call(String email, String resetCode, String newPassword) {
    return repository.resetPassword(email, resetCode, newPassword);
  }
}
