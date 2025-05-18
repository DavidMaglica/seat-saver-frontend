import 'package:TableReserver/api/venue_api.dart';
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
  final VenueApi venueApi = VenueApi();

  List<ReservationDetails>? reservations;
  final Map<int, String> _venueNameCache = {};

  ReservationHistoryModel({
    required this.context,
    required this.user,
    this.userLocation,
  });

  void init() {
    loadReservationsFromApi();
  }

  Future<void> loadReservationsFromApi() async {
    final response = await reservationApi.getReservationsFromApi(user.email);

    if (response.isNotEmpty) {
      reservations = response.map((reservation) {
        return ReservationDetails(
          venueId: reservation.venueId,
          numberOfGuests: reservation.numberOfGuests,
          reservationDateTime: DateTime.parse(reservation.dateTime),
        );
      }).toList();

      for (var reservation in reservations!) {
        _fetchVenueName(reservation.venueId);
      }
    } else {
      reservations = [];
    }

    notifyListeners();
  }

  String getVenueName(int venueId) {
    return _venueNameCache[venueId] ?? 'Loading...';
  }

  Future<void> _fetchVenueName(int venueId) async {
    if (_venueNameCache.containsKey(venueId)) return;

    final venue = await venueApi.getVenue(venueId);
    _venueNameCache[venueId] = venue.name;
    notifyListeners();
  }
}
