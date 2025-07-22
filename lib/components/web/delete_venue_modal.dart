import 'package:TableReserver/components/web/modal_widgets.dart';
import 'package:TableReserver/models/web/delete_venue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class DeleteVenueModal extends StatefulWidget {
  final int venueId;

  const DeleteVenueModal({super.key, required this.venueId});

  @override
  State<DeleteVenueModal> createState() => _DeleteVenueModalState();
}

class _DeleteVenueModalState extends State<DeleteVenueModal>
    with TickerProviderStateMixin {
  late DeleteVenueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteVenueModel());
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
                buildTitle(context, 'Delete Venue'),
                const SizedBox(height: 16),
                _buildBody(context),
                const SizedBox(height: 8),
                buildButtons(context, () => {}, 'Delete Venue'),
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
      child: Text(
        'Are you sure you want to delete ${widget.venueId} \$venueName?',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
