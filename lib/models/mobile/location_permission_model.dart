import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/notification_settings.dart';
import 'package:TableReserver/components/mobile/toaster.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionPopUpModel extends ChangeNotifier {
  final BuildContext context;
  final int userId;
  final AccountApi _accountApi = AccountApi();

  NotificationOptions? notificationOptions;

  LocationPermissionPopUpModel(this.context, this.userId) {
    init();
  }

  void init() async {
    notificationOptions = await _accountApi.getNotificationOptions(userId);
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

    BasicResponse basicResponse =
        await _accountApi.updateUserNotificationOptions(
            userId,
            notificationOptions!.pushNotificationsTurnedOn,
            notificationOptions!.emailNotificationsTurnedOn,
            true);

    if (!basicResponse.success) {
      if (!context.mounted) return false;
      Toaster.displayError(context, basicResponse.message);
    }

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

    _accountApi.updateUserLocation(userId, userLocation);

    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, Routes.homepage, arguments: {
      'userId': userId,
      'userLocation': userLocation,
    });
  }
}
