import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/landing.dart';

import '../../../test_utils/google_sign_in_mock.dart';
import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  setUp(() {
    setupSharedPrefsMock();
    setupGoogleSignInMock();

    googleSignIn = GoogleSignIn.instance;
  });

  testWidgets('should display widget correctly', (tester) async {
    final appLogo = find.byKey(const Key('appLogo'));
    final landingTitle = find.byKey(const Key('landingTitle'));
    final getStartedButton = find.byKey(const Key('getStartedButton'));

    await tester.pumpWidget(MaterialApp(home: WebLanding()));
    await tester.pumpAndSettle();

    expect(appLogo, findsOneWidget);
    expect(landingTitle, findsOneWidget);
    expect(getStartedButton, findsOneWidget);
  });
}
