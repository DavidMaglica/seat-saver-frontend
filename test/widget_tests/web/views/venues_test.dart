import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/web/components/side_nav_model.dart';
import 'package:table_reserver/models/web/views/venues_model.dart';
import 'package:table_reserver/pages/web/views/venues.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late VenuesModel model;
  late VenuesModel emptyVenuesModel;

  const ownerId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'ownerId': ownerId});

    model = VenuesModel(venuesApi: FakeVenuesApi());
    emptyVenuesModel = VenuesModel(venuesApi: EmptyVenuesApi());
  });

  testWidgets('should display widget correctly when no venues', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final noVenuesText = find.text('No venues available');
    final venueCard = find.byKey(const Key('venueCard'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: WebVenuesPage(modelOverride: emptyVenuesModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(noVenuesText, findsOneWidget);
    expect(venueCard, findsNothing);
  });

  testWidgets('should display widget correctly with venues', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);
    final noVenuesText = find.text('No venues available');
    final venueCard = find.byKey(const Key('venueCard'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(home: WebVenuesPage(modelOverride: model)),
      ),
    );
    await tester.pumpAndSettle();

    expect(noVenuesText, findsNothing);
    expect(venueCard, findsNWidgets(2));
    expect(find.text('First venue'), findsNWidgets(2));
    expect(find.text('Second venue'), findsNWidgets(2));
  });
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    return PagedResponse<Venue>(
      content: [
        Venue(
          id: 1,
          name: 'First venue',
          location: 'Porec',
          workingDays: [0, 1, 2],
          workingHours: '08:00 - 17:00',
          maximumCapacity: 20,
          availableCapacity: 20,
          rating: 3.0,
          typeId: 1,
        ),
        Venue(
          id: 2,
          name: 'Second venue',
          location: 'Zagreb',
          workingDays: [0, 1, 2, 3],
          workingHours: '09:00 - 18:00',
          maximumCapacity: 30,
          availableCapacity: 25,
          rating: 4.5,
          typeId: 2,
        ),
      ],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }
}

class EmptyVenuesApi extends Fake implements VenuesApi {
  @override
  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    return PagedResponse<Venue>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }
}
