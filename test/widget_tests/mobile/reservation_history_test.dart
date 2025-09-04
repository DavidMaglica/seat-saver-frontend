import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/mobile/views/reservation_history_model.dart';
import 'package:table_reserver/pages/mobile/settings/reservation_history.dart';

import '../../test_utils/shared_preferences_mock.dart';

void main() {
  late ReservationHistoryModel model;
  late ReservationHistoryModel emptyReservationModel;

  const mockUserId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    model = ReservationHistoryModel(
      userId: mockUserId,
      reservationsApi: FakeReservationsApi(),
      venuesApi: FakeVenuesApi(),
    );

    emptyReservationModel = ReservationHistoryModel(
      userId: mockUserId,
      reservationsApi: FakeReservationsApiEmpty(),
      venuesApi: FakeVenuesApi(),
    );
  });

  testWidgets(
    'should display no reservation history when no reservations made',
    (tester) async {
      final customAppBar = find.byKey(const Key('customAppBar'));
      final noReservationsText = find.text('No Reservation History');
      final reservationEntryButton = find.byKey(
        const Key('reservationEntryButton'),
      );
      final viewDetailsText = find.byKey(const Key('viewDetailsText'));
      final reservationDetailModal = find.byKey(
        const Key('reservationDetailModal'),
      );
      final reservationDetailModalTitle = find.byKey(
        const Key('reservationDetailModalTitle'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservationHistory(
              userId: mockUserId,
              modelOverride: emptyReservationModel,
            ),
          ),
        ),
      );

      expect(customAppBar, findsOneWidget);
      expect(noReservationsText, findsOneWidget);
      expect(reservationEntryButton, findsNothing);
      expect(viewDetailsText, findsNothing);
      expect(reservationDetailModal, findsNothing);
      expect(reservationDetailModalTitle, findsNothing);
    },
  );

  testWidgets(
    'should display reservation history correctly when reservations made',
    (tester) async {
      final customAppBar = find.byKey(const Key('customAppBar'));
      final noReservationsText = find.text('No Reservation History');
      final reservationEntryButton = find.byKey(
        const Key('reservationEntryButton'),
      );
      final viewDetailsText = find.byKey(const Key('viewDetailsText'));
      final reservationDetailModal = find.byKey(
        const Key('reservationDetailModal'),
      );
      final reservationDetailModalTitle = find.byKey(
        const Key('reservationDetailModalTitle'),
      );
      final venueNameText = find.text('Venue name');
      final venueNameValueText = find.text('First venue');
      final numberOfGuestsText = find.text('Number of Guests');
      final numberOfGuestsValueText = find.text('2');
      final dateTimeText = find.textContaining('Date');
      final dateTimeValueText = find.text(
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      );
      final cancelModalButton = find.byKey(const Key('cancelModalButton'));
      final deleteModalButton = find.byKey(const Key('deleteModalButton'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReservationHistory(userId: mockUserId, modelOverride: model),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(customAppBar, findsOneWidget);
      expect(noReservationsText, findsNothing);
      expect(reservationEntryButton, findsNWidgets(2));
      expect(viewDetailsText, findsNWidgets(2));
      expect(reservationDetailModal, findsNothing);
      expect(reservationDetailModalTitle, findsNothing);

      await tester.tap(reservationEntryButton.first);
      await tester.pumpAndSettle();

      expect(reservationDetailModal, findsOneWidget);
      expect(reservationDetailModalTitle, findsOneWidget);
      expect(venueNameText, findsOneWidget);
      expect(venueNameValueText, findsNWidgets(3));
      expect(numberOfGuestsText, findsOneWidget);
      expect(numberOfGuestsValueText, findsOneWidget);
      expect(dateTimeText, findsOneWidget);
      expect(dateTimeValueText, findsOneWidget);
      expect(cancelModalButton, findsOneWidget);
      expect(deleteModalButton, findsOneWidget);
    },
  );

  testWidgets('should close modal when cancel button tapped', (tester) async {
    final reservationEntryButton = find.byKey(
      const Key('reservationEntryButton'),
    );
    final reservationDetailModal = find.byKey(
      const Key('reservationDetailModal'),
    );
    final cancelModalButton = find.byKey(const Key('cancelModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationHistory(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(reservationEntryButton, findsNWidgets(2));
    expect(reservationDetailModal, findsNothing);
    expect(cancelModalButton, findsNothing);

    await tester.tap(reservationEntryButton.first);
    await tester.pumpAndSettle();

    expect(reservationDetailModal, findsOneWidget);
    expect(cancelModalButton, findsOneWidget);

    await tester.tap(cancelModalButton);
    await tester.pumpAndSettle();

    expect(reservationDetailModal, findsNothing);
    expect(cancelModalButton, findsNothing);
  });

  testWidgets('should delete entry from list when delete button tapped', (
    tester,
  ) async {
    final reservationEntryButton = find.byKey(
      const Key('reservationEntryButton'),
    );
    final reservationDetailModal = find.byKey(
      const Key('reservationDetailModal'),
    );
    final deleteModalButton = find.byKey(const Key('deleteModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationHistory(userId: mockUserId, modelOverride: model),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(reservationEntryButton, findsNWidgets(2));
    expect(reservationDetailModal, findsNothing);
    expect(deleteModalButton, findsNothing);

    await tester.tap(reservationEntryButton.first);
    await tester.pumpAndSettle();

    expect(reservationDetailModal, findsOneWidget);
    expect(deleteModalButton, findsOneWidget);

    await tester.tap(deleteModalButton);
    await tester.pumpAndSettle();

    expect(reservationDetailModal, findsNothing);
    expect(deleteModalButton, findsNothing);
    expect(reservationEntryButton, findsOneWidget);
  });
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<List<ReservationDetails>> getUserReservations(int userId) async {
    return [
      ReservationDetails(
        id: 1,
        userId: userId,
        venueId: 101,
        numberOfGuests: 2,
        datetime: DateTime.now(),
      ),
      ReservationDetails(
        id: 2,
        userId: userId,
        venueId: 102,
        datetime: DateTime.now().add(const Duration(days: 1)),
        numberOfGuests: 4,
      ),
    ];
  }

  @override
  Future<BasicResponse> deleteReservation(int reservationId) async {
    return BasicResponse(success: true, message: 'Deleted successfully.');
  }
}

class FakeReservationsApiEmpty extends Fake implements ReservationsApi {
  @override
  Future<List<ReservationDetails>> getUserReservations(int userId) async {
    return [];
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<Venue?> getVenue(int venueId) async {
    return Venue(
      id: 1,
      name: 'First venue',
      location: 'Venue Location',
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 22:00',
      maximumCapacity: 20,
      availableCapacity: 20,
      rating: 3.5,
      typeId: 1,
    );
  }
}
