// user/presentation/user_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user_usecases/signup.dart';
import '../../domain/user_usecases/login.dart';
import '../../domain/user_usecases/getUserById.dart';
import '../../data/user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final SignUpUser signUpUser;
  final LoginUser loginUser;
  final GetUserById getUserById;

  UserNotifier({
    required this.signUpUser,
    required this.loginUser,
    required this.getUserById,
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

  Future<void> fetchUserById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await getUserById.call(id);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void logout() {
    state = UserState(); // Clear user and reset
  }
}
