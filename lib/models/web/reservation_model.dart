import 'package:TableReserver/api/data/reservation_details.dart';
import 'package:TableReserver/models/web/side_nav_model.dart';
import 'package:TableReserver/pages/web/views/reservations.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ReservationsModel extends FlutterFlowModel<WebReservations> {
  late SideNavModel sideNavModel;

  final Map<String, AnimationInfo> animationsMap =
      Animations.reservationsAnimations;

  final List<String> tableHeaders = [
    'Venue Name',
    'Username - User email',
    'Number of Guests',
    'Reservation Date',
  ];
  final List<ReservationDetails> reservations = [
    ReservationDetails(
      id: 1,
      userId: 1,
      venueId: 1,
      numberOfGuests: 3,
      datetime: DateTime.now(),
    ),
    ReservationDetails(
      id: 2,
      userId: 2,
      venueId: 2,
      numberOfGuests: 5,
      datetime: DateTime.now().add(const Duration(days: -1)),
    ),
    ReservationDetails(
      id: 3,
      userId: 3,
      venueId: 3,
      numberOfGuests: 2,
      datetime: DateTime.now().add(const Duration(days: -2)),
    ),
    ReservationDetails(
      id: 4,
      userId: 4,
      venueId: 4,
      numberOfGuests: 4,
      datetime: DateTime.now().add(const Duration(days: -3)),
    ),
  ];

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }
}
