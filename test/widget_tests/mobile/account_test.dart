import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/models/mobile/views/account_model.dart';
import 'package:table_reserver/pages/mobile/auth/authentication.dart';
import 'package:table_reserver/pages/mobile/settings/edit_profile.dart';
import 'package:table_reserver/pages/mobile/settings/notification_settings.dart';
import 'package:table_reserver/pages/mobile/settings/reservation_history.dart';
import 'package:table_reserver/pages/mobile/settings/support.dart';
import 'package:table_reserver/pages/mobile/settings/terms_of_service.dart';
import 'package:table_reserver/pages/mobile/views/account.dart';
import 'package:table_reserver/utils/routes.dart';

import '../../test_utils/shared_preferences_mock.dart';

void main() {
  setUp(() {
    setupSharedPrefsMock(initialValues: {});
  });

  const mockUserId = 1;
  const mockUsername = 'mockUser';
  const mockEmail = 'test@mail.com';

  final mockedUserModel = AccountModel(
    userId: mockUserId,
    accountApi: FakeAccountApi(),
  );

  final nullUserModel = AccountModel(
    userId: null,
    accountApi: FakeAccountApi(),
  );

  testWidgets('renders Account screen when logged out', (tester) async {
    final usernameText = find.byKey(Key('usernameText'));
    final emailText = find.byKey(Key('emailText'));
    final reservationHistoryTitle = find.byKey(Key('reservationHistoryTitle'));
    final reservationHistoryButton = find.byKey(
      Key('reservationHistoryButton'),
    );
    final accountSettingsTitle = find.byKey(Key('accountSettingsTitle'));
    final editProfileButton = find.byKey(Key('editProfileButton'));
    final notificationSettingsButton = find.byKey(
      Key('notificationSettingsButton'),
    );
    final applicationSettingsTitle = find.byKey(
      Key('applicationSettingsTitle'),
    );
    final supportButton = find.byKey(Key('supportButton'));
    final termsOfServiceButton = find.byKey(Key('termsOfServiceButton'));
    final logoutButton = find.byKey(Key('logoutButton'));
    final loginButton = find.byKey(Key('loginButton'));

    await tester.pumpWidget(const MaterialApp(home: Account(userId: null)));

    expect(usernameText, findsOneWidget);
    expect(emailText, findsOneWidget);
    expect(find.text(mockUsername), findsNothing);
    expect(find.text(mockEmail), findsNothing);
    expect(reservationHistoryTitle, findsOneWidget);
    expect(reservationHistoryButton, findsOneWidget);
    expect(accountSettingsTitle, findsOneWidget);
    expect(editProfileButton, findsOneWidget);
    expect(notificationSettingsButton, findsOneWidget);
    expect(applicationSettingsTitle, findsOneWidget);
    expect(supportButton, findsOneWidget);
    expect(termsOfServiceButton, findsOneWidget);
    expect(logoutButton, findsNothing);
    expect(loginButton, findsOneWidget);
  });

  testWidgets('shows user details when logged in', (tester) async {
    final logoutButton = find.byKey(const Key('logoutButton'));
    final loginButton = find.byKey(const Key('loginButton'));

    await mockedUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(mockUsername), findsOneWidget);
    expect(find.text(mockEmail), findsOneWidget);
    expect(logoutButton, findsOneWidget);
    expect(loginButton, findsNothing);
  });

  testWidgets('should open reservation history when user logged in', (
    tester,
  ) async {
    final reservationHistoryButton = find.byKey(
      const Key('reservationHistoryButton'),
    );

    await mockedUserModel.init();
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {
          Routes.reservationHistory: (context) =>
              const ReservationHistory(userId: mockUserId),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(reservationHistoryButton, findsOneWidget);

    await tester.tap(reservationHistoryButton);
    await tester.pumpAndSettle();

    expect(find.byType(ReservationHistory), findsOneWidget);
  });

  testWidgets('should not open reservation history when user not logged in', (
    tester,
  ) async {
    final reservationHistoryButton = find.byKey(
      const Key('reservationHistoryButton'),
    );

    await nullUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: Account(userId: null, modelOverride: nullUserModel)),
      ),
    );

    await tester.pumpAndSettle();

    expect(reservationHistoryButton, findsOneWidget);

    await tester.tap(reservationHistoryButton);
    await tester.pump();

    expect(
      find.text('Please log in to view your reservation history.'),
      findsOneWidget,
    );
  });

  testWidgets('should open edit profile when user logged in', (tester) async {
    final editProfileButton = find.byKey(const Key('editProfileButton'));

    await mockedUserModel.init();
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {
          Routes.editProfile: (context) =>
              const EditProfile(userId: mockUserId),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(editProfileButton, findsOneWidget);

    await tester.tap(editProfileButton);
    await tester.pump();
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(EditProfile), findsOneWidget);
  });

  testWidgets('should not open edit profile when user not logged in', (
    tester,
  ) async {
    final editProfileButton = find.byKey(const Key('editProfileButton'));

    await nullUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: Account(userId: null, modelOverride: nullUserModel)),
      ),
    );

    await tester.pumpAndSettle();

    expect(editProfileButton, findsOneWidget);

    await tester.tap(editProfileButton);
    await tester.pump();

    expect(find.text('Please log in to edit your profile.'), findsOneWidget);
  });

  testWidgets('should open notification settings when user logged in', (
    tester,
  ) async {
    final notificationSettingsButton = find.byKey(
      const Key('notificationSettingsButton'),
    );

    await mockedUserModel.init();
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {
          Routes.notificationSettings: (context) =>
              const NotificationSettings(userId: mockUserId),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(notificationSettingsButton, findsOneWidget);

    await tester.tap(notificationSettingsButton);
    await tester.pumpAndSettle();

    expect(find.byType(NotificationSettings), findsOneWidget);
  });

  testWidgets('should not open notification settings when user not logged in', (
    tester,
  ) async {
    final notificationSettingsButton = find.byKey(
      const Key('notificationSettingsButton'),
    );

    await nullUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: Account(userId: null, modelOverride: nullUserModel)),
      ),
    );

    await tester.pumpAndSettle();

    expect(notificationSettingsButton, findsOneWidget);

    await tester.tap(notificationSettingsButton);
    await tester.pump();

    expect(
      find.text('Please log in to edit notification settings.'),
      findsOneWidget,
    );
  });

  testWidgets('should open support when user logged in', (tester) async {
    final supportButton = find.byKey(const Key('supportButton'));

    await mockedUserModel.init();
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {
          Routes.support: (context) => const Support(userId: mockUserId),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(supportButton, findsOneWidget);

    await tester.tap(supportButton);
    await tester.pumpAndSettle();

    expect(find.byType(Support), findsOneWidget);
  });

  testWidgets('should not open support when user not logged in', (
    tester,
  ) async {
    final supportButton = find.byKey(const Key('supportButton'));

    await nullUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: Account(userId: null, modelOverride: nullUserModel)),
      ),
    );

    await tester.pumpAndSettle();

    expect(supportButton, findsOneWidget);

    await tester.tap(supportButton);
    await tester.pump();

    expect(find.text('Please log in to access support.'), findsOneWidget);
  });

  testWidgets('should open terms of service', (tester) async {
    final termsOfServiceButton = find.byKey(const Key('termsOfServiceButton'));

    await mockedUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {Routes.termsOfService: (context) => const TermsOfService()},
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      termsOfServiceButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );

    expect(termsOfServiceButton, findsOneWidget);

    await tester.tap(termsOfServiceButton);
    await tester.pumpAndSettle();

    expect(find.byType(TermsOfService), findsOneWidget);
  });

  testWidgets('should send to Authentication when log out clicked', (
    tester,
  ) async {
    final logoutButton = find.byKey(const Key('logoutButton'));

    await mockedUserModel.init();
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    await tester.pumpWidget(
      MaterialApp(
        home: Account(userId: mockUserId, modelOverride: mockedUserModel),
        routes: {Routes.authentication: (context) => const Authentication()},
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      logoutButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );

    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.byType(Authentication), findsOneWidget);
  });

  testWidgets('should send to Authentication when log in clicked', (
    tester,
  ) async {
    final loginButton = find.byKey(const Key('loginButton'));

    await nullUserModel.init();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: Account(userId: null, modelOverride: nullUserModel)),
        routes: {Routes.authentication: (context) => const Authentication()},
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      loginButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );

    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(Authentication), findsOneWidget);
  });
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<UserResponse?> getUser(int userId) async {
    return UserResponse(
      success: true,
      message: 'User found',
      user: User(id: userId, username: 'mockUser', email: 'test@mail.com'),
    );
  }
}
