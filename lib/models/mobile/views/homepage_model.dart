import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show ScaffoldState, Colors, Theme, showModalBottomSheet;
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/common/google_api.dart';
import 'package:seat_saver/api/data/notification_settings.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/user_location.dart';
import 'package:seat_saver/api/data/user_response.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/geolocation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/components/mobile/location_permission.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/mobile/views/venues_by_type.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/logger.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/utils.dart';

class HomepageModel extends ChangeNotifier {
  final int? userId;
  Position? userLocation;

  final AccountApi accountApi;
  final GeolocationApi geolocationApi;
  final VenuesApi venuesApi;
  final GoogleApi googleApi = GoogleApi();

  HomepageModel({
    this.userId,
    this.userLocation,
    AccountApi? accountApi,
    GeolocationApi? geolocationApi,
    VenuesApi? venuesApi,
    GoogleApi? googleApi,
  }) : accountApi = accountApi ?? AccountApi(),
       geolocationApi = geolocationApi ?? GeolocationApi(),
       venuesApi = venuesApi ?? VenuesApi();

  final unfocusNode = FocusNode();

  final int pageIndex = 0;
  int locationPopUpCounter = 0;
  List<Venue>? nearbyVenues;
  List<Venue>? newVenues;
  List<Venue>? trendingVenues;
  List<Venue>? suggestedVenues;
  CarouselController carouselController = CarouselController();
  int carouselCurrentIndex = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> nearbyCities = [];
  Map<String, String> cityImages = {};
  Position? currentUserLocation;
  User? loggedInUser;

  Future<void> init(BuildContext context) async {
    await checkLogIn();

    if (locationPopUpCounter < 1) {
      await displayLocationPermissionPopUp(context);
    }

    if (userId != null) {
      NotificationOptions? options = await accountApi.getNotificationOptions(
        userId!,
      );
      if (options != null && options.isLocationServicesEnabled) {
        const bool useFakePermissions = bool.fromEnvironment(
            'FAKE_PERMISSIONS');
        if (useFakePermissions) {
          userLocation = await getTestPosition();
        } else {
          userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );
        }
        if (userLocation != null) {
          await sharedPreferencesCache.setString(
            'lastKnownLocation',
            jsonEncode({
              'lat': userLocation!.latitude,
              'lng': userLocation!.longitude,
            }),
          );
        }
        accountApi.updateUserLocation(userId!, userLocation!);
      }
    }

    await resolveNearbyCities();

    await getNearbyVenues();
    await getNewVenues();
    await getTrendingVenues();
    await getSuggestedVenues();
    notifyListeners();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> resolveNearbyCities() async {
    if (userLocation != null) {
      if (nearbyCities.isEmpty) {
        nearbyCities = await geolocationApi.getNearbyCities(
          UserLocation(
            latitude: userLocation!.latitude,
            longitude: userLocation!.longitude,
          ),
        );
      }
    } else {
      if (isUserLocationAvailableAndEnabled()) {
        currentUserLocation = getPositionFromLatAndLong(
          loggedInUser!.lastKnownLatitude!,
          loggedInUser!.lastKnownLongitude!,
        );
        if (nearbyCities.isEmpty) {
          nearbyCities = await geolocationApi.getNearbyCities(
            UserLocation(
              latitude: currentUserLocation!.latitude,
              longitude: currentUserLocation!.longitude,
            ),
          );
        }
      }
    }
    notifyListeners();
  }

  bool isUserLocationAvailableAndEnabled() {
    return loggedInUser != null &&
        loggedInUser!.lastKnownLatitude != null &&
        loggedInUser!.lastKnownLongitude != null &&
        loggedInUser!.notificationOptions!.isLocationServicesEnabled == true;
  }

  Future<void> displayLocationPermissionPopUp(BuildContext context) async {
    if (userId != null) {
      locationPopUpCounter++;
      bool isLocationServicesTurnedOn = false;
      NotificationOptions? notificationOptions = await accountApi
          .getNotificationOptions(userId!);

      if (notificationOptions != null) {
        isLocationServicesTurnedOn =
            notificationOptions.isLocationServicesEnabled;
      }

      if (!isLocationServicesTurnedOn) {
        _openPopUp(context, userId!);
      } else {
        if (userLocation == null) {
          _openPopUp(context, userId!);
        }
      }
    }
    notifyListeners();
  }

  Future<void> checkLogIn() async {
    if (userId != null) {
      UserResponse? user = await accountApi.getUser(userId!);
      if (user != null && user.success) {
        loggedInUser = user.user;
      }
    }
    notifyListeners();
  }

  Future<void> getNearbyVenues() async {
    PagedResponse<Venue> pagedVenues = await venuesApi.getNearbyVenues(
      userLocation?.latitude,
      userLocation?.longitude,
    );
    nearbyVenues = pagedVenues.items;
    notifyListeners();
  }

  Future<void> getNewVenues() async {
    PagedResponse<Venue> pagedVenues = await venuesApi.getNewVenues();
    newVenues = pagedVenues.items;
    notifyListeners();
  }

  Future<void> getTrendingVenues() async {
    PagedResponse<Venue> pagedVenues = await venuesApi.getTrendingVenues();
    trendingVenues = pagedVenues.items;
    notifyListeners();
  }

  Future<void> getSuggestedVenues() async {
    PagedResponse<Venue> pagedVenues = await venuesApi.getSuggestedVenues();
    suggestedVenues = pagedVenues.items;
    notifyListeners();
  }

  void openNearbyVenues(BuildContext context) {
    logger.i('Opening nearby venues');
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: const VenuesByType(type: 'nearby'),
        routeName: Routes.venuesByType,
        arguments: {'type': 'nearby'},
      ),
    );
    notifyListeners();
    return;
  }

  void openNewVenues(BuildContext context) {
    logger.i('Opening nearby venues');
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: const VenuesByType(type: 'new'),
        routeName: Routes.venuesByType,
        arguments: {'type': 'new'},
      ),
    );
    notifyListeners();
    return;
  }

  void openTrendingVenues(BuildContext context) {
    logger.i('Opening nearby venues');
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: const VenuesByType(type: 'trending'),
        routeName: Routes.venuesByType,
        arguments: {'type': 'trending'},
      ),
    );
    notifyListeners();
    return;
  }

  void openSuggestedVenues(BuildContext context) {
    logger.i('Opening nearby venues');
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: const VenuesByType(type: 'suggested'),
        routeName: Routes.venuesByType,
        arguments: {'type': 'suggested'},
      ),
    );
    notifyListeners();
    return;
  }

  void _openPopUp(BuildContext context, int userId) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Theme.of(context).colorScheme.onSecondary,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: SizedBox(
                height: 568,
                child: LocationPermissionPopUp(userId: userId),
              ),
            ),
          );
        },
      );
    });
    notifyListeners();
  }

  Future<void> loadCarouselData(List<String> cities) async {
    List<Future<void>> cityFutures = cities.map((city) async {
      String? placeId = await googleApi.getPlaceId(city);
      String? photoReference = await googleApi.getPhotoReference(placeId);
      String? cityImage = await googleApi.getImage(photoReference);
      if (cityImage != null) {
        cityImages[city] = cityImage;
      }
    }).toList();

    await Future.wait(cityFutures);
    notifyListeners();
  }
}
