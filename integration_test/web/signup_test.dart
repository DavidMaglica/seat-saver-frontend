import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seat_saver/main.dart' as app;
import 'package:seat_saver/pages/web/views/homepage.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'owner@mail.com';
  const username = 'owner';
  const password = 'password';

  testWidgets('should sign up successfully', (tester) async {
    setupWebIntegrationTestErrorFilters();
    final appLogo = find.byKey(const Key('appLogo'));
    final landingTitle = find.byKey(const Key('landingTitle'));
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    final createAccountText = find.text('Create Account');
    final signUpEmailField = find.byKey(const Key('signUpEmailField'));
    final signUpUsernameField = find.byKey(const Key('signUpUsernameField'));
    final signUpPasswordField = find.byKey(const Key('signUpPasswordField'));
    final signUpConfirmPasswordField = find.byKey(
      const Key('signUpConfirmPasswordField'),
    );
    final signUpButton = find.byKey(const Key('signUpButton'));
    final signUpTab = find.byKey(const Key('signUpTab'));
    final logInTab = find.byKey(const Key('logInTab'));

    app.main();

    await tester.pumpAndSettle();

    expect(landingTitle, findsOneWidget);
    expect(appLogo, findsOneWidget);
    expect(getStartedButton, findsOneWidget);

    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    expect(createAccountText, findsOneWidget);
    expect(signUpEmailField, findsOneWidget);
    expect(signUpUsernameField, findsOneWidget);
    expect(signUpPasswordField, findsOneWidget);
    expect(signUpConfirmPasswordField, findsOneWidget);
    expect(signUpButton, findsOneWidget);
    expect(signUpTab, findsOneWidget);
    expect(logInTab, findsOneWidget);

    await tester.enterText(signUpEmailField, email);
    await tester.enterText(signUpUsernameField, username);
    await tester.enterText(signUpPasswordField, password);
    await tester.enterText(signUpConfirmPasswordField, password);
    await tester.pumpAndSettle();
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebHomepage), findsOneWidget);
  });
}
