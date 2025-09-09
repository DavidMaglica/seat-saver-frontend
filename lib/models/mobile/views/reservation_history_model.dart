import 'package:flutter/material.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/toaster.dart';

class ReservationHistoryModel extends ChangeNotifier {
  final int userId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ReservationsApi reservationsApi;
  final VenuesApi venuesApi;

  List<ReservationDetails>? reservations;
  final Map<int, String> _venueNameCache = {};

  ReservationHistoryModel({
    required this.userId,
    ReservationsApi? reservationsApi,
    VenuesApi? venuesApi,
  })
      : reservationsApi = reservationsApi ?? ReservationsApi(),
        venuesApi = venuesApi ?? VenuesApi();

  void init(BuildContext context,) {
    _loadReservationsFromApi(context);
  }

  Future<void> _loadReservationsFromApi(BuildContext context,) async {
    List<ReservationDetails> response = await reservationsApi
        .getUserReservations(userId);

    if (response.isNotEmpty) {
      reservations = response;

      for (var reservation in reservations!) {
        _fetchVenueName(context, reservation.venueId);
      }
    } else {
      reservations = [];
    }

    notifyListeners();
  }

  Future<void> deleteReservation(BuildContext context,
      int reservationId,) async {
    final response = await reservationsApi.deleteReservation(reservationId);

    if (response.success) {
      reservations?.removeWhere(
        (reservation) => reservation.id == reservationId,
      );
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

  Future<void> _fetchVenueName(BuildContext context, int venueId) async {
    if (_venueNameCache.containsKey(venueId)) return;

    final venue = await venuesApi.getVenue(venueId);

    if (venue != null) {
      _venueNameCache[venueId] = venue.name;
      notifyListeners();
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to load venue name');
    }
  }
}
