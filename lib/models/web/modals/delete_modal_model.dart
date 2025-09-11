import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/reservation_api.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/components/web/modals/delete_modal.dart';
import 'package:seat_saver/utils/animations.dart';
import 'package:seat_saver/utils/web_toaster.dart';

class DeleteModalModel extends FlutterFlowModel<DeleteModal>
    with ChangeNotifier {
  final ReservationsApi reservationsApi = ReservationsApi();
  final VenuesApi venuesApi = VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  void deleteVenue(BuildContext context, int venueId) async {
    BasicResponse response = await venuesApi.deleteVenue(venueId);
    if (response.success) {
      if (!context.mounted) return;
      WebToaster.displaySuccess(context, 'Venue deleted successfully.');
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Failed to delete venue: ${response.message}',
      );
    }
  }

  Future<void> deleteReservation(
    BuildContext context,
    int reservationId,
  ) async {
    BasicResponse response = await reservationsApi.deleteReservation(
      reservationId,
    );

    if (response.success) {
      if (!context.mounted) return;
      WebToaster.displaySuccess(context, 'Reservation deleted successfully.');
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Failed to delete reservation: ${response.message}',
      );
    }
  }
}
