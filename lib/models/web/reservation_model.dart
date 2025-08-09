import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/reservations.dart';
import 'package:table_reserver/utils/animations.dart';

class ReservationsModel extends FlutterFlowModel<WebReservations>
    with ChangeNotifier {
  final ReservationApi reservationApi = ReservationApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.reservationsAnimations;

  final List<String> tableHeaders = [
    'Venue Name',
    'Username - User email',
    'Number of Guests',
    'Reservation Date',
  ];
  final List<ReservationDetails> reservations = [];

  @override
  void initState(BuildContext context) {}

  Future<void> fetchReservations() async {
    final int ownerId = prefsWithCache.getInt('userId')!;
    List<ReservationDetails> fetchedReservations = await reservationApi
        .getReservations(ownerId);

    reservations.clear();
    reservations.addAll(fetchedReservations);
    notifyListeners();
  }
}
