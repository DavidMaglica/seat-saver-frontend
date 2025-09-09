import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/web/modals/change_email_modal.dart';
import 'package:table_reserver/components/web/modals/change_password_modal.dart';
import 'package:table_reserver/components/web/modals/change_username_modal.dart';
import 'package:table_reserver/components/web/modals/support_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/components/side_nav_model.dart';
import 'package:table_reserver/models/web/views/account_model.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late AccountModel model;

  setUp(() {
    setupSharedPrefsMock(
      initialValues: {
        'ownerId': 1,
        'ownerName': 'owner',
        'ownerEmail': 'owner@mail.com',
      },
    );

    model = AccountModel(
      reservationsApi: FakeReservationsApi(),
      venuesApi: FakeVenuesApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    ignoreOverflowErrors();
    final userDetails = find.byKey(const Key('userDetails'));
    final reservationsIcon = find.byKey(const Key('reservationsIcon'));
    final reservationsCount = find.text('10');
    final reservationsText = find.text('Reservations received');
    final venuesIcon = find.byKey(const Key('venuesIcon'));
    final venuesCount = find.text('2');
    final venuesText = find.text('Venues owned');
    final accountTitle = find.text('My Account Information');
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));
    final changePasswordButton = find.byKey(const Key('changePasswordButton'));
    final supportTitle = find.text('Support');
    final submitBugButton = find.byKey(const Key('submitBugButton'));
    final requestFeatureButton = find.byKey(const Key('requestFeatureButton'));
    final logOutButton = find.byKey(const Key('logOutButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(home: WebAccount(modelOverride: model)),
      ),
    );
    await tester.pumpAndSettle();

    expect(userDetails, findsOneWidget);
    expect(reservationsIcon, findsOneWidget);
    expect(reservationsCount, findsOneWidget);
    expect(reservationsText, findsOneWidget);
    expect(venuesIcon, findsOneWidget);
    expect(venuesCount, findsOneWidget);
    expect(venuesText, findsOneWidget);
    expect(accountTitle, findsOneWidget);
    expect(changeEmailButton, findsOneWidget);
    expect(changeUsernameButton, findsOneWidget);
    expect(changePasswordButton, findsOneWidget);
    expect(supportTitle, findsOneWidget);
    expect(submitBugButton, findsOneWidget);
    expect(requestFeatureButton, findsOneWidget);
    expect(logOutButton, findsOneWidget);
  });

  testWidgets('should open change email modal', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final changeEmailButton = find.byKey(const Key('changeEmailButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(changeEmailButton, findsOneWidget);
    await tester.tap(changeEmailButton);
    await tester.pumpAndSettle();

    expect(find.byType(ChangeEmailModal), findsOneWidget);
  });

  testWidgets('should open change username modal', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final changeUsernameButton = find.byKey(const Key('changeUsernameButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(changeUsernameButton, findsOneWidget);
    await tester.tap(changeUsernameButton);
    await tester.pumpAndSettle();

    expect(find.byType(ChangeUsernameModal), findsOneWidget);
  });

  testWidgets('should open change password modal', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final changePasswordButton = find.byKey(const Key('changePasswordButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(changePasswordButton, findsOneWidget);
    await tester.tap(changePasswordButton);
    await tester.pumpAndSettle();

    expect(find.byType(ChangePasswordModal), findsOneWidget);
  });

  testWidgets('should open submit a bug modal', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final submitBugButton = find.byKey(const Key('submitBugButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(submitBugButton, findsOneWidget);
    await tester.tap(submitBugButton);
    await tester.pumpAndSettle();

    expect(find.byType(SupportModal), findsOneWidget);
  });

  testWidgets('should open request a feature modal', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final requestFeatureButton = find.byKey(const Key('requestFeatureButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(requestFeatureButton, findsOneWidget);
    await tester.tap(requestFeatureButton);
    await tester.pumpAndSettle();

    expect(find.byType(SupportModal), findsOneWidget);
  });

  testWidgets('should navigate to landing when log out', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    currentAuthMethod = AuthenticationMethod.custom;
    final logOutButton = find.byKey(const Key('logOutButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebAccount(modelOverride: model)),
          routes: {Routes.webLanding: (context) => const WebLanding()},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(logOutButton, findsOneWidget);
    await tester.tap(logOutButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebLanding), findsOneWidget);
  });
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<int> getReservationCount(
    int ownerId, {
    int? venueId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return 10;
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<int> getVenueCountByOwner(int ownerId) async {
    return 2;
  }
}
