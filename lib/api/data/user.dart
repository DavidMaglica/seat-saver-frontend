import 'package:geolocator/geolocator.dart';

import 'notification_settings.dart';

class User {
  final String username;
  final String email;
  final String password;
  final NotificationOptions notificationOptions;
  final Position? lastKnownLocation;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.notificationOptions,
    this.lastKnownLocation,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      notificationOptions:
          NotificationOptions.fromMap(json['notificationOptions']),
      lastKnownLocation: json['lastKnownLocation'] != null
          ? Position.fromMap(json['lastKnownLocation'])
          : null,
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
