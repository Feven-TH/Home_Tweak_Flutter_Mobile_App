// user/presentation/user_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user_usecases/signup.dart';
import '../../domain/user_usecases/login.dart';
import '../../domain/user_usecases/forgot_password.dart';
import '../../domain/user_usecases/reset_password.dart';
import '../../domain/user_usecases/getUserById.dart';
import '../../domain/user_usecases/logout.dart';
import '../../domain/user_usecases/delete_user.dart';
import '../../data/user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final SignUpUser signUpUser;
  final LoginUser loginUser;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;
  final GetUserById getUserById;
  final DeleteUser deleteUser;
  final LogoutUser logoutUser;

  UserNotifier({
    required this.signUpUser,
    required this.loginUser,
    required this.forgotPasword,
    required this.resetPassword,
    required this.getUserById,
    required this.logoutUser,
    required this.deleteUser,
  }) : super(UserState());

  Future<void> register(String username, String email, String password, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await signUpUser.call(username, email, password, role);
      final userId = result['userId'];
      final user = await getUserById.call(userId);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await loginUser.call(email, password);
      final userId = result['userId'];
      final user = await getUserById.call(userId);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await forgotPassword.call(email);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset code sent to your email',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> resetUserPassword(String email, String resetCode, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await resetPassword.call(email, resetCode, newPassword);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset successfully',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchUserById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await getUserById.call(id);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteUserAccount(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteUser.call(userId);
      state = UserState().copyWith(
        isLoading: false,
        successMessage: 'Account deleted successfully',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logoutUser(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await logoutUser.call(userId);
      state = UserState().copyWith(
        isLoading: false,
        successMessage: 'Logged out successfully',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void logout() {
    state = UserState(); // Clear user and reset
  }
}
