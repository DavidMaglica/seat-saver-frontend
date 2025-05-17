import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/constants.dart';

class SuccessfulReservationModel extends ChangeNotifier {
  final BuildContext context;
  final String venueName;
  final int numberOfGuests;
  final DateTime reservationDateTime;
  final String userEmail;
  final Position? userLocation;

  int countdown = 15;
  Timer? _timer;

  SuccessfulReservationModel({
    required this.context,
    required this.venueName,
    required this.numberOfGuests,
    required this.reservationDateTime,
    required this.userEmail,
    required this.userLocation,
  });

  @override
  void dispose() {
    cancelCountdown();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        timer.cancel();
        navigateToHomepage();
      } else {
        countdown--;
        notifyListeners();
      }
    });
  }

  void cancelCountdown() {
    _timer?.cancel();
  }

  void navigateToHomepage() {
    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, Routes.homepage, arguments: {
      'userEmail': userEmail,
      'userLocation': userLocation,
    });
  }
}
