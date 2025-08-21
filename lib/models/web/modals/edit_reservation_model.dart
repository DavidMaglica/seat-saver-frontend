import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/components/web/modals/edit_reservation_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class EditReservationModel extends FlutterFlowModel<EditReservationModal>
    with ChangeNotifier {
  FocusNode venueNameFocusNode = FocusNode();
  TextEditingController venueNameTextController = TextEditingController();

  FocusNode userFocusNode = FocusNode();
  TextEditingController userTextController = TextEditingController();

  FocusNode numberOfGuestsFocusNode = FocusNode();
  TextEditingController numberOfGuestsTextController = TextEditingController();
  String? numberOfGuestsErrorText;

  FocusNode reservationDateFocusNode = FocusNode();
  TextEditingController reservationDateTextController = TextEditingController();
  String? reservationDateErrorText;
  DateTime reservationDate = DateTime.now();

  final ReservationsApi reservationsApi = ReservationsApi();

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
    ReservationDetails? response = await reservationsApi.getReservationById(
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

  Future<void> editReservation(BuildContext context) async {
    if (!_isFormValid()) {
      notifyListeners();
      return;
    }

    int reservationId = reservationDetails!.id;
    int numberOfGuests = int.parse(numberOfGuestsTextController.text);

    BasicResponse response = await reservationsApi.updateReservation(
      reservationId: reservationId,
      numberOfGuests: numberOfGuests,
      reservationDate: reservationDate,
    );
    if (response.success) {
      if (!context.mounted) return;

      WebToaster.displaySuccess(context, response.message);
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  bool _isFormValid() {
    bool isValid = true;
    if (numberOfGuestsTextController.text.isEmpty) {
      numberOfGuestsErrorText = 'Please enter the number of guests';
      isValid = false;
    } else {
      numberOfGuestsErrorText = null;
    }

    if (reservationDateTextController.text.isEmpty) {
      reservationDateErrorText = 'Please enter the reservation date';
      isValid = false;
    } else {
      reservationDateErrorText = null;
    }

    notifyListeners();
    return isValid;
  }
}
