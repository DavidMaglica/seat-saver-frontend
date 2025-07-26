import 'package:TableReserver/models/web/side_nav_model.dart';
import 'package:TableReserver/pages/web/views/venues.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class VenuesModel extends FlutterFlowModel<WebVenuesPage> {
  late SideNavModel sideNavModel;

  final Map<String, AnimationInfo> animationsMap =
      Animations.venuePageAnimations;

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }
}
