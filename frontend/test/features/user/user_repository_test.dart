import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/user/data/user_repository.dart';

void main() {
  group('UserRepository Unit Tests', () {
    final repository = UserRepository();

    test('Login with valid credentials returns a user', () async {
      final user = await repository.login('test@example.com', 'password123');
      expect(user.email, equals('test@example.com'));
    });

    test('Register with valid credentials returns a user', () async {
      final user = await repository.signUp({
        'email': 'new@example.com',
        'password': 'password123',
        'name': 'Test User'
      });
      expect(user.email, equals('new@example.com'));
    });
  });
}
