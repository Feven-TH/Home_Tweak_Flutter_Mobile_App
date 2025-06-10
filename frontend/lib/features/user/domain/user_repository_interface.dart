import '../data/user_model.dart';

abstract class UserRepositoryInterface {
  Future<UserModel> signup(Map<String, dynamic> userData);
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String newPassword, String resetCode);
  Future<UserModel> getUserById(int id);
  Future<void> deleteUser(int id);
  Future<void> logout(int id);
}
