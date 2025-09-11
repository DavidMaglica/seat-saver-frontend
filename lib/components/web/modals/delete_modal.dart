import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/components/web/modals/modal_widgets.dart';
import 'package:seat_saver/models/web/modals/delete_modal_model.dart';

class DeleteModal extends StatefulWidget {
  final DeleteModalType modalType;
  final String venueName;
  final int? venueId;
  final int? reservationId;
  final String? userName;

  const DeleteModal({
    super.key,
    required this.modalType,
    required this.venueName,
    this.venueId,
    this.reservationId,
    this.userName,
  });

  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal>
    with TickerProviderStateMixin {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteModalModel(),
      child: Consumer<DeleteModalModel>(
        builder: (context, model, _) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 670),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(
                        context,
                        widget.modalType == DeleteModalType.venue
                            ? 'Delete Venue'
                            : 'Delete Reservation',
                      ),
                      const SizedBox(height: 16),
                      _buildBody(context),
                      const SizedBox(height: 8),
                      buildButtons(
                        context,
                        widget.modalType == DeleteModalType.venue
                            ? () => model.deleteVenue(context, widget.venueId!)
                            : () => model.deleteReservation(
                                context,
                                widget.reservationId!,
                              ),
                        widget.modalType == DeleteModalType.venue
                            ? 'Delete Venue'
                            : 'Delete Reservation',
                      ),
                    ].divide(const SizedBox(height: 16)),
                  ),
                ).animateOnPageLoad(model.animationsMap['modalOnLoad']!),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: widget.modalType == DeleteModalType.venue
          ? Text(
              'Are you sure you want to delete venue ${widget.venueName}?',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          : Text(
              'Are you sure you want to delete user ${widget.userName}`s reservation in ${widget.venueName}?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }
}
