import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/reservation_details.dart';
import '../api/data/user.dart';
import '../api/reservation_api.dart';
import '../api/venue_api.dart';
import '../components/toaster.dart';

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
    final response = await reservationApi.getReservations(user.email);

    if (response.isNotEmpty) {
      reservations = response.map((reservation) {
        return ReservationDetails(
          id: reservation.id,
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

  Future<void> deleteReservation(int reservationId) async {
    final response =
        await reservationApi.deleteReservation(user.email, reservationId);

    if (response.success) {
      reservations
          ?.removeWhere((reservation) => reservation.id == reservationId);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      Toaster.displaySuccess(context, 'Reservation deleted successfully');
      notifyListeners();
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to delete reservation');
    }
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
