import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReservationHistoryModel extends ChangeNotifier {
  final BuildContext context;
  final int userId;
  final Position? userLocation;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ReservationApi reservationApi = ReservationApi();
  final VenueApi venueApi = VenueApi();

  List<ReservationDetails>? reservations;
  final Map<int, String> _venueNameCache = {};

  ReservationHistoryModel({
    required this.context,
    required this.userId,
    this.userLocation,
  });

  void init() {
    _loadReservationsFromApi();
  }

  Future<void> _loadReservationsFromApi() async {
   List<ReservationDetails> response = await reservationApi.getReservations(userId);

    if (response.isNotEmpty) {
      reservations = response;

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
        await reservationApi.deleteReservation(userId, reservationId);

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

    if (venue != null) {
      _venueNameCache[venueId] = venue.name;
      notifyListeners();
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to load venue name');
    }
  }
}
