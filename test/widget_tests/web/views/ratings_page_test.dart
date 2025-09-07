import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/web/components/side_nav_model.dart';
import 'package:table_reserver/models/web/views/ratings_page_model.dart';
import 'package:table_reserver/pages/web/views/ratings_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late WebRatingsPageModel model = WebRatingsPageModel(
    ownerId: 1,
    venuesApi: FakeVenuesApi(),
  );

  const ownerId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'ownerId': ownerId});

    model = WebRatingsPageModel(ownerId: ownerId, venuesApi: FakeVenuesApi());
  });

  testWidgets('should display widget correctly', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final customAppBar = find.byKey(const Key('customAppBar'));
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final ratingsMasonryGrid = find.byKey(const Key('ratingsMasonryGrid'));
    final viewRatingsButton = find.byKey(const Key('viewRatingsButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebRatingsPage(ownerId: ownerId, modelOverride: model),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(ratingsMasonryGrid, findsOneWidget);
    expect(viewRatingsButton, findsNWidgets(2));
    expect(find.text('First venue'), findsOneWidget);
    expect(find.text('Second venue'), findsOneWidget);
    expect(find.text('4.0'), findsNWidgets(2));
    expect(find.text('2 Ratings'), findsOneWidget);
    expect(find.text('3 Ratings'), findsOneWidget);
  });

  testWidgets('should refresh data when button tapped', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final refreshButton = find.byKey(const Key('refreshButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebRatingsPage(ownerId: ownerId, modelOverride: model),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(refreshButton, findsOneWidget);
    expect(find.text('First venue'), findsOneWidget);
    expect(find.text('Second venue'), findsOneWidget);
    expect(find.text('4.0'), findsNWidgets(2));
    expect(find.text('2 Ratings'), findsOneWidget);
    expect(find.text('3 Ratings'), findsOneWidget);

    await tester.tap(refreshButton);
    await tester.pumpAndSettle();

    expect(find.text('First venue'), findsOneWidget);
    expect(find.text('Second venue'), findsOneWidget);
    expect(find.text('4.0'), findsNWidgets(2));
    expect(find.text('4 Ratings'), findsOneWidget);
    expect(find.text('5 Ratings'), findsOneWidget);
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
    Venue(
      id: 2,
      name: 'Second venue',
      location: 'Pula',
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 17:00',
      maximumCapacity: 20,
      availableCapacity: 20,
      rating: 4.0,
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
      size: 2,
      totalElements: 2,
      totalPages: 1,
    );
  }

  final List<Rating> _ratings = [
    Rating(id: 1, rating: 4.0, username: 'username', comment: 'comment'),
  ];

  @override
  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    _ratings.add(
      Rating(
        id: _ratings.length + 1,
        rating: 4.0,
        username: 'username',
        comment: 'comment',
      ),
    );
    return _ratings;
  }
}
