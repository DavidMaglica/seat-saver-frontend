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

  final VenuesApi venuesApi;
  final ReservationsApi reservationsApi;

  ReservationsGraphsPageModel({
    required this.ownerId,
    VenuesApi? venuesApi,
    ReservationsApi? reservationsApi,
  }) : venuesApi = venuesApi ?? VenuesApi(),
       reservationsApi = reservationsApi ?? ReservationsApi();

  int? selectedInterval = null;
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

    startTimer();
  }

  void startTimer() {
    _refreshTimer?.cancel();
    if (selectedInterval == null) {
      return;
    }

    _refreshTimer = Timer.periodic(Duration(seconds: selectedInterval!), (
      timer,
    ) {
      fetchVenues();
      _fetchReservations();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchVenues() async {
    PagedResponse<Venue> pagedVenues = await venuesApi.getVenuesByOwner(
      ownerId,
    );

    venues.clear();

    for (final venue in pagedVenues.content) {
      venues.add(venue);
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> _fetchReservations() async {
    List<ReservationDetails> reservations = await reservationsApi
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
