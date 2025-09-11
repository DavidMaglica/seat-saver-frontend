import 'package:seat_saver/api/data/notification_settings.dart';

class User {
  final int id;
  final String username;
  final String email;
  final NotificationOptions? notificationOptions;
  final double? lastKnownLatitude;
  final double? lastKnownLongitude;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.notificationOptions,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      notificationOptions: json['notificationOptions'] != null
          ? NotificationOptions.fromJson(json['notificationOptions'])
          : null,
      lastKnownLatitude: json['lastKnownLatitude'],
      lastKnownLongitude: json['lastKnownLongitude'],
    );
  }
}
