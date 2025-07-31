import 'package:TableReserver/components/web/modals/create_reservation_modal.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

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
    debugPrint('Adding new reservation...');
    debugPrint('New Venue Name: ${nameTextController.text}');
    debugPrint('New User: ${emailTextController.text}');
    debugPrint('New guests: ${guestsTextController.text}');
    debugPrint('New Date: ${reservationDateTextController.text}');
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
