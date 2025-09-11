import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seat_saver/main.dart' as app;
import 'package:seat_saver/pages/mobile/views/homepage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'user@mail.com';
  const password = 'password';

  testWidgets('should be able to login with existing account', (tester) async {
    final welcomeText = find.text('Welcome to SeatSaver');
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    final navInfo = find.byKey(const Key('navInfo'));
    final reservationHistoryTitle = find.byKey(
      const Key('reservationHistoryTitle'),
    );
    final accountSettingsTitle = find.byKey(const Key('accountSettingsTitle'));
    final applicationSettingsTitle = find.byKey(
      const Key('applicationSettingsTitle'),
    );
    final loginButton = find.byKey(const Key('loginButton'));
    final logoutButton = find.byKey(const Key('logoutButton'));
    final logInTab = find.byKey(const Key('logInTab'));
    final welcomeBackText = find.byKey(const Key('welcomeBackText'));
    final emailLogInField = find.byKey(const Key('emailLogInField'));
    final passwordLogInField = find.byKey(const Key('passwordLogInField'));
    final logInButton = find.byKey(const Key('logInButton'));

    app.main();

    await tester.pumpAndSettle();

    expect(welcomeText, findsOneWidget);

    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    await tester.tap(navInfo);
    await tester.pumpAndSettle();

    expect(reservationHistoryTitle, findsOneWidget);
    expect(accountSettingsTitle, findsOneWidget);
    expect(applicationSettingsTitle, findsOneWidget);
    expect(logoutButton, findsNothing);
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    await tester.tap(logInTab);
    await tester.pumpAndSettle();

    expect(welcomeBackText, findsOneWidget);
    expect(emailLogInField, findsOneWidget);
    expect(passwordLogInField, findsOneWidget);
    expect(logInButton, findsOneWidget);
    await tester.enterText(emailLogInField, email);
    await tester.enterText(passwordLogInField, password);
    await tester.pumpAndSettle();

    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(find.byType(Homepage), findsOneWidget);
  });
}
