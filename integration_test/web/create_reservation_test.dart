import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_reserver/components/web/modals/create_reservation_modal.dart';
import 'package:table_reserver/main.dart' as app;
import 'package:table_reserver/pages/web/views/reservations.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'owner@mail.com';
  const password = 'password';

  testWidgets('should be able create new reservation', (tester) async {
    setupWebIntegrationTestErrorFilters();
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    final logInEmailField = find.byKey(const Key('logInEmailField'));
    final logInPasswordField = find.byKey(const Key('logInPasswordField'));
    final logInButton = find.byKey(const Key('logInButton'));
    final logInTab = find.byKey(const Key('logInTab'));
    final reservationsNavButton = find.byKey(
      const Key('reservationsNavButton'),
    );
    final createReservationButton = find.byKey(
      const Key('createReservationButton'),
    );
    final venueDropdown = find.byKey(const Key('venueDropdown'));
    final numberOfGuestsField = find.byKey(const Key('numberOfGuestsField'));
    final userEmailField = find.byKey(const Key('userEmailField'));
    final reservationDateField = find.byKey(const Key('reservationDateField'));
    final venueNameFinder = find.text('Test Venue');
    final userEmailFinder = find.text('owner@mail.com');
    final numberOfGuestsFinder = find.text('2');
    final editReservationButton = find.byKey(
      const Key('editReservationButton'),
    );
    final deleteReservationButton = find.byKey(
      const Key('deleteReservationButton'),
    );

    app.main();

    await tester.pumpAndSettle();

    expect(getStartedButton, findsOneWidget);

    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    expect(logInTab, findsOneWidget);

    await tester.tap(logInTab);
    await tester.pumpAndSettle();

    expect(logInEmailField, findsOneWidget);
    expect(logInPasswordField, findsOneWidget);
    expect(logInButton, findsOneWidget);

    await tester.enterText(logInEmailField, email);
    await tester.enterText(logInPasswordField, password);
    await tester.pumpAndSettle();
    await tester.tap(logInButton);
    await tester.pumpAndSettle();

    expect(reservationsNavButton, findsOneWidget);

    await tester.tap(reservationsNavButton);
    await tester.pumpAndSettle();

    expect(createReservationButton, findsOneWidget);
    await tester.tap(createReservationButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(CreateReservationModal), findsOneWidget);

    expect(venueDropdown, findsOneWidget);
    expect(userEmailField, findsOneWidget);
    expect(numberOfGuestsField, findsOneWidget);
    expect(reservationDateField, findsOneWidget);

    await tester.enterText(userEmailField, 'owner@mail.com');
    await tester.enterText(numberOfGuestsField, '2');
    await tester.pump();
    await tester.tap(venueDropdown);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final dropdownItem = find.text('    Test Venue').last;
    expect(dropdownItem, findsOneWidget);
    await tester.tap(dropdownItem);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(reservationDateField);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final dayToSelect = find.text('25').last;
    expect(dayToSelect, findsOneWidget);
    await tester.tap(dayToSelect);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final okButton = find.text('OK');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final submitButton = find.byKey(const Key('submitButton'));
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebReservations), findsOneWidget);

    expect(venueNameFinder, findsOneWidget);
    expect(userEmailFinder, findsNWidgets(2));
    expect(numberOfGuestsFinder, findsOneWidget);
    expect(editReservationButton, findsOneWidget);
    expect(deleteReservationButton, findsOneWidget);
  });
}
