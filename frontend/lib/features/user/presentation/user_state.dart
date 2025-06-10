import '../../data/user_model.dart';

class UserState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  UserState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  UserState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
