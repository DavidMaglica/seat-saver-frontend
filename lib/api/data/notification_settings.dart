class NotificationOptions {
  bool pushNotificationsTurnedOn;
  bool emailNotificationsTurnedOn;
  bool locationServicesTurnedOn;

  NotificationOptions({
    required this.pushNotificationsTurnedOn,
    required this.emailNotificationsTurnedOn,
    required this.locationServicesTurnedOn,
  });

  factory NotificationOptions.fromMap(Map<String, dynamic> json) {
    return NotificationOptions(
      pushNotificationsTurnedOn: json['pushNotificationsTurnedOn'],
      emailNotificationsTurnedOn: json['emailNotificationsTurnedOn'],
      locationServicesTurnedOn: json['locationServicesTurnedOn'],
    );
  }
}

class NotificationSettingsResponse {
  bool success;
  String message;
  NotificationOptions? notificationSettings;

  NotificationSettingsResponse({
    required this.success,
    required this.message,
    this.notificationSettings,
  });

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsResponse(
      success: json['success'],
      message: json['message'],
      notificationSettings:
          NotificationOptions.fromMap(json['notificationSettings']),
    );
  }
}
