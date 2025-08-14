import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/components/web/modals/edit_reservation_modal.dart';
import 'package:table_reserver/utils/animations.dart';

class EditReservationModel extends FlutterFlowModel<EditReservationModal>
    with ChangeNotifier {
  FocusNode venueNameFocusNode = FocusNode();
  TextEditingController venueNameTextController = TextEditingController();

  FocusNode userFocusNode = FocusNode();
  TextEditingController userTextController = TextEditingController();

  FocusNode numberOfGuestsFocusNode = FocusNode();
  TextEditingController numberOfGuestsTextController = TextEditingController();

  FocusNode reservationDateFocusNode = FocusNode();
  TextEditingController reservationDateTextController = TextEditingController();

  final ReservationApi reservationApi = ReservationApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  ReservationDetails? reservationDetails;

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
      numberOfGuestsTextController.text = reservationDetails!.numberOfGuests
          .toString();
      reservationDateTextController.text = dateFormat.format(
        reservationDetails!.datetime,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    venueNameFocusNode.dispose();
    venueNameTextController.dispose();

    userFocusNode.dispose();
    userTextController.dispose();

    numberOfGuestsFocusNode.dispose();
    numberOfGuestsTextController.dispose();

    reservationDateFocusNode.dispose();
    reservationDateTextController.dispose();
  }

  Future<void> fetchReservationDetails(
    BuildContext context,
    int reservationId,
    String venueName,
    String userName,
  ) async {
    ReservationDetails? response = await reservationApi.getReservationById(
      reservationId,
    );
    if (response != null) {
      reservationDetails = response;
      DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');
      venueNameTextController.text = venueName;
      userTextController.text = userName;
      numberOfGuestsTextController.text = response.numberOfGuests.toString();
      reservationDateTextController.text = dateFormat.format(response.datetime);
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  Future<void> editReservation() async {
    BasicResponse response = await reservationApi.updateReservation(
      reservationId: reservationDetails!.id,
      numberOfGuests: int.parse(numberOfGuestsTextController.text),
      reservationDate: DateTime.parse(reservationDateTextController.text),
    );
  }
}
