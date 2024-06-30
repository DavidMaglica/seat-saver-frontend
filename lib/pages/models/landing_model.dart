import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../landing.dart';

class LandingModel extends FlutterFlowModel<LandingPage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
