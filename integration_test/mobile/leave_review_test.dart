import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seat_saver/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'user@mail.com';
  const username = 'user';
  const password = 'password';

  testWidgets('should be able to leave review when logged in', (tester) async {
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
    final welcomeBackHomepageText = find.text('Welcome back, $username!');
    final venueCard = find.byKey(const Key('venueCard'));
    final headerImage = find.byKey(const Key('headerImage'));
    final viewRatingsButton = find.byKey(const Key('viewRatingsButton'));
    final ratingSummary = find.byKey(const Key('ratingSummary'));
    final ratingEntryContainer = find.byKey(const Key('ratingEntryContainer'));
    final leaveReviewButton = find.byKey(const Key('leaveReviewButton'));
    final ratingModal = find.byKey(const Key('ratingModal'));
    final ratingStar = find.byKey(const Key('ratingStar_4'));
    final commentField = find.byKey(const Key('commentField'));
    final rateModalButton = find.byKey(const Key('rateModalButton'));

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

    expect(welcomeBackHomepageText, findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(venueCard.first);
    await tester.pumpAndSettle();

    expect(headerImage, findsOneWidget);
    expect(viewRatingsButton, findsOneWidget);

    await tester.tap(viewRatingsButton);
    await tester.pumpAndSettle();

    expect(ratingSummary, findsOneWidget);
    expect(ratingEntryContainer, findsNWidgets(5));
    expect(leaveReviewButton, findsOneWidget);

    await tester.tap(leaveReviewButton);
    await tester.pumpAndSettle();

    expect(ratingModal, findsOneWidget);
    await tester.tap(ratingStar);
    await tester.pumpAndSettle();
    await tester.enterText(commentField, 'Great place!');
    await tester.pumpAndSettle();
    await tester.tap(rateModalButton);
    await tester.pumpAndSettle();

    expect(ratingEntryContainer, findsNWidgets(6));
  });
}
