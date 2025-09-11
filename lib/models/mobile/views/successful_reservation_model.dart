import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';

class SuccessfulReservationModel extends ChangeNotifier {
  final String venueName;
  final int numberOfGuests;
  final DateTime reservationDateTime;

  int countdown = 15;
  Timer? _timer;

  SuccessfulReservationModel({
    required this.venueName,
    required this.numberOfGuests,
    required this.reservationDateTime,
  });

  @override
  void dispose() {
    cancelCountdown();
    super.dispose();
  }

  void startCountdown(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        timer.cancel();
        navigateToHomepage(context);
      } else {
        countdown--;
        notifyListeners();
      }
    });
  }

  void cancelCountdown() {
    _timer?.cancel();
  }

  void navigateToHomepage(BuildContext context) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
    );
  }
}
