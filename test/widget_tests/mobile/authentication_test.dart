import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/pages/mobile/auth/authentication.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/utils/routes.dart';

import '../../test_utils/shared_preferences_mock.dart';

void main() {
  setUp(() {
    setupSharedPrefsMock(initialValues: {});
  });

  final mockUserEmail = 'test@email.com';
  final mockUserPassword = 'password';
  final mockUserUsername = 'username';

  testWidgets(
    'should render Authentication with both tabs and switch correctly',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: Authentication()));

      final signUpTab = find.byKey(const Key('signUpTab'));
      final logInTab = find.byKey(const Key('logInTab'));
      final continueWithoutAccountButton = find.byKey(
        const Key('continueWithoutAccount'),
      );

      final signUpTabText = find.byKey(const Key('createAccountText'));
      final signUpEmailField = find.byKey(const Key('emailSignUpField'));
      final signUpUsernameField = find.byKey(const Key('usernameSignUpField'));
      final signUpPasswordField = find.byKey(const Key('passwordSignUpField'));
      final signUpRetypePasswordField = find.byKey(
        const Key('retypePasswordField'),
      );
      final signUpButton = find.byKey(const Key('signUpButton'));
      final signUpWithGoogleButton = find.byKey(
        const Key('googleSignUpButton'),
      );

      final logInTabText = find.byKey(const Key('welcomeBackText'));
      final logInTabSubtitleText = find.byKey(const Key('logInSubtitleText'));
      final logInEmailField = find.byKey(const Key('emailLogInField'));
      final logInPasswordField = find.byKey(const Key('passwordLogInField'));
      final logInButton = find.byKey(const Key('logInButton'));
      final logInWithGoogleButton = find.byKey(const Key('googleLogInButton'));

      expect(signUpTab, findsOneWidget);
      expect(logInTab, findsOneWidget);
      expect(continueWithoutAccountButton, findsOneWidget);

      expect(signUpTabText, findsOneWidget);
      expect(signUpEmailField, findsOneWidget);
      expect(signUpUsernameField, findsOneWidget);
      expect(signUpPasswordField, findsOneWidget);
      expect(signUpRetypePasswordField, findsOneWidget);
      expect(signUpButton, findsOneWidget);
      expect(signUpWithGoogleButton, findsOneWidget);

      await tester.tap(logInTab);
      await tester.pumpAndSettle();

      expect(logInTabText, findsOneWidget);
      expect(logInTabSubtitleText, findsOneWidget);
      expect(logInEmailField, findsOneWidget);
      expect(logInPasswordField, findsOneWidget);
      expect(logInButton, findsOneWidget);
      expect(logInWithGoogleButton, findsOneWidget);
    },
  );

  testWidgets('should navigate to Homepage when continuing without account', (
    tester,
  ) async {
    final button = find.byKey(const Key('continueWithoutAccount'));

    await tester.pumpWidget(
      MaterialApp(
        home: Authentication(),
        routes: {Routes.homepage: (context) => const Homepage()},
      ),
    );

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byType(Homepage), findsOneWidget);
  });

  testWidgets(
    'should not display input field error text when sign up validation succeeds',
    (tester) async {
      final signUpEmailField = find.byKey(const Key('emailSignUpField'));
      final signUpUsernameField = find.byKey(const Key('usernameSignUpField'));
      final signUpPasswordField = find.byKey(const Key('passwordSignUpField'));
      final signUpRetypePasswordField = find.byKey(
        const Key('retypePasswordField'),
      );
      final signUpButton = find.byKey(const Key('signUpButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Authentication(),
          routes: {Routes.homepage: (context) => const Homepage()},
        ),
      );

      await tester.enterText(signUpEmailField, mockUserEmail);
      await tester.enterText(signUpUsernameField, mockUserUsername);
      await tester.enterText(signUpPasswordField, mockUserPassword);
      await tester.enterText(signUpRetypePasswordField, mockUserPassword);

      await tester.scrollUntilVisible(
        signUpButton,
        100.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Email cannot be empty'), findsNothing);
      expect(find.text('Username cannot be empty'), findsNothing);
      expect(find.text('Password cannot be empty'), findsNothing);
      expect(find.text('Please confirm your password'), findsNothing);
    },
  );

  testWidgets(
    'should display input field error text when sign up validation fails',
    (tester) async {
      final signUpEmailField = find.byKey(const Key('emailSignUpField'));
      final signUpUsernameField = find.byKey(const Key('usernameSignUpField'));
      final signUpPasswordField = find.byKey(const Key('passwordSignUpField'));
      final signUpRetypePasswordField = find.byKey(
        const Key('retypePasswordField'),
      );
      final signUpButton = find.byKey(const Key('signUpButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Authentication(),
          routes: {Routes.homepage: (context) => const Homepage()},
        ),
      );

      await tester.enterText(signUpEmailField, '');
      await tester.enterText(signUpUsernameField, '');
      await tester.enterText(signUpPasswordField, '');
      await tester.enterText(signUpRetypePasswordField, '');

      await tester.scrollUntilVisible(
        signUpButton,
        100.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Email cannot be empty'), findsOneWidget);
      expect(find.text('Username cannot be empty'), findsOneWidget);
      expect(find.text('Password cannot be empty'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    },
  );

  testWidgets(
    'should not display input field error text when log in validation succeeds',
    (tester) async {
      final logInTab = find.byKey(const Key('logInTab'));
      final logInEmailField = find.byKey(const Key('emailLogInField'));
      final logInPasswordField = find.byKey(const Key('passwordLogInField'));
      final logInButton = find.byKey(const Key('logInButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Authentication(),
          routes: {Routes.homepage: (context) => const Homepage()},
        ),
      );
      await tester.tap(logInTab);
      await tester.pumpAndSettle();

      await tester.enterText(logInEmailField, mockUserEmail);
      await tester.enterText(logInPasswordField, mockUserPassword);
      await tester.pumpAndSettle();
      await tester.tap(logInButton);
      await tester.pumpAndSettle();

      expect(find.text('Email cannot be empty'), findsNothing);
      expect(find.text('Password cannot be empty'), findsNothing);
    },
  );

  testWidgets(
    'should display input field error text when log in validation fails',
    (tester) async {
      final logInTab = find.byKey(const Key('logInTab'));
      final logInEmailField = find.byKey(const Key('emailLogInField'));
      final logInPasswordField = find.byKey(const Key('passwordLogInField'));
      final logInButton = find.byKey(const Key('logInButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Authentication(),
          routes: {Routes.homepage: (context) => const Homepage()},
        ),
      );
      await tester.tap(logInTab);
      await tester.pumpAndSettle();

      await tester.enterText(logInEmailField, '');
      await tester.enterText(logInPasswordField, '');
      await tester.pumpAndSettle();
      await tester.tap(logInButton);
      await tester.pumpAndSettle();

      expect(find.text('Email cannot be empty'), findsOneWidget);
      expect(find.text('Password cannot be empty'), findsOneWidget);
    },
  );
}
