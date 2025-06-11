import '../data/user_model.dart';

abstract class UserRepositoryInterface {
  Future<UserModel> signUp(String username, String email, String password, String role);
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String newPassword, String resetCode);
  Future<UserModel> updateUser(int id, UserModel user);
  Future<UserModel> getUserById(int id,);
  Future<void> deleteUser(int id);
  Future<void> logout(int userId);
}
