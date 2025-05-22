import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../api/data/basic_response.dart';
import '../api/data/notification_settings.dart';
import '../api/data/user.dart';
import '../themes/theme.dart';

class NotificationSettingsModel extends ChangeNotifier {
  final BuildContext context;
  final User user;
  final Position? userLocation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final AccountApi accountApi = AccountApi();

  bool isActivePushNotifications = false;
  bool isActiveEmailNotifications = false;
  bool isActiveLocationServices = false;

  NotificationSettingsModel({
    required this.context,
    required this.user,
    this.userLocation,
  });

  @override
  void dispose() {
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> loadNotificationSettings() async {
    NotificationOptions? response =
        await accountApi.getNotificationOptions(user.email);

    if (response != null) {
      isActivePushNotifications = response.pushNotificationsTurnedOn;
      isActiveEmailNotifications = response.emailNotificationsTurnedOn;
      isActiveLocationServices = response.locationServicesTurnedOn;
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
      user.email,
      isActivePushNotifications,
      isActiveEmailNotifications,
      isActiveLocationServices,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor:
            response.success ? AppThemes.successColor : AppThemes.errorColor,
      ),
    );
  }
}
