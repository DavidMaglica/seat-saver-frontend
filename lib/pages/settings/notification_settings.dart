import 'package:diplomski/pages/settings/utils/settings_utils.dart';
import 'package:flutter/material.dart';

import '../../components/appbar.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool? isActivePushNotifications;
  bool? isActiveEmailNotifications;
  bool? isActiveLocationServices;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveChanges() => debugPrint('Save changes on Notification settings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppbar(title: 'Notification settings'),
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
                value: isActivePushNotifications ??= true,
                onChanged: (newValue) async {
                  setState(() => isActivePushNotifications = newValue);
                },
                title: Text('Push Notifications',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Receive Push notifications from our application on a semi regular basis.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.background,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              _buildDivider(),
              SwitchListTile.adaptive(
                value: isActiveEmailNotifications ??= true,
                onChanged: (newValue) async {
                  setState(() => isActiveEmailNotifications = newValue);
                },
                title: Text('Email Notifications',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Receive email notifications from our marketing team about new features.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.background,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              _buildDivider(),
              SwitchListTile.adaptive(
                value: isActiveLocationServices ??= true,
                onChanged: (newValue) async {
                  setState(() => isActiveLocationServices = newValue);
                },
                title: Text('Location Services',
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  'Allow us to track your location, this helps keep track of spending and keeps you safe.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                tileColor: Theme.of(context).colorScheme.background,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
              ),
              buildActionButton(context, 'Save Changes', _saveChanges, null),
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
