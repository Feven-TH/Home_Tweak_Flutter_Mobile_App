import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../domain/user_repository_interface.dart';
import 'user_model.dart';

class UserRepository implements UserRepositoryInterface {
  final Dio _dio;

  UserRepository(this._dio);

  @override
  Future<UserModel> signup(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(ApiEndpoints.signup, data: userData);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to send forgot password code: $e');
    }
  }

  @override
  Future<void> resetPassword(String email, String newPassword,
      String resetCode) async {
    try {
      await _dio.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'resetCode': resetCode,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<User> updateUser(int id, UserModel user) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateUser,
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.getUserById(id));
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete(ApiEndpoints.deleteAccount(id));
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<void> logout(int id) async {
    try {
      await _dio.post(ApiEndpoints.logout(id));
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
