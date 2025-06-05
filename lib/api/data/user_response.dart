import 'package:TableReserver/api/data/user.dart';

class UserResponse {
  bool success;
  String message;
  User? user;

  UserResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }
}
