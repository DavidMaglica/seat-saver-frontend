import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/components/web/modals/edit_reservation_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class EditReservationModel extends FlutterFlowModel<EditReservationModal> {
  FocusNode venueNameFocusNode = FocusNode();
  TextEditingController venueNameTextController = TextEditingController();

  FocusNode userFocusNode = FocusNode();
  TextEditingController userTextController = TextEditingController();

  FocusNode numberOfGuestsFocusNode = FocusNode();
  TextEditingController numberOfGuestsTextController = TextEditingController();

  FocusNode reservationDateFocusNode = FocusNode();
  TextEditingController reservationDateTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  ReservationDetails? reservationDetails;
  List<String> venueTypes = [
    'Restaurant',
    'Cafe',
    'Bar',
    'Club',
    'Event Hall',
  ];

  @override
  void initState(BuildContext context) {
    reservationDetails = ReservationDetails(
      id: 1,
      userId: 1,
      venueId: 1,
      numberOfGuests: 3,
      datetime: DateTime.now(),
    );
    DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');
    if (reservationDetails != null) {
      venueNameTextController.text = reservationDetails!.venueId.toString();
      userTextController.text = reservationDetails!.userId.toString();
      numberOfGuestsTextController.text =
          reservationDetails!.numberOfGuests.toString();
      reservationDateTextController.text =
          dateFormat.format(reservationDetails!.datetime);
    }
  }

  @override
  void dispose() {
    venueNameFocusNode.dispose();
    venueNameTextController.dispose();

    userFocusNode.dispose();
    userTextController.dispose();

    numberOfGuestsFocusNode.dispose();
    numberOfGuestsTextController.dispose();

    reservationDateFocusNode.dispose();
    reservationDateTextController.dispose();
  }

  Future<void> editReservation() async {}
}
