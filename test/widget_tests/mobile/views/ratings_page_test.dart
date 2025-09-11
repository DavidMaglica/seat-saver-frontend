import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/models/mobile/views/ratings_model.dart';
import 'package:seat_saver/pages/mobile/views/ratings_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late RatingsPageModel emptyModel;
  late RatingsPageModel model;

  const mockVenueId = 1;
  const mockUserId = 1;

  setUp(() {
    setupSharedPrefsMock(initialValues: {'userId': mockUserId});

    emptyModel = RatingsPageModel(
      venueId: mockVenueId,
      venuesApi: EmptyFakeVenuesApi(),
    );

    model = RatingsPageModel(venueId: mockVenueId, venuesApi: FakeVenuesApi());
  });

  testWidgets('should display widget correctly when no reviews', (
    tester,
  ) async {
    final numberOfRatingsText = find.byKey(const Key('numberOfRatingsText'));
    final averageRatingText = find.byKey(const Key('averageRatingText'));
    final averageRatingIcon = find.byKey(const Key('averageRatingIcon'));
    final ratingSummary = find.byKey(const Key('ratingSummary'));
    final ratingEntryContainer = find.byKey(const Key('ratingEntryContainer'));
    final leaveReviewButton = find.byKey(const Key('leaveReviewButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RatingsPage(venueId: mockVenueId, modelOverride: emptyModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(numberOfRatingsText, findsOneWidget);
    expect(averageRatingText, findsOneWidget);
    expect(averageRatingIcon, findsOneWidget);
    expect(ratingSummary, findsOneWidget);
    expect(ratingEntryContainer, findsNothing);
    expect(leaveReviewButton, findsOneWidget);
  });

  testWidgets('should display widget correctly when reviews present', (
    tester,
  ) async {
    final numberOfRatingsText = find.byKey(const Key('numberOfRatingsText'));
    final averageRatingText = find.byKey(const Key('averageRatingText'));
    final averageRatingIcon = find.byKey(const Key('averageRatingIcon'));
    final ratingSummary = find.byKey(const Key('ratingSummary'));
    final ratingEntryContainer = find.byKey(const Key('ratingEntryContainer'));
    final leaveReviewButton = find.byKey(const Key('leaveReviewButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RatingsPage(venueId: mockVenueId, modelOverride: model),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(numberOfRatingsText, findsOneWidget);
    expect(averageRatingText, findsOneWidget);
    expect(averageRatingIcon, findsOneWidget);
    expect(ratingSummary, findsOneWidget);
    expect(ratingEntryContainer, findsNWidgets(2));
    expect(leaveReviewButton, findsOneWidget);
  });

  testWidgets('should update reviews list when user leaves review', (
    tester,
  ) async {
    final ratingEntryContainer = find.byKey(const Key('ratingEntryContainer'));
    final leaveReviewButton = find.byKey(const Key('leaveReviewButton'));
    final ratingModal = find.byKey(const Key('ratingModal'));
    final ratingStar = find.byKey(const Key('ratingStar_4'));
    final commentField = find.byKey(const Key('commentField'));
    final submitReviewButton = find.byKey(const Key('rateModalButton'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RatingsPage(
            userId: mockUserId,
            venueId: mockVenueId,
            modelOverride: model,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ratingEntryContainer, findsNWidgets(2));

    await tester.tap(leaveReviewButton);
    await tester.pumpAndSettle();

    expect(ratingModal, findsOneWidget);

    await tester.tap(ratingStar);
    await tester.enterText(commentField, 'Great place!');
    await tester.pumpAndSettle();

    await tester.tap(submitReviewButton);
    await tester.pumpAndSettle();

    expect(ratingModal, findsNothing);
    expect(ratingEntryContainer, findsNWidgets(3));
  });
}

class EmptyFakeVenuesApi extends Fake implements VenuesApi {
  @override
  Future<Venue?> getVenue(int venueId) async {
    return null;
  }

  @override
  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    return [];
  }

  @override
  Future<double?> getVenueRating(int venueId) async {
    return 3.5;
  }

  @override
  Future<BasicResponse> rateVenue(
    int venueId,
    double rating,
    int userId,
    String comment,
  ) async {
    return BasicResponse(success: true, message: 'Rated successfully.');
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final List<Rating> _ratings = [
    Rating(id: 1, rating: 3.0, username: 'mockUser', comment: 'Nice'),
    Rating(id: 2, rating: 4.0, username: 'mockUser2', comment: 'Good'),
  ];

  @override
  Future<Venue?> getVenue(int venueId) async {
    return Venue(
      id: 1,
      name: 'First Venue',
      location: 'Porec',
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 17:00',
      maximumCapacity: 20,
      availableCapacity: 20,
      rating: 3.5,
      typeId: 1,
    );
  }

  @override
  Future<List<Rating>> getAllVenueRatings(int venueId) async {
    return List.unmodifiable(_ratings);
  }

  @override
  Future<double?> getVenueRating(int venueId) async {
    if (_ratings.isEmpty) return null;
    final sum = _ratings.fold<double>(0, (s, rating) => s + rating.rating);
    return sum / _ratings.length;
  }

  @override
  Future<BasicResponse> rateVenue(
    int venueId,
    double rating,
    int userId,
    String comment,
  ) async {
    _ratings.add(
      Rating(
        id: _ratings.length + 1,
        rating: rating,
        username: 'testUser$userId',
        comment: comment,
      ),
    );
    return BasicResponse(success: true, message: 'Rated successfully.');
  }
}
