import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/reservation_details.dart';
import '../api/data/user.dart';
import '../api/reservation_api.dart';

class ReservationHistoryModel extends ChangeNotifier {
  final User user;
  final Position? userLocation;
  final BuildContext context;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ReservationApi reservationApi = ReservationApi();

  List<ReservationDetails>? reservations;

  ReservationHistoryModel({
    required this.user,
    required this.context,
    this.userLocation,
  });

  Future<void> loadReservations() async {
    final response2 = await reservationApi.getReservation(user.email);
    debugPrint('Reservations: ${response2?.reservations}');

    debugPrint('Reservations: ${reservationApi.reservationsStore}');

    if (response2 != null) {
      reservations = response2.reservations;
    } else {
      reservations = [];
    }

    // final response = await reservationApi.getReservations(user.email);
    // if (response.success) {
    //   reservations = response.reservations;
    //   notifyListeners();
    // }
  }
}
