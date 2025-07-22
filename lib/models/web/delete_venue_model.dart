import 'package:TableReserver/components/web/delete_venue_modal.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class DeleteVenueModel extends FlutterFlowModel<DeleteVenueModal> {
  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
