import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/models/mobile/views/venue_page_model.dart';
import 'package:seat_saver/pages/mobile/views/ratings_page.dart';
import 'package:seat_saver/pages/mobile/views/successful_reservation.dart';
import 'package:seat_saver/pages/mobile/views/venue_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late VenuePageModel loggedOutModel;
  late VenuePageModel loggedInModel;

  const mockVenueId = 1;
  const mockUserId = 1;

  setUp(() {
    setupSharedPrefsMock();

    loggedOutModel = VenuePageModel(
      venueId: mockVenueId,
      venuesApi: FakeVenuesApi(),
      reservationsApi: FakeReservationsApi(),
    );

    loggedInModel = VenuePageModel(
      venueId: mockVenueId,
      userId: mockUserId,
      venuesApi: FakeVenuesApi(),
      reservationsApi: FakeReservationsApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    ignoreOverflowErrors();
    final customAppBar = find.byKey(const Key('customAppBar'));
    final headerImage = find.byKey(const Key('headerImage'));
    final name = find.text('FIRST VENUE');
    final type = find.text('RESTAURANT');
    final location = find.text('Porec');
    final availability = find.text('20 / 20 currently available');
    final workingHours = find.text('Working hours: 00:01 - 23:59');
    final workingDays = find.text(
      'Working days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday',
    );
    final rating = find.text(' 3.5');
    final description = find.text(
      'This is the first venue used for testing purposes.',
    );
    final peopleButton = find.byKey(const Key('peopleButton'));
    final dateButton = find.byKey(const Key('dateButton'));
    final timeButton = find.byKey(const Key('timeButton'));
    final imagesTabBar = find.byKey(const Key('imagesTabBar'));
    final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuePage(venueId: mockVenueId, modelOverride: loggedOutModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(headerImage, findsOneWidget);
    expect(name, findsOneWidget);
    expect(type, findsOneWidget);
    expect(location, findsOneWidget);
    expect(availability, findsOneWidget);
    expect(workingHours, findsOneWidget);
    expect(workingDays, findsOneWidget);
    expect(rating, findsOneWidget);
    expect(description, findsOneWidget);
    expect(peopleButton, findsOneWidget);
    expect(dateButton, findsOneWidget);
    expect(timeButton, findsOneWidget);
    expect(imagesTabBar, findsOneWidget);
    expect(reserveSpotButton, findsOneWidget);
  });

  testWidgets('should navigate to ratings page', (tester) async {
    ignoreOverflowErrors();
    final viewRatingsButton = find.byKey(const Key('viewRatingsButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuePage(venueId: mockVenueId, modelOverride: loggedOutModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      viewRatingsButton,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(viewRatingsButton, findsOneWidget);
    await tester.tap(viewRatingsButton);
    await tester.pumpAndSettle();

    expect(find.byType(RatingsPage), findsOneWidget);
  });

  testWidgets(
    'should display toaster with validation error when trying to reserve without being logged in',
    (tester) async {
      ignoreOverflowErrors();
      final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenuePage(
              venueId: mockVenueId,
              modelOverride: loggedOutModel,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(reserveSpotButton, findsOneWidget);

      await tester.tap(reserveSpotButton);
      await tester.pumpAndSettle();

      expect(find.text('Please log in to reserve a spot'), findsOneWidget);
    },
  );

  testWidgets(
    'should display toaster with validation error when trying to reserve without selecting number of guests',
    (tester) async {
      ignoreOverflowErrors();
      final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenuePage(venueId: mockVenueId, modelOverride: loggedInModel),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(reserveSpotButton, findsOneWidget);

      await tester.tap(reserveSpotButton);
      await tester.pumpAndSettle();

      expect(find.text('Please select the number of people'), findsOneWidget);
    },
  );

  testWidgets(
    'should display toaster with validation error when trying to reserve without selecting date',
    (tester) async {
      ignoreOverflowErrors();
      final dateButton = find.byKey(const Key('dateButton'));
      final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenuePage(venueId: mockVenueId, modelOverride: loggedInModel),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(dateButton, findsOneWidget);
      expect(reserveSpotButton, findsOneWidget);

      await tester.scrollUntilVisible(
        dateButton,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      // We have to select and deselect a date to trigger the validation error
      // because the date picker defaults to the current date
      await tester.tap(dateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('25').last);
      await tester.pumpAndSettle();
      await tester.tap(dateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('25').last);
      await tester.pumpAndSettle();

      await tester.tap(reserveSpotButton);
      await tester.pumpAndSettle();

      expect(find.text('Please select a date'), findsOneWidget);
    },
  );

  testWidgets(
    'should display toaster with validation error when trying to reserve without selecting time',
    (tester) async {
      ignoreOverflowErrors();
      final timeButton = find.byKey(const Key('timeButton'));
      final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenuePage(venueId: mockVenueId, modelOverride: loggedInModel),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(timeButton, findsOneWidget);
      expect(reserveSpotButton, findsOneWidget);

      await tester.scrollUntilVisible(
        timeButton,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      // We have to select and deselect a time to trigger the validation error
      // because the date picker defaults to the current time
      await tester.tap(timeButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('44')));
      await tester.pumpAndSettle();
      await tester.tap(timeButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('3')));
      await tester.pumpAndSettle();

      await tester.tap(reserveSpotButton);
      await tester.pumpAndSettle();

      expect(find.text('Please select a time'), findsOneWidget);
    },
  );

  testWidgets(
    'should create reservation and navigate to successful reservation page when all inputs are valid',
    (tester) async {
      ignoreOverflowErrors();
      setupSharedPrefsMock(initialValues: {'userId': mockUserId});
      final peopleButton = find.byKey(const Key('peopleButton'));
      final reserveSpotButton = find.byKey(const Key('reserveSpotButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenuePage(
              venueId: mockVenueId,
              userId: mockUserId,
              modelOverride: loggedInModel,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(peopleButton, findsOneWidget);
      expect(reserveSpotButton, findsOneWidget);

      await tester.scrollUntilVisible(
        peopleButton,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(peopleButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 people').last);
      await tester.pumpAndSettle();

      await tester.tap(reserveSpotButton);
      await tester.pumpAndSettle();

      expect(find.byType(SuccessfulReservation), findsOneWidget);
    },
  );
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<Venue?> getVenue(int venueId) async {
    return Venue(
      id: 1,
      name: 'First venue',
      location: 'Porec',
      workingDays: [0, 1, 2, 3, 4, 5, 6],
      workingHours: '00:01 - 23:59',
      maximumCapacity: 20,
      availableCapacity: 20,
      rating: 3.5,
      typeId: 1,
      description: 'This is the first venue used for testing purposes.',
    );
  }

  @override
  Future<String?> getVenueType(int typeId) async {
    return 'Restaurant';
  }

  @override
  Future<List<Uint8List>> getVenueImages(int venueId) async {
    return [];
  }

  @override
  Future<List<Uint8List>> getMenuImages(int venueId) async {
    return [];
  }
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<BasicResponse> createReservation({
    required int venueId,
    required int numberOfGuests,
    required DateTime reservationDate,
    int? userId,
    String? userEmail,
  }) async {
    return BasicResponse(
      success: true,
      message: 'Reservation created successfully',
    );
  }
}
