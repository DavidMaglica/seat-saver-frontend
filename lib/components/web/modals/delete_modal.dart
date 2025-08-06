import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/delete_venue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class DeleteModal extends StatefulWidget {
  final DeleteModalType modalType;
  final int? venueId;
  final int? reservationId;

  const DeleteModal({
    super.key,
    required this.modalType,
    this.venueId,
    this.reservationId,
  });

  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal>
    with TickerProviderStateMixin {
  late DeleteModalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteModalModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 670,
            ),
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
                  () => {},
                  widget.modalType == DeleteModalType.venue
                      ? 'Delete Venue'
                      : 'Delete Reservation',
                ),
              ].divide(const SizedBox(height: 16)),
            ),
          ).animateOnPageLoad(
              _model.animationsMap['containerOnPageLoadAnimation']!),
        ],
      ),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
      child: widget.modalType == DeleteModalType.venue
          ? Text(
              'Are you sure you want to delete venue with Id ${widget.venueId}?',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          : Text(
              'Are you sure you want to delete reservation with Id ${widget.reservationId}?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }
}
