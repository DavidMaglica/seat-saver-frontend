import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/animations.dart';

class ReservationsGraphsPageModel extends ChangeNotifier {
  final int ownerId;

  ReservationsGraphsPageModel({required this.ownerId});

  final VenueApi venueApi = VenueApi();
  final ReservationApi reservationApi = ReservationApi();

  Timer? _refreshTimer;

  final Map<String, AnimationInfo> animationsMap =
      Animations.utilityPagesAnimations;

  final List<Venue> venues = [];

  final Map<int, List<ReservationDetails>> reservationsByVenueId = {};

  bool isWeekly = false;
  bool isLoading = true;

  void init() {
    fetchVenues();
    _fetchReservations();

    _refreshTimer = Timer.periodic(const Duration(minutes: 1, seconds: 30), (timer) {
      fetchVenues();
      _fetchReservations();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchVenues() async {
    PagedResponse<Venue> pagedVenues = await venueApi.getVenuesByOwner(ownerId);

    venues.clear();

    for (final venue in pagedVenues.content) {
      venues.add(venue);
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> _fetchReservations() async {
    List<ReservationDetails> reservations = await reservationApi
        .getOwnerReservations(ownerId);

    reservationsByVenueId.clear();
    for (final reservation in reservations) {
      if (!reservationsByVenueId.containsKey(reservation.venueId)) {
        reservationsByVenueId[reservation.venueId] = [];
      }
      reservationsByVenueId[reservation.venueId]?.add(reservation);
    }
  }

  void toggleGraphType(bool value) {
    isWeekly = value;
    notifyListeners();
  }
}
