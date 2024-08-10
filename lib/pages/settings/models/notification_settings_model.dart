import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../notification_settings.dart';

class NotificationSettingsModel extends FlutterFlowModel<NotificationSettings> {

  bool? isActivePushNotifications;

  bool? isActiveEmailNotifications;

  bool? isActiveLocationServices;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
