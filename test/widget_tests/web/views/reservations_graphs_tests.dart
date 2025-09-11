import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/models/web/components/side_nav_model.dart';
import 'package:seat_saver/models/web/views/reservations_graphs_page_model.dart';
import 'package:seat_saver/pages/web/views/reservations.dart';
import 'package:seat_saver/pages/web/views/reservations_graphs_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late ReservationsGraphsPageModel model;
  const ownerId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'ownerId': ownerId});

    model = ReservationsGraphsPageModel(
      ownerId: ownerId,
      reservationsApi: FakeReservationsApi(),
      venuesApi: FakeVenuesApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    maximizeTestWindow(tester);
    final customAppBar = find.byKey(const Key('customAppBar'));
    final dailyOption = find.byKey(const Key('dailyOption'));
    final weeklyOption = find.byKey(const Key('weeklyOption'));
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final graphsMasonryGrid = find.byKey(const Key('graphsMasonryGrid'));
    final viewReservationsButton = find.byKey(
      const Key('viewReservationsButton'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationsGraphsPage(ownerId: ownerId, modelOverride: model),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(dailyOption, findsOneWidget);
    expect(weeklyOption, findsOneWidget);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(graphsMasonryGrid, findsOneWidget);
    expect(viewReservationsButton, findsOneWidget);
    expect(find.text('First venue'), findsOneWidget);
    expect(find.text('Working hours: 08:00 - 17:00'), findsOneWidget);
    expect(
      find.text('Working days: Monday, Tuesday, Wednesday, Thursday'),
      findsOneWidget,
    );
    expect(find.text('00-04'), findsOneWidget);
    expect(find.text('04-08'), findsOneWidget);
    expect(find.text('08-12'), findsOneWidget);
    expect(find.text('12-16'), findsOneWidget);
    expect(find.text('16-20'), findsOneWidget);
  });

  testWidgets('should change view when select tapped', (tester) async {
    ignoreRangeErrors();
    maximizeTestWindow(tester);
    final customAppBar = find.byKey(const Key('customAppBar'));
    final dailyOption = find.byKey(const Key('dailyOption'));
    final weeklyOption = find.byKey(const Key('weeklyOption'));
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final graphsMasonryGrid = find.byKey(const Key('graphsMasonryGrid'));
    final viewReservationsButton = find.byKey(
      const Key('viewReservationsButton'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationsGraphsPage(ownerId: ownerId, modelOverride: model),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(dailyOption, findsOneWidget);
    expect(weeklyOption, findsOneWidget);

    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(graphsMasonryGrid, findsOneWidget);
    expect(viewReservationsButton, findsOneWidget);
    expect(find.text('First venue'), findsOneWidget);
    expect(find.text('Working hours: 08:00 - 17:00'), findsOneWidget);
    expect(
      find.text('Working days: Monday, Tuesday, Wednesday, Thursday'),
      findsOneWidget,
    );

    await tester.tap(weeklyOption);
    await tester.pumpAndSettle();

    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('Thursday'), findsOneWidget);
    expect(find.text('Friday'), findsOneWidget);
    expect(find.text('Saturday'), findsOneWidget);
    expect(find.text('Sunday'), findsOneWidget);
  });

  testWidgets('should navigate to reservations page', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final viewReservationsButton = find.byKey(
      const Key('viewReservationsButton'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: ReservationsGraphsPage(ownerId: ownerId, modelOverride: model),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(viewReservationsButton, findsOneWidget);

    await tester.tap(viewReservationsButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebReservations), findsOneWidget);
  });
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final List<Venue> _venues = [
    Venue(
      id: 1,
      name: 'First venue',
      location: 'Porec',
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 17:00',
      maximumCapacity: 20,
      availableCapacity: 20,
      rating: 3.5,
      typeId: 1,
    ),
  ];

  @override
  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    return PagedResponse<Venue>(
      content: _venues,
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<List<ReservationDetails>> getOwnerReservations(int ownerId) async {
    return [
      ReservationDetails(
        id: 1,
        userId: 1,
        venueId: 1,
        numberOfGuests: 1,
        datetime: DateTime.now(),
      ),
    ];
  }
}
