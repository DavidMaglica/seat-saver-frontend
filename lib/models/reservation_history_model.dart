import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/reservation_details.dart';
import '../api/data/user.dart';
import '../api/reservation_api.dart';

class ReservationHistoryModel extends ChangeNotifier {
  final BuildContext context;
  final User user;
  final Position? userLocation;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ReservationApi reservationApi = ReservationApi();

  List<ReservationDetails>? reservations;

  ReservationHistoryModel({
    required this.context,
    required this.user,
    this.userLocation,
  });

  Future<void> loadReservations() async {
    final response2 = await reservationApi.getReservation(user.email);

    if (response2 != null) {
      reservations = response2.reservations;
    } else {
      reservations = [];
    }

    notifyListeners();
  }
}
