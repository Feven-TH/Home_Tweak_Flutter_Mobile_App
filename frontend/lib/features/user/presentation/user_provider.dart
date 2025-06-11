import 'package:dio/src/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/dio_client.dart';
import '../data/user_repository.dart';
import '../domain/user_usecases/delete_user.dart';
import '../domain/user_usecases/forgot_password.dart';
import '../domain/user_usecases/getUserById.dart';
import '../domain/user_usecases/login.dart';
import '../domain/user_usecases/logout.dart';
import '../domain/user_usecases/reset_password.dart';
import '../domain/user_usecases/signup.dart';
import '../domain/user_usecases/update_user.dart';
import '../presentation/user_notifier.dart';
import '../presentation/user_state.dart';

// Repository provider
final userRepositoryProvider = Provider((ref) {
  return UserRepository(DioClient() as Dio);
});

// UseCases providers
final signUpUserProvider = Provider((ref) {
  return SignUpUser(ref.watch(userRepositoryProvider));
});

final loginUserProvider = Provider((ref) {
  return LoginUser(ref.watch(userRepositoryProvider));
});

final forgotPasswordProvider = Provider((ref) {
  return ForgotPassword(ref.watch(userRepositoryProvider));
});

final resetPasswordProvider = Provider((ref) {
  return ResetPassword(ref.watch(userRepositoryProvider));
});

final getUserByIdProvider = Provider((ref) {
  return GetUserById(ref.watch(userRepositoryProvider));
});

final updateUserProvider = Provider((ref) {
  return UpdateUser(ref.watch(userRepositoryProvider));
});

final deleteUserProvider = Provider((ref) {
  return DeleteUser(ref.watch(userRepositoryProvider));
});

final logoutUserProvider = Provider((ref) {
  return LogoutUser(ref.watch(userRepositoryProvider));
});

// StateNotifierProvider for UserNotifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    signUpUser: ref.watch(signUpUserProvider),
    loginUser: ref.watch(loginUserProvider),
    forgotPassword: ref.watch(forgotPasswordProvider),
    resetPassword: ref.watch(resetPasswordProvider),
    getUserById: ref.watch(getUserByIdProvider),
    updateUser: ref.watch(updateUserProvider),
    deleteUser: ref.watch(deleteUserProvider),
    logoutUser: ref.watch(logoutUserProvider),
  );
});
