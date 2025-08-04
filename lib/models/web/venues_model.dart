import 'package:table_reserver/models/web/side_nav_model.dart';
import 'package:table_reserver/pages/web/views/venues.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class VenuesModel extends FlutterFlowModel<WebVenuesPage> {
  late SideNavModel sideNavModel;

  final Map<String, AnimationInfo> animationsMap =
      Animations.venuesAnimations;

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }
}
