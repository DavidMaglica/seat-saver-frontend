import 'package:table_reserver/pages/web/views/landing.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/models/web/side_nav_model.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';

class AccountModel extends FlutterFlowModel<WebAccount> {
  late SideNavModel sideNavModel;

  final Map<String, AnimationInfo> animationsMap = Animations.accountAnimations;

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }

  Future<void> logOut(BuildContext context) async {
    Navigator.of(context).push(
        FadeInRoute(page: const WebLanding(), routeName: Routes.webLanding)
    );
  }
}
