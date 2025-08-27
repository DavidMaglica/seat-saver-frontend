import 'package:flutter/material.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/themes/mobile_theme.dart';

class NotificationSettingsModel extends ChangeNotifier {
  final BuildContext context;
  final int userId;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final AccountApi accountApi = AccountApi();

  bool isActivePushNotifications = false;
  bool isActiveEmailNotifications = false;
  bool isActiveLocationServices = false;

  NotificationSettingsModel({required this.context, required this.userId});

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

  Future<void> saveChanges() async {
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
