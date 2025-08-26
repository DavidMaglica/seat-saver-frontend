import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show ScaffoldState, ScaffoldMessenger, Colors, Theme, showModalBottomSheet;
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/common/google_api.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_location.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/geolocation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/mobile/location_permission.dart';
import 'package:table_reserver/pages/mobile/views/venues_by_type.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';

class HomepageModel extends ChangeNotifier {
  final BuildContext context;
  final int? userId;
  Position? userLocation;

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

  final AccountApi accountApi = AccountApi();
  final GeolocationApi geolocationApi = GeolocationApi();
  final VenuesApi venuesApi = VenuesApi();
  final GoogleApi googleApi = GoogleApi();

  HomepageModel({required this.context, this.userId, this.userLocation});

  Future<void> init() async {
    await checkLogIn();

    if (locationPopUpCounter < 1) {
      await displayLocationPermissionPopUp();
    }

    if (userId != null) {
      NotificationOptions? options = await accountApi.getNotificationOptions(
        userId!,
      );
      if (options != null && options.isLocationServicesEnabled) {
        userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  Future<void> displayLocationPermissionPopUp() async {
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
        _openPopUp(userId!);
      } else {
        if (userLocation == null) {
          _openPopUp(userId!);
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

  void openNearbyVenues() {
    Navigator.of(context).push(
      FadeInRoute(
        page: VenuesByType(
          userId: userId,
          userLocation: userLocation ?? currentUserLocation,
          type: 'nearby',
        ),
        routeName: Routes.venuesByType,
      ),
    );
    notifyListeners();
    return;
  }

  void openNewVenues() {
    Navigator.of(context).push(
      FadeInRoute(
        page: VenuesByType(
          userId: userId,
          userLocation: userLocation ?? currentUserLocation,
          type: 'new',
        ),
        routeName: Routes.venuesByType,
      ),
    );
    notifyListeners();
    return;
  }

  void openTrendingVenues() {
    Navigator.of(context).push(
      FadeInRoute(
        page: VenuesByType(
          userId: userId,
          userLocation: userLocation ?? currentUserLocation,
          type: 'trending',
        ),
        routeName: Routes.venuesByType,
      ),
    );
    notifyListeners();
    return;
  }

  void openSuggestedVenues() {
    Navigator.of(context).push(
      FadeInRoute(
        page: VenuesByType(
          userId: userId,
          userLocation: userLocation ?? currentUserLocation,
          type: 'suggested',
        ),
        routeName: Routes.venuesByType,
      ),
    );
    notifyListeners();
    return;
  }

  void _openPopUp(int userId) {
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
