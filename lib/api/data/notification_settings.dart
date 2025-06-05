class NotificationOptions {
  bool pushNotificationsTurnedOn;
  bool emailNotificationsTurnedOn;
  bool locationServicesTurnedOn;

  NotificationOptions({
    required this.pushNotificationsTurnedOn,
    required this.emailNotificationsTurnedOn,
    required this.locationServicesTurnedOn,
  });

  factory NotificationOptions.fromJson(Map<String, dynamic> json) {
    return NotificationOptions(
      pushNotificationsTurnedOn: json['pushNotificationsTurnedOn'],
      emailNotificationsTurnedOn: json['emailNotificationsTurnedOn'],
      locationServicesTurnedOn: json['locationServicesTurnedOn'],
    );
  }
}
