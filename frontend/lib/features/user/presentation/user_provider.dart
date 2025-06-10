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

final getUserByIdProvider = Provider((ref) {
  return GetUserById(ref.watch(userRepositoryProvider));
});

// StateNotifierProvider for UserNotifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    signUpUser: ref.watch(signUpUserProvider),
    loginUser: ref.watch(loginUserProvider),
    getUserById: ref.watch(getUserByIdProvider),
  );
});
