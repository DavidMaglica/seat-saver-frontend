import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/models/mobile/views/notification_settings_model.dart';
import 'package:table_reserver/pages/mobile/settings/notification_settings.dart';

import '../../test_utils/shared_preferences_mock.dart';

void main() {
  const mockUserId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});
  });

  final model = NotificationSettingsModel(
    userId: mockUserId,
    accountApi: FakeAccountApi(),
  );

  testWidgets('should render Notification Settings correctly', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final descriptionText = find.byKey(const Key('descriptionText'));
    final pushNotificationText = find.text('Push Notifications');
    final pushNotificationSwitch = find.byKey(
      const Key('pushNotificationsSwitch'),
    );
    final emailNotificationText = find.text('Email Notifications');
    final emailNotificationSwitch = find.byKey(
      const Key('emailNotificationsSwitch'),
    );
    final locationServicesText = find.text('Location Services');
    final locationServicesSwitch = find.byKey(
      const Key('locationServicesSwitch'),
    );
    final saveChangesButton = find.byKey(const Key('saveChangesButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: NotificationSettings(userId: mockUserId, modelOverride: model),
      ),
    );

    expect(customAppBar, findsOneWidget);
    expect(descriptionText, findsOneWidget);
    expect(pushNotificationText, findsOneWidget);
    expect(pushNotificationSwitch, findsOneWidget);
    expect(emailNotificationText, findsOneWidget);
    expect(emailNotificationSwitch, findsOneWidget);
    expect(locationServicesText, findsOneWidget);
    expect(locationServicesSwitch, findsOneWidget);
    expect(saveChangesButton, findsOneWidget);
  });

  testWidgets('should update notification settings', (tester) async {
    final pushNotificationSwitch = find.byKey(
      const Key('pushNotificationsSwitch'),
    );
    final emailNotificationSwitch = find.byKey(
      const Key('emailNotificationsSwitch'),
    );
    final locationServicesSwitch = find.byKey(
      const Key('locationServicesSwitch'),
    );
    final saveChangesButton = find.byKey(const Key('saveChangesButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: NotificationSettings(userId: mockUserId, modelOverride: model),
      ),
    );

    await tester.tap(pushNotificationSwitch);
    await tester.pumpAndSettle();
    await tester.tap(emailNotificationSwitch);
    await tester.pumpAndSettle();
    await tester.tap(locationServicesSwitch);
    await tester.pumpAndSettle();
    await tester.tap(saveChangesButton);
    await tester.pumpAndSettle();

    expect(model.isActivePushNotifications, true);
    expect(model.isActiveEmailNotifications, true);
    expect(model.isActiveLocationServices, false);
  });
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<NotificationOptions?> getNotificationOptions(int userId) async {
    return NotificationOptions(
      isPushNotificationsEnabled: false,
      isEmailNotificationsEnabled: false,
      isLocationServicesEnabled: true,
    );
  }

  @override
  Future<BasicResponse> updateUserNotificationOptions(
    int userId,
    bool isPushNotificationsEnabled,
    bool isEmailNotificationsEnabled,
    bool isLocationServicesEnabled,
  ) async {
    return BasicResponse(success: true, message: 'Settings updated');
  }
}
