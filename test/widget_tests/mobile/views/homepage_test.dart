import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_location.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/geolocation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/models/mobile/views/homepage_model.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';

import '../../../test_utils/shared_preferences_mock.dart';

void main() {
  late HomepageModel model;
  late HomepageModel nullUserModel;

  const userId = 1;

  setUp(() {
    setupSharedPrefsMock();

    model = HomepageModel(
      userId: 1,
      accountApi: FakeAccountApi(),
      geolocationApi: FakeGeoLocationApi(),
      venuesApi: FakeVenuesApi(),
    );

    nullUserModel = HomepageModel(
      userId: 1,
      accountApi: NullUserAccountApi(),
      geolocationApi: FakeGeoLocationApi(),
      venuesApi: FakeVenuesApi(),
    );

    GeolocatorPlatform.instance = FakeGeolocatorPlatform(
      lat: 45.23,
      lng: 13.61,
    );
  });

  testWidgets('should display widget correctly without user', (tester) async {
    final welcomeText = find.byKey(const Key('welcomeText'));
    final carouselSlider = find.byKey(const Key('carouselSlider'));
    final carouselItem = find.byKey(const Key('carouselItem_1'));
    final nearbyVenuesTitle = find.text('Nearby Venues');
    final newVenuesTitle = find.text('New Venues');
    final trendingVenuesTitle = find.text('Trending Venues');
    final suggestedVenuesTitle = find.text('We suggest');
    final seeAllButton = find.byKey(const Key('seeAllButton'));
    final venueCardsScrollView = find.byKey(const Key('venueCardsScrollView'));
    final venueSuggestedCardsScrollView = find.byKey(
      const Key('venueSuggestedCardsScrollView'),
    );
    final venueCard = find.byKey(const Key('venueCard'));
    final venueSuggestedCard = find.byKey(const Key('venueSuggestedCard'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Homepage(userId: null, modelOverride: nullUserModel),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(welcomeText, findsOneWidget);
    expect(carouselSlider, findsNothing);
    expect(carouselItem, findsNothing);
    expect(nearbyVenuesTitle, findsOneWidget);
    expect(newVenuesTitle, findsOneWidget);
    expect(trendingVenuesTitle, findsOneWidget);
    expect(suggestedVenuesTitle, findsOneWidget);
    expect(seeAllButton, findsNWidgets(4));
    expect(venueCardsScrollView, findsNWidgets(3));
    expect(venueSuggestedCardsScrollView, findsOneWidget);
    expect(venueCard, findsNWidgets(9));
    expect(venueSuggestedCard, findsNWidgets(3));
  });

  testWidgets('should display widget correctly with user', (tester) async {
    setupSharedPrefsMock(initialValues: {'userId': userId});
    final welcomeText = find.byKey(const Key('welcomeText'));
    final welcomeUserText = find.text('Welcome back, username!');
    final carouselSlider = find.byKey(const Key('carouselSlider'));
    final carouselItem = find.byKey(const Key('carouselItem'));
    final nearbyVenuesTitle = find.text('Nearby Venues');
    final newVenuesTitle = find.text('New Venues');
    final trendingVenuesTitle = find.text('Trending Venues');
    final suggestedVenuesTitle = find.text('We suggest');
    final seeAllButton = find.byKey(const Key('seeAllButton'));
    final venueCardsScrollView = find.byKey(const Key('venueCardsScrollView'));
    final venueSuggestedCardsScrollView = find.byKey(
      const Key('venueSuggestedCardsScrollView'),
    );
    final venueCard = find.byKey(const Key('venueCard'));
    final venueSuggestedCard = find.byKey(const Key('venueSuggestedCard'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Homepage(userId: userId, modelOverride: model),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(welcomeText, findsOneWidget);
    expect(welcomeUserText, findsOneWidget);
    expect(carouselSlider, findsOneWidget);
    expect(carouselItem, findsNWidgets(3));
    expect(nearbyVenuesTitle, findsOneWidget);
    expect(newVenuesTitle, findsOneWidget);
    expect(trendingVenuesTitle, findsOneWidget);
    expect(suggestedVenuesTitle, findsOneWidget);
    expect(seeAllButton, findsNWidgets(4));
    expect(venueCardsScrollView, findsNWidgets(3));
    expect(venueSuggestedCardsScrollView, findsOneWidget);
    expect(venueCard, findsNWidgets(9));
    expect(venueSuggestedCard, findsNWidgets(3));
  });

  // Other tests are omitted because of widget tests limitations (multiple Row/Flexible/Column in a SingleChildScrollView)
}

class FakeAccountApi extends Fake implements AccountApi {
  final NotificationOptions notificationOptions = NotificationOptions(
    isPushNotificationsEnabled: true,
    isEmailNotificationsEnabled: true,
    isLocationServicesEnabled: true,
  );

  static const latitude = 45.23;
  static const longitude = 13.61;

  @override
  Future<UserResponse?> getUser(int userId) async {
    return UserResponse(
      success: true,
      message: 'User found',
      user: User(
        id: 1,
        username: 'username',
        email: 'test@mail.com',
        notificationOptions: notificationOptions,
        lastKnownLatitude: latitude,
        lastKnownLongitude: longitude,
      ),
    );
  }

  @override
  Future<NotificationOptions?> getNotificationOptions(int userId) async {
    return notificationOptions;
  }

  @override
  Future<BasicResponse> updateUserLocation(
    int userId,
    Position position,
  ) async {
    return BasicResponse(success: true, message: 'User location updated');
  }
}

class NullUserAccountApi extends Fake implements AccountApi {
  @override
  Future<UserResponse?> getUser(int userId) async {
    return UserResponse(success: false, message: 'User not found', user: null);
  }

  @override
  Future<NotificationOptions?> getNotificationOptions(int userId) async {
    return null;
  }

  @override
  Future<BasicResponse> updateUserLocation(
    int userId,
    Position position,
  ) async {
    return BasicResponse(success: true, message: 'User location updated');
  }
}

class FakeGeoLocationApi extends Fake implements GeolocationApi {
  @override
  Future<List<String>> getNearbyCities(UserLocation userLocation) async {
    return ['Porec', 'Rovinj', 'Pula'];
  }
}

class FakeVenuesApi extends Fake implements VenuesApi {
  final List<Venue> venues = [
    Venue(
      id: 1,
      name: 'First venue',
      location: 'Porec',
      description: 'This is a description of the first venue.',
      rating: 4.5,
      maximumCapacity: 20,
      availableCapacity: 20,
      workingDays: [0, 1, 2, 3, 4],
      workingHours: '08:00 - 17:00',
      typeId: 1,
    ),
    Venue(
      id: 2,
      name: 'Second venue',
      location: 'Rovinj',
      description: 'This is a description of the second venue.',
      rating: 4.0,
      maximumCapacity: 30,
      availableCapacity: 15,
      workingDays: [1, 2, 3, 4, 5],
      workingHours: '10:00 - 20:00',
      typeId: 2,
    ),
    Venue(
      id: 3,
      name: 'Third venue',
      location: 'Pula',
      description: 'This is a description of the third venue.',
      rating: 3.5,
      maximumCapacity: 25,
      availableCapacity: 5,
      workingDays: [0, 2, 4, 6],
      workingHours: '09:00 - 18:00',
      typeId: 1,
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
      size: 3,
      totalElements: 3,
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
      size: 3,
      totalElements: 3,
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
      size: 3,
      totalElements: 3,
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
      size: 3,
      totalElements: 3,
      totalPages: 1,
    );
  }
}

class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform({this.lat = 45.23, this.lng = 13.61});

  final double lat;
  final double lng;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    return Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 5,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }
}
