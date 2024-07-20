import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../nearby.dart';

class NearbyModel extends FlutterFlowModel<Nearby> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  // State field(s) for GoogleMap widget.
  // gmaps.LatLng? googleMapsCenter;
  // final googleMapsController = Completer<gmaps.GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
