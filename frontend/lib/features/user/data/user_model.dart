class UserModel {
  final int? userId;
  final String? token;
  final String username;
  final String email;
  final String role;
  final String? resetCode;
  final bool isLoggedIn;

  UserModel({
    this.userId,
    this.token,
    required this.username,
    required this.email,
    required this.role,
    this.resetCode,
    required this.isLoggedIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId'],
        token: json['token'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        resetCode: json['resetCode'],
        isLoggedIn: json['isLoggedIn'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'token': token,
        'username': username,
        'email': email,
        'role': role,
        'resetCode': resetCode,
        'isLoggedIn': isLoggedIn,
      };
}
