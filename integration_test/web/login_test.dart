import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_reserver/main.dart' as app;
import 'package:table_reserver/pages/web/views/homepage.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'owner@mail.com';
  const password = 'password';

  testWidgets('should be able to login with existing account', (tester) async {
    setupWebIntegrationTestErrorFilters();
    final appLogo = find.byKey(const Key('appLogo'));
    final landingTitle = find.byKey(const Key('landingTitle'));
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    final logInTitle = find.byKey(const Key('logInTitle'));
    final logInEmailField = find.byKey(const Key('logInEmailField'));
    final logInPasswordField = find.byKey(const Key('logInPasswordField'));
    final logInButton = find.byKey(const Key('logInButton'));
    final signUpTab = find.byKey(const Key('signUpTab'));
    final logInTab = find.byKey(const Key('logInTab'));

    app.main();

    await tester.pumpAndSettle();

    expect(landingTitle, findsOneWidget);
    expect(appLogo, findsOneWidget);
    expect(getStartedButton, findsOneWidget);

    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    expect(signUpTab, findsOneWidget);
    expect(logInTab, findsOneWidget);

    await tester.tap(logInTab);
    await tester.pumpAndSettle();

    expect(logInTitle, findsOneWidget);
    expect(logInEmailField, findsOneWidget);
    expect(logInPasswordField, findsOneWidget);
    expect(logInButton, findsOneWidget);

    await tester.enterText(logInEmailField, email);
    await tester.enterText(logInPasswordField, password);
    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebHomepage), findsOneWidget);
  });
}
