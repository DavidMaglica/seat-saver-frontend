import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/data/venue_type.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/mobile/views/search_model.dart';
import 'package:table_reserver/pages/mobile/views/search.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/utils/routes.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late SearchModel searchModel;
  late SearchModel emptySearchModel;

  setUp(() {
    setupSharedPrefsMock(initialValues: {});

    searchModel = SearchModel(venuesApi: FakeVenuesApi());
    emptySearchModel = SearchModel(venuesApi: EmptyVenuesApi());
  });

  testWidgets('should display widget correctly when venues are empty', (
    tester,
  ) async {
    final searchBar = find.byKey(const Key('searchBar'));
    final searchBarHint = find.text(
      'Type to search for venues (by name or city)',
    );
    final filterText = find.text('Filter by type');
    final filterModal = find.byKey(const Key('filterModal'));
    final noVenuesText = find.text('No venues available');

    await tester.pumpWidget(
      MaterialApp(home: Search(modelOverride: emptySearchModel)),
    );

    expect(searchBar, findsOneWidget);
    expect(searchBarHint, findsOneWidget);
    expect(filterText, findsOneWidget);
    expect(filterModal, findsNothing);
    expect(noVenuesText, findsOneWidget);
  });

  testWidgets('should display widget correctly with venues', (tester) async {
    final searchBar = find.byKey(const Key('searchBar'));
    final searchBarHint = find.text(
      'Type to search for venues (by name or city)',
    );
    final filterText = find.text('Filter by type');
    final filterModal = find.byKey(const Key('filterModal'));
    final listTile = find.byKey(const Key('venueListTile'));
    final firstVenue = find.text('First venue');
    final secondVenue = find.text('Second venue');
    final noVenuesText = find.text('No venues available');

    await tester.pumpWidget(
      MaterialApp(home: Search(modelOverride: searchModel)),
    );
    await tester.pumpAndSettle();

    expect(searchBar, findsOneWidget);
    expect(searchBarHint, findsOneWidget);
    expect(filterText, findsOneWidget);
    expect(filterModal, findsNothing);
    expect(listTile, findsNWidgets(2));
    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsOneWidget);
    expect(noVenuesText, findsNothing);
  });

  testWidgets('should display venues filtered by search query', (tester) async {
    final searchBar = find.byKey(const Key('searchBar'));
    final firstVenue = find.text('First venue');
    final secondVenue = find.text('Second venue');

    await tester.pumpWidget(
      MaterialApp(home: Search(modelOverride: searchModel)),
    );
    await tester.pumpAndSettle();

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsOneWidget);

    await tester.enterText(searchBar, 'First');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsNothing);

    await tester.enterText(searchBar, 'Second');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(firstVenue, findsNothing);
    expect(secondVenue, findsOneWidget);

    await tester.enterText(searchBar, 'venue');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsOneWidget);

    await tester.enterText(searchBar, 'Porec');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsNothing);

    await tester.enterText(searchBar, 'Rovinj');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(firstVenue, findsNothing);
    expect(secondVenue, findsOneWidget);
  });

  testWidgets('should filter venues by filtered type', (tester) async {
    final filterDropdown = find.byKey(const Key('filterDropdown'));
    final filterModal = find.byKey(const Key('filterModal'));
    final restaurantOption = find.byKey(const Key('filterSwitch_Restaurant'));
    final cafeOption = find.byKey(const Key('filterSwitch_Cafe'));
    final applyFiltersModalButton = find.byKey(
      const Key('applyFiltersModalButton'),
    );
    final clearFiltersModalButton = find.byKey(
      const Key('clearFiltersModalButton'),
    );
    final firstVenue = find.text('First venue');
    final secondVenue = find.text('Second venue');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Search(modelOverride: searchModel)),
      ),
    );
    await tester.pumpAndSettle();

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsOneWidget);

    await tester.tap(filterDropdown);
    await tester.pumpAndSettle();

    expect(filterModal, findsOneWidget);

    await tester.tap(restaurantOption);
    await tester.tap(applyFiltersModalButton);
    await tester.pumpAndSettle();

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsNothing);

    await tester.tap(filterDropdown);
    await tester.pumpAndSettle();

    expect(filterModal, findsOneWidget);

    await tester.tap(restaurantOption); // deselect
    await tester.tap(cafeOption);
    await tester.tap(applyFiltersModalButton);
    await tester.pumpAndSettle();

    expect(firstVenue, findsNothing);
    expect(secondVenue, findsOneWidget);

    await tester.tap(filterDropdown);
    await tester.pumpAndSettle();

    expect(filterModal, findsOneWidget);

    await tester.tap(clearFiltersModalButton);
    await tester.pumpAndSettle();

    expect(firstVenue, findsOneWidget);
    expect(secondVenue, findsOneWidget);
  });

  testWidgets('should navigate to venue page', (tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
        return;
      }
      originalOnError?.call(details);
    };
    final venuesListTile = find.byKey(const Key('venueListTile'));

    await tester.pumpWidget(
      MaterialApp(
        home: Search(modelOverride: searchModel),
        routes: {Routes.venue: (context) => const VenuePage(venueId: 1)},
      ),
    );
    await tester.pumpAndSettle();

    expect(venuesListTile, findsNWidgets(2));

    await tester.tap(venuesListTile.first);
    await tester.pumpAndSettle();

    expect(find.byType(VenuePage), findsOneWidget);
  });
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<List<VenueType>> getAllVenueTypes() async {
    return [
      VenueType(id: 1, type: 'Restaurant'),
      VenueType(id: 2, type: 'Cafe'),
    ];
  }

  @override
  Future<PagedResponse<Venue>> getAllVenues(
    int page,
    int size,
    String? searchQuery,
    List<int>? typeIds,
  ) async {
    final allVenues = [
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
    final filteredVenues = allVenues.where((venue) {
      final matchesQuery = searchQuery == null || searchQuery.isEmpty
          ? true
          : venue.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                venue.location.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );
      final matchesType = typeIds == null || typeIds.isEmpty
          ? true
          : typeIds.contains(venue.typeId);
      return matchesQuery && matchesType;
    }).toList();

    return PagedResponse<Venue>(
      content: filteredVenues,
      page: 0,
      size: filteredVenues.length,
      totalElements: filteredVenues.length,
      totalPages: 1,
    );
  }
}

class EmptyVenuesApi extends Fake implements VenuesApi {
  @override
  Future<List<VenueType>> getAllVenueTypes() async {
    return [
      VenueType(id: 1, type: 'Restaurant'),
      VenueType(id: 2, type: 'Cafe'),
    ];
  }

  @override
  Future<PagedResponse<Venue>> getAllVenues(
    int page,
    int size,
    String? searchQuery,
    List<int>? typeIds,
  ) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }
}
