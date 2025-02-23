import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/account_api.dart';
import '../../api/data/basic_response.dart';
import '../../api/data/notification_settings.dart';
import '../../api/data/user.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import 'utils/settings_utils.dart';

class NotificationSettings extends StatefulWidget {
  final User user;
  final Position? userLocation;

  const NotificationSettings({
    Key? key,
    required this.user,
    this.userLocation,
  }) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _isActivePushNotifications = false;
  bool _isActiveEmailNotifications = false;
  bool _isActiveLocationServices = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _getNotificationSettingsByEmail();
  }

  @override
  void dispose() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    super.dispose();
  }

  Future<void> _getNotificationSettingsByEmail() async {
    NotificationOptions response =
        await getNotificationOptions(widget.user.email);

    setState(() {
      _isActivePushNotifications = response.pushNotificationsTurnedOn;
      _isActiveEmailNotifications = response.emailNotificationsTurnedOn;
      _isActiveLocationServices = response.locationServicesTurnedOn;
    });
  }

  Future<void> _saveChanges() async {
    BasicResponse response = await updateUserNotificationOptions(
      widget.user.email,
      _isActivePushNotifications,
      _isActiveEmailNotifications,
      _isActiveLocationServices,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      backgroundColor:
          response.success ? AppThemes.successColor : AppThemes.errorColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppbar(
        title: 'Notification settings',
        routeToPush: Routes.ACCOUNT,
        args: {
          'userEmail': widget.user.email,
          'userLocation': widget.userLocation
        },
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildDescriptionText(),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              ),
              SwitchListTile.adaptive(
                value: _isActivePushNotifications,
                onChanged: (newValue) async {
                  setState(() => _isActivePushNotifications = newValue);
                },
                title: Text('Push Notifications',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Receive Push notifications from our application on a semi regular basis.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.surface,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              _buildDivider(),
              SwitchListTile.adaptive(
                value: _isActiveEmailNotifications,
                onChanged: (newValue) async {
                  setState(() => _isActiveEmailNotifications = newValue);
                },
                title: Text('Email Notifications',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Receive email notifications from our marketing team about new features.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.surface,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              _buildDivider(),
              SwitchListTile.adaptive(
                value: _isActiveLocationServices,
                onChanged: (newValue) async {
                  setState(() => _isActiveLocationServices = newValue);
                },
                title: Text('Location Services',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Allow us to track your location, this helps keep track of spending and keeps you safe.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.surface,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              ActionButton(title: 'Save Changes', onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildDescriptionText() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 12, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'Choose what notifications you want to receive below and we will update the settings.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );

  Divider _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        color: Theme.of(context).colorScheme.onPrimary,
        indent: 12,
        endIndent: 12,
      );
}
