import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/user/data/user_repository.dart';
import 'package:frontend/features/user/domain/user_repository_interface.dart';

void main() {
  late Dio dio;
  late UserRepositoryInterface repository;
  final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
  const testPassword = 'Test@123';

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000')); // Use your actual API base URL
    repository = UserRepository(dio);
  });

  group('UserRepository Integration Tests', () {
    test('Complete user flow: Register → Login → GetUserById', () async {
      // 1. Register
      final registerResponse = await repository.signUp({
        "username": "tester",
        "email": testEmail,
        "password": "Test@123",
        "role": "serviceProvider",
      });

      // Add more thorough null checks
      expect(registerResponse.token, isNotEmpty);
      expect(registerResponse.userId, greaterThan(0));

      // 2. Login
      final loginResponse = await repository.login(testEmail, testPassword);

      expect(loginResponse.token, isNotEmpty);
      expect(loginResponse.userId, registerResponse.userId);

      // 3. Get User Details
      final user = await repository.getUserById(registerResponse.userId!);
      expect(user.id, registerResponse.userId);
      expect(user.username, "tester");
      expect(user.email, testEmail);
      expect(user.role, "customer");

      // 4. Cleanup - Delete test user (if your API supports this)
      try {
        await repository.deleteUser(registerResponse.userId!);
      } catch (e) {
        print('Cleanup failed: $e');
      }
    }, timeout: Timeout(Duration(seconds: 30))); // Extended timeout for integration tests

    test('Login with invalid credentials should fail', () async {
      expect(
            () async => await repository.login('nonexistent@example.com', 'wrongpassword'),
        throwsA(isA<Exception>()),
      );
    });

    test('Get non-existent user should fail', () async {
      expect(
            () async => await repository.getUserById(999999),
        throwsA(isA<Exception>()),
      );
    });
  });
}