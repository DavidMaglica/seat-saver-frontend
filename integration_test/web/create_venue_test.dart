import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_reserver/components/web/modals/create_venue_modal.dart';
import 'package:table_reserver/main.dart' as app;
import 'package:table_reserver/pages/web/views/venue_page.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const email = 'owner@mail.com';
  const password = 'password';

  testWidgets('should be able to login with existing account', (tester) async {
    setupWebIntegrationTestErrorFilters();
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    final logInEmailField = find.byKey(const Key('logInEmailField'));
    final logInPasswordField = find.byKey(const Key('logInPasswordField'));
    final logInButton = find.byKey(const Key('logInButton'));
    final logInTab = find.byKey(const Key('logInTab'));
    final createVenueButton = find.byKey(const Key('createVenueButton'));
    final venueNameField = find.byKey(const Key('venueNameField'));
    final venueLocationField = find.byKey(const Key('venueLocationField'));
    final maxCapacityField = find.byKey(const Key('maxCapacityField'));
    final venueDescriptionField = find.byKey(
      const Key('venueDescriptionField'),
    );
    final venueTypeDropdown = find.byKey(const Key('venueTypeDropdown'));
    final workingHoursField = find.byKey(const Key('workingHoursField'));
    final dayChipMonday = find.byKey(const Key('dayChip_Monday'));
    final dayChipTuesday = find.byKey(const Key('dayChip_Tuesday'));
    final dayChipWednesday = find.byKey(const Key('dayChip_Wednesday'));
    final submitButton = find.byKey(const Key('submitButton'));

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

    expect(createVenueButton, findsOneWidget);

    await tester.tap(createVenueButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CreateVenueModal), findsOneWidget);

    expect(venueNameField, findsOneWidget);
    expect(venueLocationField, findsOneWidget);
    expect(maxCapacityField, findsOneWidget);
    expect(venueDescriptionField, findsOneWidget);
    expect(venueTypeDropdown, findsOneWidget);
    expect(workingHoursField, findsOneWidget);
    expect(dayChipMonday, findsOneWidget);
    expect(dayChipTuesday, findsOneWidget);
    expect(dayChipWednesday, findsOneWidget);
    expect(submitButton, findsOneWidget);

    await tester.enterText(venueNameField, 'Test Venue');
    await tester.enterText(venueLocationField, 'Poreč, Croatia');
    await tester.enterText(maxCapacityField, '50');
    await tester.enterText(workingHoursField, '08:00 - 22:00');
    await tester.tap(dayChipMonday);
    await tester.tap(dayChipTuesday);
    await tester.tap(dayChipWednesday);
    await tester.enterText(venueDescriptionField, 'Test venue.');
    await tester.tap(venueTypeDropdown);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final venueTypeOption = find.text('   Japanese').last;
    expect(venueTypeOption, findsOneWidget);
    await tester.tap(venueTypeOption);
    await tester.pump();
    await tester.pump(Duration(milliseconds: 500));

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebVenuePage), findsOneWidget);
  });
}
