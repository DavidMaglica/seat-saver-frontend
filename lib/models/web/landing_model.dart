import 'package:TableReserver/pages/web/views/landing.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class LandingModel extends FlutterFlowModel<WebLanding> {
  final Map<String, AnimationInfo> animationsMap = Animations.landingAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
