import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../nearby.dart';

class NearbyModel extends FlutterFlowModel<Nearby> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
