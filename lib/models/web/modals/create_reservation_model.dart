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
import 'package:table_reserver/utils/utils.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class CreateReservationModel extends FlutterFlowModel<CreateReservationModal>
    with ChangeNotifier {
  Map<int, Venue> venuesById = {};
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

  final ReservationsApi reservationsApi = ReservationsApi();
  final VenuesApi venuesApi = VenuesApi();

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
    final int ownerId = sharedPreferencesCache.getInt('ownerId')!;
    PagedResponse<Venue> pagedVenues = await venuesApi.getVenuesByOwner(
      ownerId,
      size: 50,
    );

    if (pagedVenues.items.isEmpty) {
      return;
    }

    venuesById
      ..clear()
      ..addEntries(pagedVenues.items.map((venue) => MapEntry(venue.id, venue)));

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

    BasicResponse response = await reservationsApi.createReservation(
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
    final int? venueId = int.tryParse(dropDownValueController.value!);
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

    final Venue venue = venuesById[venueId]!;

    final bool isWorkingDay = venue.workingDays.contains(
      reservationDate.weekday - 1,
    );
    final bool isWorkingHour = isWithinWorkingHours(
      reservationDate,
      venue.workingHours,
    );
    if (reservationDateTextController.text.isEmpty) {
      reservationDateErrorText = 'Please enter the reservation date.';
      isValid = false;
    } else if (!isWorkingDay) {
      reservationDateErrorText =
          'The selected date is not a working day for the venue.';
      isValid = false;
    } else if (!isWorkingHour) {
      reservationDateErrorText =
          'The selected time is outside the venue\'s working hours.';
      isValid = false;
    } else {
      reservationDateErrorText = null;
    }

    notifyListeners();
    return isValid;
  }
}
