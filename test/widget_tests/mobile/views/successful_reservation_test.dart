import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/pages/mobile/views/successful_reservation.dart';
import 'package:seat_saver/utils/routes.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  const mockVenueName = 'First Venue';
  const mockNumberOfGuests = 4;
  final mockReservationDateTime = DateTime.now();

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': 1});
  });

  testWidgets('should display widget correctly', (tester) async {
    final titleText = find.byKey(const Key('titleText'));
    final icon = find.byKey(const Key('icon'));
    final messageText = find.byKey(const Key('messageText'));
    final backButton = find.byKey(const Key('backButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SuccessfulReservation(
              venueName: mockVenueName,
              numberOfGuests: mockNumberOfGuests,
              reservationDateTime: mockReservationDateTime,
            ),
          ),
        ),
      ),
    );

    expect(titleText, findsOneWidget);
    expect(icon, findsOneWidget);
    expect(messageText, findsOneWidget);
    expect(backButton, findsOneWidget);
  });

  testWidgets('should navigate back to homepage with button', (tester) async {
    final backButton = find.byKey(const Key('backButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: SuccessfulReservation(
          venueName: mockVenueName,
          numberOfGuests: mockNumberOfGuests,
          reservationDateTime: mockReservationDateTime,
        ),
        routes: {Routes.homepage: (context) => Homepage()},
      ),
    );

    expect(backButton, findsOneWidget);
    await tester.tap(backButton);

    expect(find.byType(SuccessfulReservation), findsOneWidget);
  });

  testWidgets('should navigate back to homepage with timer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SuccessfulReservation(
          venueName: mockVenueName,
          numberOfGuests: mockNumberOfGuests,
          reservationDateTime: mockReservationDateTime,
        ),
        routes: {Routes.homepage: (context) => Homepage()},
      ),
    );

    expect(find.byType(SuccessfulReservation), findsOneWidget);

    await tester.pump(const Duration(seconds: 16));
    await tester.pumpAndSettle();

    expect(find.byType(Homepage), findsOneWidget);
  });
}
