import 'package:dio/dio.dart';
import 'user_model.dart'; 

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  // Get user profile by ID
  Future<User> getUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Update user profile
  Future<User> updateUser(int userId, User updatedUser) async {
    try {
      final response = await _dio.put(
        '/users/$userId',
        data: updatedUser.toJson(),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user account
  Future<void> deleteUser(int userId) async {
    try {
      await _dio.delete('/users/$userId');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
