import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/reservation_details.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/web/views/reservations.dart';
import 'package:seat_saver/utils/animations.dart';

class ReservationsModel extends FlutterFlowModel<WebReservations>
    with ChangeNotifier {
  int? venueId;

  final ReservationsApi reservationsApi;
  final AccountApi accountApi;
  final VenuesApi venuesApi;

  ReservationsModel({
    this.venueId,
    ReservationsApi? reservationsApi,
    AccountApi? accountApi,
    VenuesApi? venuesApi,
  }) : reservationsApi = reservationsApi ?? ReservationsApi(),
       accountApi = accountApi ?? AccountApi(),
       venuesApi = venuesApi ?? VenuesApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.reservationsAnimations;

  int? selectedInterval = null;
  Timer? _refreshTimer;

  final List<String> tableHeaders = [
    'Venue Name',
    'User email',
    'Number of Guests',
    'Reservation Date',
  ];
  ValueNotifier<bool> isLoadingTable = ValueNotifier<bool>(false);
  final List<ReservationDetails> reservations = [];

  final Map<int, String> venueNamesById = {};
  final Map<int, String> userEmailsById = {};

  @override
  void initState(BuildContext context) {}

  Future<void> init(int? venueId) async {
    if (venueId != null) {
      await fetchVenue(venueId);
      await fetchVenueReservations(venueId);
    } else {
      await fetchOwnedVenues();
      await fetchReservations();
    }

    if (selectedInterval != null) startTimer();
  }

  void startTimer() {
    _refreshTimer?.cancel();
    if (selectedInterval == null) {
      return;
    }

    _refreshTimer = Timer.periodic(Duration(seconds: selectedInterval!), (
      timer,
    ) {
      if (venueId != null) {
        fetchVenueReservations(venueId!);
      } else {
        fetchReservations();
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    isLoadingTable.dispose();
    reservations.clear();
    venueNamesById.clear();
    userEmailsById.clear();
    super.dispose();
  }

  Future<void> fetchVenue(int venueId) async {
    Venue? fetchedVenue = await venuesApi.getVenue(venueId);
    if (fetchedVenue != null) {
      venueNamesById[venueId] = fetchedVenue.name;
      notifyListeners();
    }
  }

  Future<void> fetchVenueReservations(int venueId) async {
    isLoadingTable.value = true;
    notifyListeners();
    List<ReservationDetails> fetchedReservations = await reservationsApi
        .getVenueReservations(venueId);

    fetchedReservations.sort((a, b) => a.datetime.compareTo(b.datetime));

    if (fetchedReservations.isNotEmpty) {
      fetchedReservations.removeWhere((reservation) {
        return reservation.datetime.isBefore(
          DateTime.now().subtract(const Duration(hours: 1)),
        );
      });
      List<int> userIds = fetchedReservations.map((reservation) {
        return reservation.userId;
      }).toList();
      fetchUserNames(userIds);
    }

    reservations
      ..clear()
      ..addAll(fetchedReservations);

    isLoadingTable.value = false;
    notifyListeners();
  }

  Future<void> fetchReservations() async {
    isLoadingTable.value = true;
    notifyListeners();
    final int ownerId = sharedPreferencesCache.getInt('ownerId')!;
    List<ReservationDetails> fetchedReservations = await reservationsApi
        .getOwnerReservations(ownerId);

    fetchedReservations.sort((a, b) => a.datetime.compareTo(b.datetime));

    if (fetchedReservations.isNotEmpty) {
      fetchedReservations.removeWhere((reservation) {
        return reservation.datetime.isBefore(
          DateTime.now().subtract(const Duration(hours: 1)),
        );
      });
      List<int> userIds = fetchedReservations.map((reservation) {
        return reservation.userId;
      }).toList();
      fetchUserNames(userIds);
    }

    reservations
      ..clear()
      ..addAll(fetchedReservations);

    isLoadingTable.value = false;
    notifyListeners();
  }

  Future<void> fetchOwnedVenues() async {
    final int ownerId = sharedPreferencesCache.getInt('ownerId')!;
    PagedResponse<Venue> pagedVenues = await venuesApi.getVenuesByOwner(
      ownerId,
      size: 50,
    );

    venueNamesById
      ..clear()
      ..addEntries(pagedVenues.items.map((v) => MapEntry(v.id, v.name)));

    notifyListeners();
  }

  Future<void> fetchUserNames(List<int> userIds) async {
    List<User> fetchedReservations = await accountApi.getUsersByIds(userIds);

    userEmailsById
      ..clear()
      ..addEntries(fetchedReservations.map((r) => MapEntry(r.id, r.email)));

    notifyListeners();
  }
}
