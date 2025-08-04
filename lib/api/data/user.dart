import 'package:table_reserver/api/data/notification_settings.dart';

class User {
  final int id;
  final String username;
  final String email;
  final NotificationOptions notificationOptions;
  final double? lastKnownLatitude;
  final double? lastKnownLongitude;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.notificationOptions,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      notificationOptions:
          NotificationOptions.fromJson(json['notificationOptions']),
      lastKnownLatitude: json['lastKnownLatitude'],
      lastKnownLongitude: json['lastKnownLongitude'],
    );
  }
}

class APIUser {
  final int id;
  final String username;
  final String email;
  final String password;
  final int roleId;
  final double? lastKnownLatitude;
  final double? lastKnownLongitude;

  APIUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.roleId,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
  });

  factory APIUser.fromJson(Map<String, dynamic> json) {
    return APIUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      roleId: json['roleId'],
      lastKnownLatitude: json['lastKnownLatitude'],
      lastKnownLongitude: json['lastKnownLongitude'],
    );
  }

  User toUser() {
    return User(
      id: id,
      username: username,
      email: email,
      notificationOptions: NotificationOptions(
        pushNotificationsTurnedOn: false,
        emailNotificationsTurnedOn: false,
        locationServicesTurnedOn: false,
      ),
      lastKnownLatitude: lastKnownLatitude,
      lastKnownLongitude: lastKnownLongitude,
    );
  }
}
