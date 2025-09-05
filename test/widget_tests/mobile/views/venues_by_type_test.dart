import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/data/venue_type.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/mobile/views/venues_by_type_model.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/pages/mobile/views/venues_by_type.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late VenuesByTypeModel nearbyModel;
  late VenuesByTypeModel emptyNearbyModel;

  late VenuesByTypeModel newModel;
  late VenuesByTypeModel emptyNewModel;

  late VenuesByTypeModel trendingModel;
  late VenuesByTypeModel emptyTrendingModel;

  late VenuesByTypeModel suggestedModel;
  late VenuesByTypeModel emptySuggestedModel;

  setUp(() {
    setupSharedPrefsMock(initialValues: {});
    nearbyModel = VenuesByTypeModel(type: 'nearby', venuesApi: FakeVenuesApi());
    emptyNearbyModel = VenuesByTypeModel(
      type: 'nearby',
      venuesApi: EmptyVenuesApi(),
    );

    newModel = VenuesByTypeModel(type: 'new', venuesApi: FakeVenuesApi());
    emptyNewModel = VenuesByTypeModel(type: 'new', venuesApi: EmptyVenuesApi());

    trendingModel = VenuesByTypeModel(
      type: 'trending',
      venuesApi: FakeVenuesApi(),
    );
    emptyTrendingModel = VenuesByTypeModel(
      type: 'trending',
      venuesApi: EmptyVenuesApi(),
    );

    suggestedModel = VenuesByTypeModel(
      type: 'suggested',
      venuesApi: FakeVenuesApi(),
    );
    emptySuggestedModel = VenuesByTypeModel(
      type: 'suggested',
      venuesApi: EmptyVenuesApi(),
    );
  });

  testWidgets('should display empty nearby venues widget', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Nearby Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No nearby venues found.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'nearby', modelOverride: emptyNearbyModel),
        ),
      ),
    );

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsNothing);
    expect(venueCard, findsNothing);
    expect(noVenuesText, findsOneWidget);
  });

  testWidgets('should display nearby venues widget with venues', (
    tester,
  ) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Nearby Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No nearby venues found.');
    final firstVenueName = find.text('First venue');
    final firstVenueType = find.text('Restaurant');
    final firstVenueLocation = find.text('Porec');
    final secondVenueName = find.text('Second venue');
    final secondVenueType = find.text('Cafe');
    final secondVenueLocation = find.text('Rovinj');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'nearby', modelOverride: nearbyModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsOneWidget);
    expect(venueCard, findsNWidgets(2));
    expect(firstVenueName, findsNWidgets(2));
    expect(firstVenueType, findsOneWidget);
    expect(firstVenueLocation, findsOneWidget);
    expect(secondVenueName, findsNWidgets(2));
    expect(secondVenueType, findsOneWidget);
    expect(secondVenueLocation, findsOneWidget);
    expect(noVenuesText, findsNothing);
  });

  testWidgets('should display empty new venues widget', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('New Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No new venues found.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'new', modelOverride: emptyNewModel),
        ),
      ),
    );

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsNothing);
    expect(venueCard, findsNothing);
    expect(noVenuesText, findsOneWidget);
  });

  testWidgets('should display new venues widget with venues', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('New Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No new venues found.');
    final firstVenueName = find.text('First venue');
    final firstVenueType = find.text('Restaurant');
    final firstVenueLocation = find.text('Porec');
    final secondVenueName = find.text('Second venue');
    final secondVenueType = find.text('Cafe');
    final secondVenueLocation = find.text('Rovinj');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'new', modelOverride: newModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsOneWidget);
    expect(venueCard, findsNWidgets(2));
    expect(firstVenueName, findsNWidgets(2));
    expect(firstVenueType, findsOneWidget);
    expect(firstVenueLocation, findsOneWidget);
    expect(secondVenueName, findsNWidgets(2));
    expect(secondVenueType, findsOneWidget);
    expect(secondVenueLocation, findsOneWidget);
    expect(noVenuesText, findsNothing);
  });

  testWidgets('should display empty trending venues widget', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Trending Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No trending venues found.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(
            type: 'trending',
            modelOverride: emptyTrendingModel,
          ),
        ),
      ),
    );

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsNothing);
    expect(venueCard, findsNothing);
    expect(noVenuesText, findsOneWidget);
  });

  testWidgets('should display trending venues widget with venues', (
    tester,
  ) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Trending Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No trending venues found.');
    final firstVenueName = find.text('First venue');
    final firstVenueType = find.text('Restaurant');
    final firstVenueLocation = find.text('Porec');
    final secondVenueName = find.text('Second venue');
    final secondVenueType = find.text('Cafe');
    final secondVenueLocation = find.text('Rovinj');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'trending', modelOverride: trendingModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsOneWidget);
    expect(venueCard, findsNWidgets(2));
    expect(firstVenueName, findsNWidgets(2));
    expect(firstVenueType, findsOneWidget);
    expect(firstVenueLocation, findsOneWidget);
    expect(secondVenueName, findsNWidgets(2));
    expect(secondVenueType, findsOneWidget);
    expect(secondVenueLocation, findsOneWidget);
    expect(noVenuesText, findsNothing);
  });

  testWidgets('should display empty suggested venues widget', (tester) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Suggested Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No suggested venues found.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(
            type: 'suggested',
            modelOverride: emptySuggestedModel,
          ),
        ),
      ),
    );

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsNothing);
    expect(venueCard, findsNothing);
    expect(noVenuesText, findsOneWidget);
  });

  testWidgets('should display suggested venues widget with venues', (
    tester,
  ) async {
    final customAppBar = find.byKey(const Key('customAppBar'));
    final appBarTitle = find.text('Suggested Venues');
    final venuesListView = find.byKey(const Key('venuesListView'));
    final venueCard = find.byKey(const Key('venueCard'));
    final noVenuesText = find.text('No suggested venues found.');
    final firstVenueName = find.text('First venue');
    final firstVenueType = find.text('Restaurant');
    final firstVenueLocation = find.text('Porec');
    final secondVenueName = find.text('Second venue');
    final secondVenueType = find.text('Cafe');
    final secondVenueLocation = find.text('Rovinj');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'suggested', modelOverride: suggestedModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(customAppBar, findsOneWidget);
    expect(appBarTitle, findsOneWidget);
    expect(venuesListView, findsOneWidget);
    expect(venueCard, findsNWidgets(2));
    expect(firstVenueName, findsNWidgets(2));
    expect(firstVenueType, findsOneWidget);
    expect(firstVenueLocation, findsOneWidget);
    expect(secondVenueName, findsNWidgets(2));
    expect(secondVenueType, findsOneWidget);
    expect(secondVenueLocation, findsOneWidget);
    expect(noVenuesText, findsNothing);
  });

  testWidgets('should open venue page when item tapped', (tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
        return;
      }
      originalOnError?.call(details);
    };
    final venueCard = find.byKey(const Key('venueCard'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenuesByType(type: 'nearby', modelOverride: nearbyModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(venueCard, findsNWidgets(2));
    await tester.tap(venueCard.first);
    await tester.pumpAndSettle();

    expect(find.byType(VenuePage), findsOneWidget);
  });
}

