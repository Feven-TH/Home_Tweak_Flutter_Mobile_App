import '../data/user_model.dart';

class UserState {
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final String? successMessage;

  UserState({
    this.isLoading = false,
    this.user,
    this.error,
    this.successMessage
  });

  UserState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
    String? successMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
