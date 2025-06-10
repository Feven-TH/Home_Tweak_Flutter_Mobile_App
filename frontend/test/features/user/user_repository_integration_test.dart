import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/user/data/user_repository.dart';
import 'package:frontend/features/user/data/user_model.dart';
import 'package:frontend/features/user/domain/user_repository_interface.dart';

void main() {
  late Dio dio;
  late UserRepositoryInterface repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000')); // Or use your emulator IP
    repository = UserRepository(dio);
  });

  group('UserRepository Integration Tests', () {
    test('Register, Login, GetUserById flow', () async {

      const email = 'test@example.com';
      const password = 'Test@123';

      // Register
      final registerResponse = await repository.signup({
        "username": "tester",
        "email": "test@example.com",
        "password": "Test@123",
        "role": "serviceProvider",
      });

      expect(registerResponse.token, isNotEmpty);
      expect(registerResponse.userId, isNonZero);
      expect(registerResponse.role, equals('serviceProvider'));

      // Login
      final loginResponse = await repository.login(email, password);


      expect(loginResponse.token, isNotEmpty);
      expect(loginResponse.userId, registerResponse.userId);

      // Get User
      final user = await repository.getUserById(registerResponse.userId!);
      expect(user.email, 'test@example.com');
      expect(user.username, 'tester');
    });
  });
}
