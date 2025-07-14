import 'package:TableReserver/pages/web/views/landing.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class LandingModel extends FlutterFlowModel<WebLanding> {
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState(BuildContext context) {
    animationsMap.addAll(Animations.landingAnimations);
  }

  @override
  void dispose() {}
}
