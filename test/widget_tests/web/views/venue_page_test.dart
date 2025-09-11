import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/models/web/components/side_nav_model.dart';
import 'package:seat_saver/models/web/views/venue_page_model.dart';
import 'package:seat_saver/pages/web/views/venue_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late VenuePageModel model;

  const ownerId = 1;
  const venueId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'ownerId': ownerId});

    model = VenuePageModel(
      venueId: venueId,
      shouldOpenReviewsTab: false,
      shouldOpenImagesTab: false,
      venuesApi: FakeVenuesApi(),
      reservationsApi: FakeReservationsApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final headerImage = find.byKey(const Key('headerImage'));
    final editVenueDetailsButton = find.byKey(
      const Key('editVenueDetailsButton'),
    );
    final tabBar = find.byKey(const Key('tabBar'));
    final venueDetailsTab = find.byKey(const Key('venueDetailsTab'));
    final reviewsTab = find.byKey(const Key('reviewsTab'));
    final imagesTab = find.byKey(const Key('imagesTab'));
    final maxCapacityIcon = find.byKey(const Key('maxCapacityIcon'));
    final availableCapacityIcon = find.byKey(
      const Key('availableCapacityIcon'),
    );
    final lifetimeReservationsIcon = find.byKey(
      const Key('lifetimeReservationsIcon'),
    );
    final addVenueImagesButton = find.byKey(const Key('addVenueImagesButton'));
    final addMenuImagesButton = find.byKey(const Key('addMenuImagesButton'));
    final pageView = find.byKey(const Key('pageView'));
    final pageIndicator = find.byKey(const Key('pageIndicator'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebVenuePage(
              venueId: venueId,
              shouldReturnToHomepage: true,
              modelOverride: model,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(headerImage, findsOneWidget);
    expect(editVenueDetailsButton, findsOneWidget);
    expect(tabBar, findsOneWidget);
    expect(venueDetailsTab, findsOneWidget);
    expect(reviewsTab, findsOneWidget);
    expect(imagesTab, findsOneWidget);
    expect(find.text('Venue Type'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('This is a description'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Porec'), findsOneWidget);
    expect(find.text('Working Hours'), findsOneWidget);
    expect(find.text('08:00 - 17:00'), findsOneWidget);
    expect(find.text('Working Days'), findsOneWidget);
    expect(find.text('Monday, Tuesday, Wednesday, Thursday'), findsOneWidget);
    expect(find.text('Maximum Capacity'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Available Capacity'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('Lifetime Reservations'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(maxCapacityIcon, findsOneWidget);
    expect(availableCapacityIcon, findsOneWidget);
    expect(lifetimeReservationsIcon, findsOneWidget);

    await tester.tap(reviewsTab);
    await tester.pumpAndSettle();
    expect(find.text('Total number of reviews:'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Average Rating'), findsOneWidget);
    expect(find.text('3.5'), findsOneWidget);
    expect(find.text('username'), findsOneWidget);
    expect(find.text('comment'), findsOneWidget);
    expect(find.text('3.0'), findsOneWidget);

    await tester.tap(imagesTab);
    await tester.pumpAndSettle();

    expect(addVenueImagesButton, findsOneWidget);
    expect(addMenuImagesButton, findsOneWidget);
    expect(pageView, findsOneWidget);
    expect(pageIndicator, findsOneWidget);
    expect(find.text('Venue Images'), findsOneWidget);
    expect(find.text('No images uploaded yet.'), findsOneWidget);
  });
}

class FakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<Venue?> getVenue(int venueId) async {
    return Venue(
      id: 1,
      name: 'First venue',
      location: 'Porec',
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 17:00',
      maximumCapacity: 30,
      availableCapacity: 20,
      rating: 3.5,
      typeId: 1,
      description: 'This is a description',
    );
  }

  @override
  Future<String?> getVenueType(int typeId) async {
    return 'Restaurant';
  }

  @override
  Future<Uint8List?> getVenueHeaderImage(int venueId) async {
    return null;
  }

  @override
  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    return [
      Rating(id: 1, rating: 3.0, username: 'username', comment: 'comment'),
    ];
  }

  @override
  Future<List<Uint8List>> getVenueImages(int venueId) async {
    return [];
  }

  @override
  Future<List<Uint8List>> getMenuImages(int venueId) async {
    return [];
  }

  @override
  Future<BasicResponse> uploadVenueImage(
    int venueId,
    Uint8List imageBytes,
    String filename,
  ) async {
    return BasicResponse(success: true, message: 'Image uploaded');
  }

  @override
  Future<BasicResponse> uploadMenuImage(
    int venueId,
    Uint8List imageBytes,
    String filename,
  ) async {
    return BasicResponse(success: true, message: 'Image uploaded');
  }
}

class FakeReservationsApi extends Fake implements ReservationsApi {
  @override
  Future<int> getReservationCount(
    int ownerId, {
    int? venueId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return 1;
  }
}
