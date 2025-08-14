import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/components/web/modals/delete_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/logger.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class DeleteModalModel extends FlutterFlowModel<DeleteModal>
    with ChangeNotifier {
  final ReservationApi reservationApi = ReservationApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  void deleteVenue(BuildContext context, int venueId) {
    logger.i('Deleting venue: $venueId');
  }

  Future<void> deleteReservation(
    BuildContext context,
    int reservationId,
  ) async {
    BasicResponse response = await reservationApi.deleteReservation(
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
