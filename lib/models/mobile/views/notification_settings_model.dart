import 'package:flutter/material.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/notification_settings.dart';
import 'package:seat_saver/themes/mobile_theme.dart';

class NotificationSettingsModel extends ChangeNotifier {
  final int userId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final AccountApi accountApi;

  bool isActivePushNotifications = false;
  bool isActiveEmailNotifications = false;
  bool isActiveLocationServices = false;

  NotificationSettingsModel({required this.userId, AccountApi? accountApi})
    : accountApi = accountApi ?? AccountApi();

  Future<void> loadNotificationSettings() async {
    NotificationOptions? response = await accountApi.getNotificationOptions(
      userId,
    );

    if (response != null) {
      isActivePushNotifications = response.isPushNotificationsEnabled;
      isActiveEmailNotifications = response.isEmailNotificationsEnabled;
      isActiveLocationServices = response.isLocationServicesEnabled;
    }
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    isActivePushNotifications = value;
    notifyListeners();
  }

  void toggleEmailNotifications(bool value) {
    isActiveEmailNotifications = value;
    notifyListeners();
  }

  void toggleLocationServices(bool value) {
    isActiveLocationServices = value;
    notifyListeners();
  }

  Future<void> saveChanges(BuildContext context) async {
    BasicResponse response = await accountApi.updateUserNotificationOptions(
      userId,
      isActivePushNotifications,
      isActiveEmailNotifications,
      isActiveLocationServices,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.success
            ? MobileTheme.successColor
            : MobileTheme.errorColor,
      ),
    );
  }
}
