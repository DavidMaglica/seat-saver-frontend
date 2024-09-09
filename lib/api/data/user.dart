import 'notification_settings.dart';

class User {
  final String nameAndSurname;
  final String email;
  final String password;
  final NotificationSettings notificationOptions;

  User({
    required this.nameAndSurname,
    required this.email,
    required this.password,
    required this.notificationOptions,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      nameAndSurname: json['nameAndSurname'],
      email: json['email'],
      password: json['password'],
      notificationOptions:
          NotificationSettings.fromMap(json['notificationOptions']),
    );
  }
}

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
      user: User.fromMap(json['user']),
    );
  }
}
