import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/components/web/modals/delete_modal.dart';
import 'package:seat_saver/models/web/components/side_nav_model.dart';
import 'package:seat_saver/models/web/views/reservations_model.dart';
import 'package:seat_saver/pages/web/views/reservations.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late ReservationsModel model;
  late ReservationsModel emptyReservationModel;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'ownerId': 1});

    model = ReservationsModel(
      venueId: null,
      reservationsApi: FakeReservationsApi(),
      accountApi: FakeAccountApi(),
      venuesApi: FakeVenuesApi(),
    );

    emptyReservationModel = ReservationsModel(
      venueId: null,
      reservationsApi: EmptyReservationsApi(),
      accountApi: FakeAccountApi(),
      venuesApi: FakeVenuesApi(),
    );
  });

  testWidgets('should display widget correctly when no reservations', (
    tester,
  ) async {
    ignoreOverflowErrors();

    final title = find.text('Your Reservations');
    final viewAllReservationsButton = find.byKey(
      const Key('viewAllReservationsButton'),
    );
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final createReservationButton = find.byKey(
      const Key('createReservationButton'),
    );
    final noReservationsText = find.byKey(const Key('noReservationsText'));
    final table = find.byKey(const Key('table'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebReservations(modelOverride: emptyReservationModel),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(title, findsOneWidget);
    expect(viewAllReservationsButton, findsNothing);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(createReservationButton, findsOneWidget);
    expect(noReservationsText, findsOneWidget);
    expect(table, findsNothing);
  });

  testWidgets('should display widget correctly when reservations are present', (
    tester,
  ) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final title = find.text('Your Reservations');
    final viewAllReservationsButton = find.byKey(
      const Key('viewAllReservationsButton'),
    );
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final createReservationButton = find.byKey(
      const Key('createReservationButton'),
    );
    final noReservationsText = find.byKey(const Key('noReservationsText'));
    final table = find.byKey(const Key('table'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebReservations(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(title, findsOneWidget);
    expect(viewAllReservationsButton, findsNothing);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(createReservationButton, findsOneWidget);
    expect(noReservationsText, findsNothing);
    expect(table, findsOneWidget);
    expect(find.text('First venue'), findsNWidgets(2));
    expect(find.text('test@mail.com'), findsNWidgets(2));
    expect(find.text('2'), findsNWidgets(2));
  });

  testWidgets(
    'should display widget correctly when single venue reservations',
    (tester) async {
      ignoreOverflowErrors();

      final title = find.text('Your Reservations for First venue');
      final viewAllReservationsButton = find.byKey(
        const Key('viewAllReservationsButton'),
      );
      final timerDropdown = find.byKey(const Key('timerDropdown'));
      final refreshButton = find.byKey(const Key('refreshButton'));
      final createReservationButton = find.byKey(
        const Key('createReservationButton'),
      );
      final noReservationsText = find.byKey(const Key('noReservationsText'));
      final table = find.byKey(const Key('table'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
          child: MaterialApp(
            home: Scaffold(
              body: WebReservations(venueId: 1, modelOverride: model),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(title, findsOneWidget);
      expect(viewAllReservationsButton, findsOneWidget);
      expect(timerDropdown, findsOneWidget);
      expect(refreshButton, findsOneWidget);
      expect(createReservationButton, findsOneWidget);
      expect(noReservationsText, findsNothing);
      expect(table, findsOneWidget);
    },
  );

  testWidgets('should update table when refresh button tapped', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final refreshButton = find.byKey(const Key('refreshButton'));
    final table = find.byKey(const Key('table'));
    final editReservationButton = find.byKey(
      const Key('editReservationButton'),
    );
    final deleteReservationButton = find.byKey(
      const Key('deleteReservationButton'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebReservations(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(refreshButton, findsOneWidget);
    expect(table, findsOneWidget);
    expect(editReservationButton, findsNWidgets(2));
    expect(deleteReservationButton, findsNWidgets(2));

    await tester.tap(refreshButton);
    await tester.pumpAndSettle();

    expect(editReservationButton, findsNWidgets(3));
    expect(deleteReservationButton, findsNWidgets(3));
  });

  testWidgets('should open delete reservation modal when action tapped', (
    tester,
  ) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final deleteReservationButton = find.byKey(
      const Key('deleteReservationButton'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(body: WebReservations(modelOverride: model)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(deleteReservationButton, findsNWidgets(2));

    await tester.tap(deleteReservationButton.first);
    await tester.pumpAndSettle();

    expect(find.byType(DeleteModal), findsOneWidget);
  });
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  final List<ReservationDetails> _reservations = [
    ReservationDetails(
      id: 1,
      userId: 1,
      venueId: 1,
      numberOfGuests: 2,
      datetime: DateTime.now(),
    ),
  ];

  @override
  Future<List<ReservationDetails>> getVenueReservations(int venueId) async {
    _reservations.add(
      ReservationDetails(
        id: _reservations.length + 1,
        userId: 1,
        venueId: 1,
        numberOfGuests: 2,
        datetime: DateTime.now().add(Duration(days: _reservations.length)),
      ),
    );
    return _reservations;
  }

  @override
  Future<List<ReservationDetails>> getOwnerReservations(int ownerId) async {
    _reservations.add(
      ReservationDetails(
        id: _reservations.length + 1,
        userId: 1,
        venueId: 1,
        numberOfGuests: _reservations.length + 1,
        datetime: DateTime.now().add(Duration(days: _reservations.length)),
      ),
    );
    return _reservations;
  }
}

class EmptyReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<List<ReservationDetails>> getVenueReservations(int venueId) async {
    return [];
  }

  @override
  Future<List<ReservationDetails>> getOwnerReservations(int ownerId) async {
    return [];
  }
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<List<User>> getUsersByIds(List<int> userIds) async {
    return [User(id: 1, username: 'username', email: 'test@mail.com')];
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final Venue _venue = Venue(
    id: 1,
    name: 'First venue',
    location: 'Porec',
    workingDays: [0, 1, 2, 3],
    workingHours: '08:00 - 17:00',
    maximumCapacity: 20,
    availableCapacity: 20,
    rating: 3.5,
    typeId: 1,
  );

  @override
  Future<Venue?> getVenue(int venueId) async {
    return _venue;
  }

  @override
  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    return PagedResponse<Venue>(
      content: [_venue],
      page: 0,
      size: 1,
      totalElements: 1,
      totalPages: 1,
    );
  }
}
