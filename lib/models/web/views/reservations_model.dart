import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/reservations.dart';
import 'package:table_reserver/utils/animations.dart';

class ReservationsModel extends FlutterFlowModel<WebReservations>
    with ChangeNotifier {
  int? venueId;

  ReservationsModel({this.venueId});

  final ReservationsApi reservationsApi = ReservationsApi();
  final AccountApi accountApi = AccountApi();
  final VenuesApi venuesApi = VenuesApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.reservationsAnimations;

  int? selectedInterval = 30;
  Timer? _refreshTimer;

  final List<String> tableHeaders = [
    'Venue Name',
    'Username - User email',
    'Number of Guests',
    'Reservation Date',
  ];
  ValueNotifier<bool> isLoadingTable = ValueNotifier<bool>(false);
  final List<ReservationDetails> reservations = [];

  final Map<int, String> venueNamesById = {};
  final Map<int, String> userNamesById = {};

  @override
  void initState(BuildContext context) {}

  void init(int? venueId) {
    if (venueId != null) {
      fetchVenue(venueId);
      fetchVenueReservations(venueId);
    } else {
      fetchOwnedVenues();
      fetchReservations();
    }

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
    userNamesById.clear();
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

    userNamesById
      ..clear()
      ..addEntries(fetchedReservations.map((r) => MapEntry(r.id, r.username)));

    notifyListeners();
  }
}
