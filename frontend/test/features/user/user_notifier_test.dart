import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/user/data/user_model.dart';
import 'package:frontend/features/user/domain/user_usecases/signup.dart';
import 'package:frontend/features/user/domain/user_usecases/login.dart';
import 'package:frontend/features/user/domain/user_usecases/forgot_password.dart';
import 'package:frontend/features/user/domain/user_usecases/reset_password.dart';
import 'package:frontend/features/user/domain/user_usecases/getUserById.dart';
import 'package:frontend/features/user/domain/user_usecases/update_user.dart';
import 'package:frontend/features/user/domain/user_usecases/delete_user.dart';
import 'package:frontend/features/user/domain/user_usecases/logout.dart';
import 'package:frontend/features/user/presentation/user_notifier.dart';
import 'package:frontend/features/user/presentation/user_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  SignUpUser,
  LoginUser,
  ForgotPassword,
  ResetPassword,
  GetUserById,
  UpdateUser,
  DeleteUser,
  LogoutUser,
])
import 'user_notifier_test.mocks.dart';

void main() {
  late UserNotifier notifier;
  late MockSignUpUser mockSignUpUser;
  late MockLoginUser mockLoginUser;
  late MockForgotPassword mockForgotPassword;
  late MockResetPassword mockResetPassword;
  late MockGetUserById mockGetUserById;
  late MockUpdateUser mockUpdateUser;
  late MockDeleteUser mockDeleteUser;
  late MockLogoutUser mockLogoutUser;

  setUp(() {
    mockSignUpUser = MockSignUpUser();
    mockLoginUser = MockLoginUser();
    mockForgotPassword = MockForgotPassword();
    mockResetPassword = MockResetPassword();
    mockGetUserById = MockGetUserById();
    mockUpdateUser = MockUpdateUser();
    mockDeleteUser = MockDeleteUser();
    mockLogoutUser = MockLogoutUser();

    notifier = UserNotifier(
      signUpUser: mockSignUpUser,
      loginUser: mockLoginUser,
      forgotPassword: mockForgotPassword,
      resetPassword: mockResetPassword,
      getUserById: mockGetUserById,
      updateUser: mockUpdateUser,
      deleteUser: mockDeleteUser,
      logoutUser: mockLogoutUser,
    );
  });

  group('UserNotifier', () {
    test('initial state should be empty', () {
      expect(notifier.state, equals(UserState()));
    });

    test('register should update state with user data on success', () async {
      // Arrange
      final user = UserModel(
        userId: 1,
        username: 'testuser',
        email: 'test@example.com',
        role: 'user',
        isLoggedIn: true,
      );
      when(mockSignUpUser.call(
              'testuser', 'test@example.com', 'password123', 'user'))
          .thenAnswer((_) async => user);
      when(mockGetUserById.call(1)).thenAnswer((_) async => user);

      // Act
      await notifier.register(
          'testuser', 'test@example.com', 'password123', 'user');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.user, equals(user));
      expect(notifier.state.error, isNull);
    });

    test('login should update state with user data on success', () async {
      // Arrange
      final user = UserModel(
        userId: 1,
        username: 'testuser',
        email: 'test@example.com',
        role: 'user',
        isLoggedIn: true,
      );
      when(mockLoginUser.call('test@example.com', 'password123'))
          .thenAnswer((_) async => user);
      when(mockGetUserById.call(1)).thenAnswer((_) async => user);

      // Act
      await notifier.login('test@example.com', 'password123');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.user, equals(user));
      expect(notifier.state.error, isNull);
    });

    test('should handle errors during registration', () async {
      // Arrange
      when(mockSignUpUser.call(
              'testuser', 'test@example.com', 'password123', 'user'))
          .thenThrow(Exception('Registration failed'));

      // Act
      await notifier.register(
          'testuser', 'test@example.com', 'password123', 'user');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.user, isNull);
      expect(notifier.state.error, contains('Registration failed'));
    });

    test('should handle errors during login', () async {
      // Arrange
      when(mockLoginUser.call('test@example.com', 'password123'))
          .thenThrow(Exception('Login failed'));

      // Act
      await notifier.login('test@example.com', 'password123');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.user, isNull);
      expect(notifier.state.error, contains('Login failed'));
    });

    test('should handle forgot password request', () async {
      // Arrange
      when(mockForgotPassword.call('test@example.com'))
          .thenAnswer((_) async {});

      // Act
      await notifier.sendPasswordResetCode('test@example.com');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('should handle password reset', () async {
      // Arrange
      when(mockResetPassword.call(
              'test@example.com', 'newpassword123', '123456'))
          .thenAnswer((_) async {});

      // Act
      await notifier.resetUserPassword(
          'test@example.com', '123456', 'newpassword123');

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('should handle user deletion', () async {
      // Arrange
      when(mockDeleteUser.call(1)).thenAnswer((_) async {});

      // Act
      await notifier.deleteUserAccount(1);

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.user, isNull);
    });

    test('should handle logout', () async {
      // Arrange
      when(mockLogoutUser.call(1)).thenAnswer((_) async {});

      // Act
      await notifier.logout(1);

      // Assert
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.user, isNull);
    });
  });
}
