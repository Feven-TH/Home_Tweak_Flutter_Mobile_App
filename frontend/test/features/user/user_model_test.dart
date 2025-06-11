import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/user/data/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON', () {
      // Arrange
      final json = {
        'userId': 1,
        'token': 'test-token',
        'username': 'testuser',
        'email': 'test@example.com',
        'role': 'user',
        'resetCode': '123456',
        'isLoggedIn': true,
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.userId, equals(1));
      expect(user.token, equals('test-token'));
      expect(user.username, equals('testuser'));
      expect(user.email, equals('test@example.com'));
      expect(user.role, equals('user'));
      expect(user.resetCode, equals('123456'));
      expect(user.isLoggedIn, isTrue);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final user = UserModel(
        userId: 1,
        token: 'test-token',
        username: 'testuser',
        email: 'test@example.com',
        role: 'user',
        resetCode: '123456',
        isLoggedIn: true,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['userId'], equals(1));
      expect(json['token'], equals('test-token'));
      expect(json['username'], equals('testuser'));
      expect(json['email'], equals('test@example.com'));
      expect(json['role'], equals('user'));
      expect(json['resetCode'], equals('123456'));
      expect(json['isLoggedIn'], isTrue);
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'username': 'testuser',
        'email': 'test@example.com',
        'role': 'user',
        'isLoggedIn': false,
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.userId, isNull);
      expect(user.token, isNull);
      expect(user.resetCode, isNull);
      expect(user.username, equals('testuser'));
      expect(user.email, equals('test@example.com'));
      expect(user.role, equals('user'));
      expect(user.isLoggedIn, isFalse);
    });
  });
}
