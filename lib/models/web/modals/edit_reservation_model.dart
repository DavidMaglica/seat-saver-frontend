import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/web/modals/edit_reservation_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/utils.dart';
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
  final VenuesApi venuesApi = VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  Venue? venue;
  ReservationDetails? reservationDetails;

  @override
  void initState(BuildContext context) {}

  void init(BuildContext context, int reservationId, String venueName,
      String userName) async {
    DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');
    await _fetchReservationDetails(context, reservationId, venueName, userName);
    await _fetchVenue();

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

  Future<void> _fetchVenue() async {
    if (reservationDetails == null) return;
    final int venueId = reservationDetails!.venueId;
    final Venue? response = await venuesApi.getVenue(venueId);
    if (response != null) {
      venue = response;
    }
    notifyListeners();
  }

  Future<void> _fetchReservationDetails(
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

    final bool isWorkingDay = venue!.workingDays.contains(
      reservationDate.weekday - 1,
    );
    final bool isWorkingHour = isWithinWorkingHours(
      reservationDate,
      venue!.workingHours,
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
