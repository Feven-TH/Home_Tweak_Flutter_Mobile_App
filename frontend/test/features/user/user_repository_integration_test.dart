import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/dio_client.dart';
import 'package:frontend/features/user/data/user_repository.dart';
import 'package:frontend/features/user/data/user_model.dart';

void main() {
  late UserRepository repository;
  late Dio dio;

  setUp(() {
    dio = DioClient() as Dio;
    repository = UserRepository(dio);
  });

  group('UserRepository Integration Tests', () {
    test('should successfully sign up a new user', () async {
      // Arrange
      final username = 'testuser';
      final email = 'test@example.com';
      final password = 'password123';
      final role = 'user';

      // Act
      final result = await repository.signUp(username, email, password, role);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.username, equals(username));
      expect(result.email, equals(email));
      expect(result.role, equals(role));
      expect(result.isLoggedIn, isTrue);
    });

    test('should successfully login an existing user', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      // Act
      final result = await repository.login(email, password);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.email, equals(email));
      expect(result.isLoggedIn, isTrue);
    });

    test('should successfully get user by id', () async {
      // Arrange
      final userId = 1; // Assuming this user exists

      // Act
      final result = await repository.getUserById(userId);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.userId, equals(userId));
    });

    test('should successfully update user', () async {
      // Arrange
      final userId = 1; // Assuming this user exists
      final updatedUser = UserModel(
        userId: userId,
        username: 'updateduser',
        email: 'updated@example.com',
        role: 'user',
        isLoggedIn: true,
      );

      // Act
      final result = await repository.updateUser(userId, updatedUser);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.username, equals('updateduser'));
      expect(result.email, equals('updated@example.com'));
    });

    test('should successfully handle forgot password request', () async {
      // Arrange
      final email = 'test@example.com';

      // Act & Assert
      expect(() => repository.forgotPassword(email), completes);
    });

    test('should successfully handle password reset', () async {
      // Arrange
      final email = 'test@example.com';
      final newPassword = 'newpassword123';
      final resetCode = '123456'; // This should be a valid reset code

      // Act & Assert
      expect(() => repository.resetPassword(email, newPassword, resetCode),
          completes);
    });

    test('should successfully logout user', () async {
      // Arrange
      final userId = 1; // Assuming this user exists

      // Act & Assert
      expect(() => repository.logout(userId), completes);
    });

    test('should successfully delete user account', () async {
      // Arrange
      final userId = 1; // Assuming this user exists

      // Act & Assert
      expect(() => repository.deleteUser(userId), completes);
    });
  });
}
