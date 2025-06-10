import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/user/data/user_repository.dart';
import 'package:frontend/features/user/data/user_model.dart';
import 'package:frontend/features/user/domain/user_repository_interface.dart';

void main() {
  late Dio dio;
  late IUserRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000')); // Or use your emulator IP
    repository = UserRepository(dio);
  });

  group('UserRepository Integration Tests', () {
    test('Register, Login, GetUserById flow', () async {
      // Register
      final registerResponse = await repository.registerUser(
        username: 'testuser',
        email: 'testuser@example.com',
        password: 'testpass123',
        role: 'customer',
      );

      expect(registerResponse.token, isNotEmpty);
      expect(registerResponse.userId, isNonZero);
      expect(registerResponse.role, equals('customer'));

      // Login
      final loginResponse = await repository.loginUser(
        email: 'testuser@example.com',
        password: 'testpass123',
      );

      expect(loginResponse.token, isNotEmpty);
      expect(loginResponse.userId, registerResponse.userId);

      // Get User
      final user = await repository.getUserById(registerResponse.userId!);
      expect(user.email, 'testuser@example.com');
      expect(user.username, 'testuser');
    });
  });
}
