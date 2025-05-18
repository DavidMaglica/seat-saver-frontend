import 'notification_settings.dart';

class APIUser {
  final int id;
  final String username;
  final String email;
  final String password;
  final NotificationOptions notificationOptions;
  final double? lastKnownLatitude;
  final double? lastKnownLongitude;

  APIUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.notificationOptions,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
  });

  factory APIUser.fromMap(Map<String, dynamic> json) {
    return APIUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      notificationOptions:
          NotificationOptions.fromMap(json['notificationOptions']),
      lastKnownLatitude: json['lastKnownLatitude'],
      lastKnownLongitude: json['lastKnownLongitude'],
    );
  }
}
