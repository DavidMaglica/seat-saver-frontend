import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_reserver/main.dart' as app;
import 'package:table_reserver/pages/mobile/views/homepage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'user@mail.com';
  const username = 'user';
  const password = 'password';

  testWidgets('should sign up successfully', (tester) async {
    final welcomeText = find.text('Welcome to TableReserver');
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
    final createAccountText = find.byKey(const Key('createAccountText'));
    final emailSignUpField = find.byKey(const Key('emailSignUpField'));
    final usernameSignUpField = find.byKey(const Key('usernameSignUpField'));
    final passwordSignUpField = find.byKey(const Key('passwordSignUpField'));
    final retypePasswordField = find.byKey(const Key('retypePasswordField'));
    final signUpButton = find.byKey(const Key('signUpButton'));

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

    expect(createAccountText, findsOneWidget);
    expect(emailSignUpField, findsOneWidget);
    expect(usernameSignUpField, findsOneWidget);
    expect(passwordSignUpField, findsOneWidget);
    expect(retypePasswordField, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    await tester.enterText(emailSignUpField, email);
    await tester.enterText(usernameSignUpField, username);
    await tester.enterText(passwordSignUpField, password);
    await tester.enterText(retypePasswordField, password);
    await tester.pumpAndSettle();

    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.byType(Homepage), findsOneWidget);
  });
}
