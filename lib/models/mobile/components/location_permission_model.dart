import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/notification_settings.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/toaster.dart';

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

    BasicResponse basicResponse = await _accountApi
        .updateUserNotificationOptions(
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
    if (!await _handleLocationPermission()) return;

    Position? userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

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
