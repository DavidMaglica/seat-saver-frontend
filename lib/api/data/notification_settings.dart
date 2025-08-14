class NotificationOptions {
  bool isPushNotificationsEnabled;
  bool isEmailNotificationsEnabled;
  bool isLocationServicesEnabled;

  NotificationOptions({
    required this.isPushNotificationsEnabled,
    required this.isEmailNotificationsEnabled,
    required this.isLocationServicesEnabled,
  });

  factory NotificationOptions.fromJson(Map<String, dynamic> json) {
    return NotificationOptions(
      isPushNotificationsEnabled: json['isPushNotificationsEnabled'],
      isEmailNotificationsEnabled: json['isEmailNotificationsEnabled'],
      isLocationServicesEnabled: json['isLocationServicesEnabled'],
    );
  }
}
