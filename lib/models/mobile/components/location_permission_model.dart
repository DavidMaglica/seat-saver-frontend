import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/notification_settings.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/toaster.dart';
import 'package:seat_saver/utils/utils.dart';

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
    const bool useFakePermissions = bool.fromEnvironment('FAKE_PERMISSIONS');
    if (useFakePermissions) {
      await _updateNotificationOptions();
    }

    LocationPermission locationPermission;

    if (!await Geolocator.isLocationServiceEnabled()) return false;

    locationPermission = await Geolocator.checkPermission();

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if (await Geolocator.requestPermission() == LocationPermission.denied) {
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) return false;

    return await _updateNotificationOptions();
  }

  Future<bool> _updateNotificationOptions() async {
    final basicResponse = await _accountApi.updateUserNotificationOptions(
      userId,
      notificationOptions!.isPushNotificationsEnabled,
      notificationOptions!.isEmailNotificationsEnabled,
      true,
    );

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
        })
        .catchError((e) {
          debugPrint(e.toString());
        });

    return currentCity;
  }

  Future<void> getCurrentPosition() async {
    const bool useFakePermissions = bool.fromEnvironment('FAKE_PERMISSIONS');
    if (!await _handleLocationPermission()) return;

    Position userLocation;
    if (useFakePermissions) {
      userLocation = await getTestPosition();
    } else {
      userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    }

    String? currentCity = await _getCity(userLocation);
    if (currentCity == null || currentCity.isEmpty) {
      if (!context.mounted) return;
      Toaster.displayError(
        context,
        'Failed to get current city. Please try again later.',
      );
    }

    await sharedPreferencesCache.setString(
      'lastKnownLocation',
      jsonEncode({'lat': userLocation.latitude, 'lng': userLocation.longitude}),
    );
    _accountApi.updateUserLocation(userId, userLocation);

    if (!context.mounted) return;
    Navigator.of(context).push(
      MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
    );
  }
}
