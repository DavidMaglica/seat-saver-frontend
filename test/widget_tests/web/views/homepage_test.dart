import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/web/components/side_nav_model.dart';
import 'package:table_reserver/models/web/views/homepage_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/pages/web/views/ratings_page.dart';
import 'package:table_reserver/pages/web/views/reservations_graphs_page.dart';

import '../../../test_utils/shared_preferences_mock.dart';
import '../../../test_utils/utils.dart';

void main() {
  late HomepageModel model;
  late HomepageModel emptyVenueHomepageModel;

  const ownerId = 1;

  setUp(() {
    setupSharedPrefsMock(
      initialValues: {
        'ownerId': ownerId,
        'ownerName': 'owner',
        'ownerEmail': 'owner@mail.com',
      },
    );

    model = HomepageModel(
      ownerId: ownerId,
      accountApi: FakeAccountApi(),
      reservationsApi: FakeReservationsApi(),
      venuesApi: FakeVenuesApi(),
    );
    emptyVenueHomepageModel = HomepageModel(
      ownerId: ownerId,
      accountApi: FakeAccountApi(),
      reservationsApi: FakeReservationsApi(),
      venuesApi: EmptyVenuesApi(),
    );
  });

  testWidgets('should display widget correctly', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final title = find.text('Overview');
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final last30DaysReservationsCard = find.text('Reservations last 30 days');
    final next30DaysReservationsCard = find.text('Reservations next 30 days');
    final totalReservationsCard = find.text('Total Reservations Received');
    final totalReviewsCard = find.text('Total Reviews Received');
    final overallRatingCard = find.text(
      'Your average rating across all venues.',
    );
    final overallUtilisationRateCard = find.text('How Busy You Are');
    final createVenueButton = find.byKey(const Key('createVenueButton'));
    final venuesTable = find.byKey(const Key('venuesTable'));
    final editVenueButton = find.byKey(const Key('editVenueButton'));
    final deleteVenueButton = find.byKey(const Key('deleteVenueButton'));
    final bestPerformingVenueCard = find.byKey(
      const Key('bestPerformingVenueCard'),
    );
    final worstPerformingVenueCard = find.byKey(
      const Key('worstPerformingVenueCard'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebHomepage(ownerId: ownerId, modelOverride: model),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(title, findsOneWidget);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(last30DaysReservationsCard, findsOneWidget);
    expect(next30DaysReservationsCard, findsOneWidget);
    expect(totalReservationsCard, findsOneWidget);
    expect(totalReviewsCard, findsOneWidget);
    expect(overallRatingCard, findsOneWidget);
    expect(find.text('3.50'), findsOneWidget);
    expect(overallUtilisationRateCard, findsOneWidget);
    expect(find.text('50.0%'), findsOneWidget);
    expect(createVenueButton, findsOneWidget);
    expect(venuesTable, findsOneWidget);
    expect(editVenueButton, findsNWidgets(3));
    expect(deleteVenueButton, findsNWidgets(3));
    expect(bestPerformingVenueCard, findsOneWidget);
    expect(worstPerformingVenueCard, findsOneWidget);
  });

  testWidgets('should display widget correctly when empty venues', (
    tester,
  ) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final title = find.text('Overview');
    final timerDropdown = find.byKey(const Key('timerDropdown'));
    final refreshButton = find.byKey(const Key('refreshButton'));
    final last30DaysReservationsCard = find.text('Reservations last 30 days');
    final next30DaysReservationsCard = find.text('Reservations next 30 days');
    final totalReservationsCard = find.text('Total Reservations Received');
    final totalReviewsCard = find.text('Total Reviews Received');
    final overallRatingCard = find.text(
      'Your average rating across all venues.',
    );
    final overallUtilisationRateCard = find.text('How Busy You Are');
    final createVenueButton = find.byKey(const Key('createVenueButton'));
    final venuesTable = find.byKey(const Key('venuesTable'));
    final editVenueButton = find.byKey(const Key('editVenueButton'));
    final deleteVenueButton = find.byKey(const Key('deleteVenueButton'));
    final bestPerformingVenueCard = find.byKey(
      const Key('bestPerformingVenueCard'),
    );
    final worstPerformingVenueCard = find.byKey(
      const Key('worstPerformingVenueCard'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebHomepage(
              ownerId: ownerId,
              modelOverride: emptyVenueHomepageModel,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(title, findsOneWidget);
    expect(timerDropdown, findsOneWidget);
    expect(refreshButton, findsOneWidget);
    expect(last30DaysReservationsCard, findsOneWidget);
    expect(next30DaysReservationsCard, findsOneWidget);
    expect(totalReservationsCard, findsOneWidget);
    expect(totalReviewsCard, findsOneWidget);
    expect(overallRatingCard, findsOneWidget);
    expect(find.text('0.00'), findsOneWidget);
    expect(overallUtilisationRateCard, findsOneWidget);
    expect(find.text('0.0%'), findsOneWidget);
    expect(createVenueButton, findsOneWidget);
    expect(venuesTable, findsNothing);
    expect(editVenueButton, findsNothing);
    expect(deleteVenueButton, findsNothing);
    expect(
      find.text('You haven\'t registered any venues yet.'),
      findsOneWidget,
    );
    expect(bestPerformingVenueCard, findsOneWidget);
    expect(worstPerformingVenueCard, findsOneWidget);
  });

  testWidgets('should navigate to ratings page', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final ratingCardButton = find.byKey(const Key('ratingCardButton'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebHomepage(ownerId: ownerId, modelOverride: model),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ratingCardButton, findsOneWidget);

    await tester.tap(ratingCardButton);
    await tester.pumpAndSettle();

    expect(find.byType(WebRatingsPage), findsOneWidget);
  });

  testWidgets('should navigate to reservations graphs page', (tester) async {
    ignoreOverflowErrors();
    maximizeTestWindow(tester);

    final utilisationCardButton = find.byKey(
      const Key('utilisationCardButton'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SideNavModel())],
        child: MaterialApp(
          home: Scaffold(
            body: WebHomepage(ownerId: ownerId, modelOverride: model),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(utilisationCardButton, findsOneWidget);

    await tester.tap(utilisationCardButton);
    await tester.pumpAndSettle();

    expect(find.byType(ReservationsGraphsPage), findsOneWidget);
  });
}

class FakeAccountApi extends Fake implements AccountApi {
  @override
  Future<UserResponse?> getUser(int userId) async {
    return UserResponse(
      success: true,
      message: 'User found',
      user: User(id: 1, username: 'testUser', email: 'test@mail.com'),
    );
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
    return 5;
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final List<Venue> _venues = [
    Venue(
      id: 1,
      name: 'Venue 1',
      location: 'Porec',
      maximumCapacity: 30,
      availableCapacity: 15,
      rating: 4.5,
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 17:00',
      typeId: 1,
    ),
    Venue(
      id: 2,
      name: 'Venue 2',
      location: 'Rovinj',
      maximumCapacity: 20,
      availableCapacity: 10,
      rating: 4.0,
      workingDays: [0, 1, 2, 3],
      workingHours: '08:00 - 20:00',
      typeId: 1,
    ),
  ];

  @override
  Future<PagedResponse<Venue>> getVenuesByOwner(
    int ownerId, {
    int page = 0,
    int size = 20,
  }) async {
    _venues.add(
      Venue(
        id: _venues.length + 1,
        name: 'Venue ${_venues.length + 1}',
        location: 'Pula',
        maximumCapacity: 20,
        availableCapacity: 20,
        rating: 3.0,
        workingDays: [0, 1, 2, 3],
        workingHours: '08:00 - 22:00',
        typeId: 1,
      ),
    );
    return PagedResponse<Venue>(
      content: _venues,
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
    );
  }

  @override
  Future<int> getVenueRatingsCount(int ownerId) async {
    return 1;
  }

  @override
  Future<double> getOverallRating(int ownerId) async {
    return 3.5;
  }

  @override
  Future<double> getVenueUtilisationRate(int ownerId) async {
    return 50.0;
  }

  @override
  Future<Uint8List?> getVenueHeaderImage(int venueId) async {
    return null;
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

  @override
  Future<int> getVenueRatingsCount(int ownerId) async {
    return 0;
  }

  @override
  Future<double> getOverallRating(int ownerId) async {
    return 0.0;
  }

  @override
  Future<double> getVenueUtilisationRate(int ownerId) async {
    return 0.0;
  }

  @override
  Future<Uint8List?> getVenueHeaderImage(int venueId) async {
    return null;
  }
}
