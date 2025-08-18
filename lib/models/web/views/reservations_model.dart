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
  final ReservationApi reservationApi = ReservationApi();
  final AccountApi accountApi = AccountApi();
  final VenueApi venueApi = VenueApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.reservationsAnimations;

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

  void init() {
    fetchOwnedVenues();
    fetchReservations();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchReservations();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    isLoadingTable.dispose();
    super.dispose();
  }

  Future<void> fetchReservations() async {
    isLoadingTable.value = true;
    notifyListeners();
    final int ownerId = prefsWithCache.getInt('ownerId')!;
    List<ReservationDetails> fetchedReservations = await reservationApi
        .getOwnerReservations(ownerId);

    fetchedReservations.sort((a, b) => a.datetime.compareTo(b.datetime));

    if (fetchedReservations.isNotEmpty) {
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
    final int ownerId = prefsWithCache.getInt('ownerId')!;
    PagedResponse<Venue> fetchedVenues = await venueApi.getVenuesByOwner(
      ownerId,
      size: 50,
    );

    venueNamesById
      ..clear()
      ..addEntries(fetchedVenues.content.map((v) => MapEntry(v.id, v.name)));

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