class EmptyVenuesApi extends Fake implements VenuesApi {
  @override
  Future<PagedResponse<Venue>> getNearbyVenues(
    double? latitude,
    double? longitude, {
    int page = 0,
    int size = 15,
  }) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }

  @override
  Future<PagedResponse<Venue>> getTrendingVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }

  @override
  Future<PagedResponse<Venue>> getNewVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }

  @override
  Future<PagedResponse<Venue>> getSuggestedVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }

  @override
  Future<List<VenueType>> getAllVenueTypes() async {
    return [];
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final List<Venue> venues = [
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
      location: 'Rovinj',
      workingDays: [0, 1, 2, 3],
      workingHours: '10:00 - 22:00',
      maximumCapacity: 50,
      availableCapacity: 50,
      rating: 4.0,
      typeId: 2,
    ),
  ];

  @override
  Future<PagedResponse<Venue>> getNearbyVenues(
    double? latitude,
    double? longitude, {
    int page = 0,
    int size = 15,
  }) async {
    return PagedResponse<Venue>(
      content: venues,
      page: 0,
      size: venues.length,
      totalElements: venues.length,
      totalPages: 1,
    );
  }

  @override
  Future<PagedResponse<Venue>> getTrendingVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: venues,
      page: 0,
      size: venues.length,
      totalElements: venues.length,
      totalPages: 1,
    );
  }

  @override
  Future<PagedResponse<Venue>> getNewVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: venues,
      page: 0,
      size: venues.length,
      totalElements: venues.length,
      totalPages: 1,
    );
  }

  @override
  Future<PagedResponse<Venue>> getSuggestedVenues({
    int page = 0,
    int size = 10,
  }) async {
    return PagedResponse<Venue>(
      content: venues,
      page: 0,
      size: venues.length,
      totalElements: venues.length,
      totalPages: 1,
    );
  }

  @override
  Future<List<VenueType>> getAllVenueTypes() async {
    return [
      VenueType(id: 1, type: 'restaurant'),
      VenueType(id: 2, type: 'cafe'),
    ];
  }
}
