import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/animations.dart';

class LandingModel extends FlutterFlowModel<WebLanding> {
  final Map<String, AnimationInfo> animationsMap = Animations.landingAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
