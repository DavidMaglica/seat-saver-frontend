import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../api/data/notification_settings.dart';
import '../api/data/user.dart';
import '../api/data/user_location.dart';
import '../api/data/user_response.dart';
import '../api/data/venue.dart';
import '../api/geolocation_api.dart';
import '../api/venue_api.dart';
import '../components/location_permission.dart';
import '../components/toaster.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class HomepageModel extends ChangeNotifier {
  final BuildContext context;
  final String? userEmail;
  final Position? userLocation;

  final unfocusNode = FocusNode();

  final int pageIndex = 0;
  int locationPopUpCounter = 0;
  List<Venue>? nearbyVenues;
  List<Venue>? newVenues;
  List<Venue>? trendingVenues;
  List<Venue>? suggestedVenues;
  CarouselController? carouselController;
  int carouselCurrentIndex = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String>? nearbyCities;
  Position? currentUserLocation;
  User? loggedInUser;

  AccountApi accountApi = AccountApi();
  GeolocationApi geolocationApi = GeolocationApi();
  VenueApi venueApi = VenueApi();

  Map<int, String> venueTypeMap = {};

  HomepageModel({
    required this.context,
    this.userEmail,
    this.userLocation,
  });

  Future<void> init() async {
    await loadVenueTypes();

    await checkLogIn();

    if (locationPopUpCounter < 1) {
      await displayLocationPermissionPopUp(locationPopUpCounter);
    }

    if (userEmail != null && userEmail?.isNotEmpty == true) {
      await updateUserLocation(userEmail!);
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

  Future<void> loadVenueTypes() async {
    final venueTypes = await venueApi.getAllVenueTypes();

    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
    notifyListeners();
  }

  Future<void> resolveNearbyCities() async {
    if (userLocation != null) {
      await geolocationApi.getNearbyCities(
        UserLocation(
            latitude: userLocation!.latitude,
            longitude: userLocation!.longitude),
      );
    } else {
      if (loggedInUser != null &&
          loggedInUser?.notificationOptions.locationServicesTurnedOn == true) {
        currentUserLocation = loggedInUser!.lastKnownLocation;
        await geolocationApi.getNearbyCities(
          UserLocation(
              latitude: currentUserLocation!.latitude,
              longitude: currentUserLocation!.longitude),
        );
      }
    }
    notifyListeners();
  }

  Future<void> displayLocationPermissionPopUp(int locationPopUpCounter) async {
    if (userEmail != null && userEmail!.isNotEmpty) {
      locationPopUpCounter++;
      bool? isLocationServicesTurnedOn;
      await accountApi.getNotificationOptions(userEmail!).then((value) =>
          isLocationServicesTurnedOn = value.locationServicesTurnedOn);
      if (isLocationServicesTurnedOn != null &&
          isLocationServicesTurnedOn == false) {
        _openPopUp(userEmail!);
      } else {
        if (userLocation == null) {
          _openPopUp(userEmail!);
        }
        await accountApi.getLastKnownLocation(userEmail!).then((value) => {
              geolocationApi
                  .getNearbyCities(value)
                  .then((cities) => {nearbyCities = cities}),
            });
      }
    }
    notifyListeners();
  }

  Future<void> updateUserLocation(String userEmail) async {
    NotificationOptions options =
        await accountApi.getNotificationOptions(userEmail);
    if (options.locationServicesTurnedOn) {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      accountApi.updateUserLocation(userEmail, userLocation);
    }
    notifyListeners();
  }

  Future<void> checkLogIn() async {
    if (userEmail.isNotNullAndNotEmpty) {
      UserResponse? user = await accountApi.getUser(userEmail!);
      if (user != null && user.success) {
        loggedInUser = user.user;
      }
    }
    notifyListeners();
  }

  Future<void> getNearbyVenues() async {
    List<Venue> venues = await venueApi.getNearbyVenues();
    nearbyVenues = venues;
    notifyListeners();
  }

  Future<void> getNewVenues() async {
    List<Venue> venues = await venueApi.getNewVenues();
    newVenues = venues;
    notifyListeners();
  }

  Future<void> getTrendingVenues() async {
    List<Venue> venues = await venueApi.getTrendingVenues();
    trendingVenues = venues;
    notifyListeners();
  }

  Future<void> getSuggestedVenues() async {
    List<Venue> venues = await venueApi.getSuggestedVenues();
    suggestedVenues = venues;
    notifyListeners();
  }

  void openNearbyVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    notifyListeners();
    return;
  }

  void openNewVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    notifyListeners();
    return;
  }

  void openTrendingVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    notifyListeners();
    return;
  }

  void _openPopUp(String userEmail) {
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
                      child: LocationPermissionPopUp(userEmail: userEmail),
                    )));
          });
    });
    notifyListeners();
  }

  Future<void> searchByVenueType(int venueTypeId) =>
      Navigator.pushNamed(context, Routes.search, arguments: {
        'userEmail': userEmail,
        'userLocation': userLocation,
        'selectedVenueType': venueTypeId,
      });
}
