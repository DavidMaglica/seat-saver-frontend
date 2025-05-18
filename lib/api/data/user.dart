import 'package:geolocator/geolocator.dart';

import 'notification_settings.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final NotificationOptions notificationOptions;
  final Position? lastKnownLocation;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.notificationOptions,
    this.lastKnownLocation,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
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
