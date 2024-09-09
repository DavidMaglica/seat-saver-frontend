class NotificationSettings {
  bool pushNotificationsTurnedOn;
  bool emailNotificationsTurnedOn;
  bool locationServicesTurnedOn;

  NotificationSettings({
    required this.pushNotificationsTurnedOn,
    required this.emailNotificationsTurnedOn,
    required this.locationServicesTurnedOn,
  });

  factory NotificationSettings.fromMap(Map<String, dynamic> json) {
    return NotificationSettings(
      pushNotificationsTurnedOn: json['pushNotificationsTurnedOn'],
      emailNotificationsTurnedOn: json['emailNotificationsTurnedOn'],
      locationServicesTurnedOn: json['locationServicesTurnedOn'],
    );
  }
}

class NotificationSettingsResponse {
  bool success;
  String message;
  NotificationSettings? notificationSettings;

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
          NotificationSettings.fromMap(json['notificationSettings']),
    );
  }
}
