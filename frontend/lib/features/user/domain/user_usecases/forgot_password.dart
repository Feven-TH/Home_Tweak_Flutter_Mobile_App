import '../user_repository_interface.dart';

class ForgotPassword {
  final UserRepositoryInterface repository;

  ForgotPassword(this.repository);

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}

