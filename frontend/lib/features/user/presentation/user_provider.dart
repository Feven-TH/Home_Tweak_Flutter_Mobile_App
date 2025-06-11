import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/user_repository.dart';
import '../../data/user_data.dart';
import '../../domain/user_usecases/signup.dart';
import '../../domain/user_usecases/login.dart';
import '../../domain/user_usecases/getUserById.dart';
import '../presentation/user_notifier.dart';
import '../presentation/user_state.dart';

// Repository provider
final userRepositoryProvider = Provider((ref) {
  return UserRepository(DioClient());
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
    deleteUser: ref.watch(deleteUserProvider),
    logoutUser: ref.watch(logoutUserProvider),
  );
});
