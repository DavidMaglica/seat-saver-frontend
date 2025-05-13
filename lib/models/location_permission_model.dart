import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../api/data/notification_settings.dart';
import '../utils/constants.dart';

class LocationPermissionPopUpModel extends ChangeNotifier {
  final BuildContext context;
  final String userEmail;
  final AccountApi _accountApi = AccountApi();

  NotificationOptions? notificationOptions;

  LocationPermissionPopUpModel(this.context, this.userEmail) {
    init();
  }

  void init() async {
    notificationOptions = await _accountApi.getNotificationOptions(userEmail);
    notifyListeners();
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission locationPermission;

    if (!await Geolocator.isLocationServiceEnabled()) return false;

    locationPermission = await Geolocator.checkPermission();

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if (await Geolocator.requestPermission() == LocationPermission.denied) {
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) return false;

    _accountApi.updateUserNotificationOptions(
      userEmail,
      notificationOptions!.pushNotificationsTurnedOn,
      notificationOptions!.emailNotificationsTurnedOn,
      true,
    );

    return true;
  }

  Future<String?> _getCity(Position? position) async {
    String? currentCity;
    await placemarkFromCoordinates(position!.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      currentCity = placemarks[0].locality;
    }).catchError((e) {
      debugPrint(e.toString());
    });

    return currentCity;
  }

  Future<void> getCurrentPosition() async {
    if (!await _handleLocationPermission()) return;

    Position? userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    String? currentCity = await _getCity(userLocation);
    if (currentCity == null || currentCity.isEmpty) {
      if (!context.mounted) return;
      showToast('Failed to get current location',
          context: context,
          animation: StyledToastAnimation.scale,
          position: StyledToastPosition.center,
          duration: const Duration(seconds: 4));
    }

    _accountApi.updateUserLocation(userEmail, userLocation);

    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, Routes.HOMEPAGE, arguments: {
      'userEmail': userEmail,
      'userLocation': userLocation,
    });
  }
}
