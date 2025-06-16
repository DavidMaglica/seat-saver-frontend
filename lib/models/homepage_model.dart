import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/api/data/notification_settings.dart';
import 'package:TableReserver/api/data/user_location.dart';
import 'package:TableReserver/api/data/user_response.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/api/geolocation_api.dart';
import 'package:TableReserver/api/venue_api.dart';
import 'package:TableReserver/components/location_permission.dart';
import 'package:TableReserver/components/toaster.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';

class HomepageModel extends ChangeNotifier {
  final BuildContext context;
  final int? userId;
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

  HomepageModel({
    required this.context,
    this.userId,
    this.userLocation,
  });

  Future<void> init() async {
    await checkLogIn();

    if (locationPopUpCounter < 1) {
      await displayLocationPermissionPopUp(locationPopUpCounter);
    }

    if (userId != null) {
      await updateUserLocation(userId!);
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
      await geolocationApi.getNearbyCities(
        UserLocation(
            latitude: userLocation!.latitude,
            longitude: userLocation!.longitude),
      );
    } else {
      if (isUserLocationAvailableAndEnabled()) {
        currentUserLocation = getPositionFromLatAndLong(
          loggedInUser!.lastKnownLatitude!,
          loggedInUser!.lastKnownLongitude!,
        );
        await geolocationApi.getNearbyCities(
          UserLocation(
              latitude: currentUserLocation!.latitude,
              longitude: currentUserLocation!.longitude),
        );
      }
    }
    notifyListeners();
  }

  bool isUserLocationAvailableAndEnabled() {
    return loggedInUser != null &&
        loggedInUser!.lastKnownLatitude != null &&
        loggedInUser!.lastKnownLongitude != null &&
        loggedInUser?.notificationOptions.locationServicesTurnedOn == true;
  }

  Future<void> displayLocationPermissionPopUp(int locationPopUpCounter) async {
    if (userId != null) {
      locationPopUpCounter++;
      bool? isLocationServicesTurnedOn;
      await accountApi.getNotificationOptions(userId!).then((value) {
        if (value != null) {
          isLocationServicesTurnedOn = value.locationServicesTurnedOn;
        } else {
          Toaster.displayError(context,
              'There was an error while fetching your notification options. Please try again later.');
        }
      });
      if (isLocationServicesTurnedOn != null &&
          isLocationServicesTurnedOn == false) {
        _openPopUp(userId!);
      } else {
        if (userLocation == null) {
          _openPopUp(userId!);
        }
        await accountApi.getLastKnownLocation(userId!).then((value) {
          if (value != null) {
            geolocationApi
                .getNearbyCities(value)
                .then((cities) => {nearbyCities = cities});
          } else {
            Toaster.displayError(
              context,
              'There was an error while fetching your location. Please try again later.',
            );
          }
        });
      }
    }
    notifyListeners();
  }

  Future<void> updateUserLocation(int userId) async {
    NotificationOptions? options =
        await accountApi.getNotificationOptions(userId);

    if (options != null && options.locationServicesTurnedOn) {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      accountApi.updateUserLocation(userId, userLocation);
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context,
          'Error getting notification options. Please try again later.');
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
    nearbyVenues = await venueApi.getNearbyVenues();
    notifyListeners();
  }

  Future<void> getNewVenues() async {
    newVenues = await venueApi.getNewVenues();
    notifyListeners();
  }

  Future<void> getTrendingVenues() async {
    trendingVenues = await venueApi.getTrendingVenues();
    notifyListeners();
  }

  Future<void> getSuggestedVenues() async {
    suggestedVenues = await venueApi.getSuggestedVenues();
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
                    )));
          });
    });
    notifyListeners();
  }
}
