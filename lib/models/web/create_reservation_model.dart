import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/components/web/modals/create_reservation_modal.dart';
import 'package:table_reserver/models/web/reservation_model.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class CreateReservationModel extends FlutterFlowModel<CreateReservationModal>
    with ChangeNotifier {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameTextController = TextEditingController();
  String? nameErrorText;

  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailTextController = TextEditingController();
  String? emailErrorText;

  FocusNode guestsFocusNode = FocusNode();
  TextEditingController guestsTextController = TextEditingController();
  String? guestsErrorText;

  FocusNode reservationDateFocusNode = FocusNode();
  TextEditingController reservationDateTextController = TextEditingController();
  String? reservationDateErrorText;
  DateTime reservationDate = DateTime.now();

  final ReservationApi reservationApi = ReservationApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    nameTextController.dispose();

    emailFocusNode.dispose();
    emailTextController.dispose();

    guestsFocusNode.dispose();
    guestsTextController.dispose();

    reservationDateFocusNode.dispose();
    reservationDateTextController.dispose();
  }

  Future<void> createReservation(BuildContext context) async {
    if (!isFormValid()) {
      notifyListeners();
      return;
    }

    String name = nameTextController.text;
    String email = emailTextController.text;
    int numberOfPeople = int.parse(guestsTextController.text);
    DateTime date = reservationDate;

    BasicResponse response = await reservationApi.createReservation(
      venueId: 2,
      userId: 1,
      numberOfPeople: numberOfPeople,
      reservationDate: date,
    );

    if (response.success) {
      if (!context.mounted) return;

      nameTextController.clear();
      emailTextController.clear();
      guestsTextController.clear();
      reservationDateTextController.clear();

      WebToaster.displaySuccess(context, response.message);
      Provider.of<ReservationsModel>(
        context,
        listen: false,
      ).fetchReservations();
      Navigator.of(context).pop();
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  bool isFormValid() {
    bool isValid = true;
    if (nameTextController.text.isEmpty) {
      nameErrorText = 'Please enter the name of your venue.';
      isValid = false;
    } else {
      nameErrorText = null;
    }

    if (emailTextController.text.isEmpty) {
      emailErrorText = 'Please enter the users email.';
      isValid = false;
    } else {
      emailErrorText = null;
    }

    if (guestsTextController.text.isEmpty) {
      guestsErrorText = 'Please enter the number of guests.';
      isValid = false;
    } else {
      guestsErrorText = null;
    }

    if (reservationDateTextController.text.isEmpty) {
      reservationDateErrorText = 'Please enter the reservation date.';
      isValid = false;
    } else {
      reservationDateErrorText = null;
    }

    notifyListeners();
    return isValid;
  }
}
