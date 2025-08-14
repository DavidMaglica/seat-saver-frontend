import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/web/modals/create_reservation_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class CreateReservationModel extends FlutterFlowModel<CreateReservationModal>
    with ChangeNotifier {
  Map<int, String> venueNamesById = {};
  String? dropDownValue;
  FormFieldController<String> dropDownValueController =
      FormFieldController<String>(null);
  String? dropDownErrorText;

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
  final VenueApi venueApi = VenueApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    emailTextController.dispose();

    guestsFocusNode.dispose();
    guestsTextController.dispose();

    reservationDateFocusNode.dispose();
    reservationDateTextController.dispose();
  }

  Future<void> fetchOwnedVenues() async {
    final int ownerId = prefsWithCache.getInt('userId')!;
    PagedResponse<Venue> fetchedVenues = await venueApi.getVenuesByOwner(
      ownerId,
      size: 50,
    );

    if (fetchedVenues.content.isEmpty) {
      return;
    }

    venueNamesById
      ..clear()
      ..addEntries(fetchedVenues.content.map((v) => MapEntry(v.id, v.name)));

    notifyListeners();
  }

  Future<void> createReservation(BuildContext context) async {
    if (!_isFormValid()) {
      notifyListeners();
      return;
    }

    int venueId = int.parse(dropDownValueController.value ?? '1');
    String email = emailTextController.text;
    int numberOfPeople = int.parse(guestsTextController.text);
    DateTime date = reservationDate;

    BasicResponse response = await reservationApi.createReservation(
      venueId: venueId,
      userEmail: email,
      numberOfGuests: numberOfPeople,
      reservationDate: date,
    );

    if (response.success) {
      if (!context.mounted) return;

      emailTextController.clear();
      guestsTextController.clear();
      reservationDateTextController.clear();

      WebToaster.displaySuccess(context, response.message);
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  bool _isFormValid() {
    bool isValid = true;
    if (dropDownValueController.value == null ||
        dropDownValueController.value!.isEmpty) {
      dropDownErrorText = 'Please select a venue.';
      isValid = false;
    } else {
      dropDownErrorText = null;
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
