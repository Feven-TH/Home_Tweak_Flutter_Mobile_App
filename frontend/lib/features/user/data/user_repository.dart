import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../domain/user_repository_interface.dart';
import 'user_model.dart';

class UserRepository implements UserRepositoryInterface {
  final Dio _dio;

  UserRepository(this._dio);

  @override
  Future<Map<String, dynamic>> signUp({
    String? username,
    String? email,
    String? password,
    String? role,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.signup, data: {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      });

      return {
        'token': response.data['token'],
        'userId': response.data['userId'],
        'role': response.data['role'],
      };
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> login({
    String? email,
    String? password,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      return {
        'token': response.data['token'],
        'userId': response.data['userId'],
        'role': response.data['role'],
      };
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> forgotPassword({String? email}) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to send forgot password code: $e');
    }
  }

  @override
  Future<void> resetPassword({
    String? email,
    String? resetCode,
    String? newPassword,
  }) async {
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
  Future<UserModel> getUserById({int? id, String? token}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getUserById(id!),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<void> deleteUser({int? id, String? token}) async {
    try {
      await _dio.delete(
        ApiEndpoints.deleteAccount(id!),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<void> logout({int? userId}) async {
    try {
      await _dio.post(ApiEndpoints.logout(userId!));
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
