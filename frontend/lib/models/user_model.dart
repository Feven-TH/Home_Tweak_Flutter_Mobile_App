class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? resetCode;
  final bool isLoggedIn;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.resetCode,
    required this.isLoggedIn,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        resetCode: json['resetCode'],
        isLoggedIn: json['isLoggedIn'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'role': role,
        'resetCode': resetCode,
        'isLoggedIn': isLoggedIn,
      };
}
