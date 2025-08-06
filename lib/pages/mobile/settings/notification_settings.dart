import 'package:table_reserver/components/mobile/action_button.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/models/mobile/notification_settings_model.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class NotificationSettings extends StatelessWidget {
  final int userId;
  final Position? userLocation;

  const NotificationSettings({
    Key? key,
    required this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationSettingsModel>(
      create: (_) => NotificationSettingsModel(
        context: context,
        userId: userId,
        userLocation: userLocation,
      )..loadNotificationSettings(),
      builder: (context, _) {
        final model = context.watch<NotificationSettingsModel>();

        return Scaffold(
          key: model.scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppbar(
            title: 'Notification Settings',
            onBack: () => Navigator.of(context).pushNamed(
              Routes.account,
              arguments: {
                'userId': userId,
                'userLocation': userLocation,
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildDescriptionText(context),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    context: context,
                    title: 'Push Notifications',
                    subtitle: 'Receive app updates via push notifications.',
                    value: model.isActivePushNotifications,
                    onChanged: model.togglePushNotifications,
                  ),
                  _buildDivider(context),
                  _buildSwitchTile(
                    context: context,
                    title: 'Email Notifications',
                    subtitle: 'Get email updates from our marketing team.',
                    value: model.isActiveEmailNotifications,
                    onChanged: model.toggleEmailNotifications,
                  ),
                  _buildDivider(context),
                  _buildSwitchTile(
                    context: context,
                    title: 'Location Services',
                    subtitle:
                        'Allow us to track your location for better services.',
                    value: model.isActiveLocationServices,
                    onChanged: model.toggleLocationServices,
                  ),
                  ActionButton(
                    title: 'Save Changes',
                    onPressed: model.saveChanges,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionText(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Choose what notifications you want to receive below and we will update the settings.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(ctx).colorScheme.onPrimary,
      indent: 12,
      endIndent: 12,
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      tileColor: Theme.of(context).colorScheme.surface,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
      dense: false,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
}
