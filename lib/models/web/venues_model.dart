import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/pages/web/views/venues.dart';
import 'package:table_reserver/utils/animations.dart';

class VenuesModel extends FlutterFlowModel<WebVenuesPage> {
  final Map<String, AnimationInfo> animationsMap = Animations.venuesAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
