import 'package:diplomski/components/venue_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../../components/models/carousel_component_model.dart';
import '../homepage.dart';

class HomepageModel extends FlutterFlowModel<Homepage> {
  final unfocusNode = FocusNode();

  late CarouselComponentModel carouselComponentModel;

  late VenueCard locationCard;

  @override
  void initState(BuildContext context) {
    carouselComponentModel =
        createModel(context, () => CarouselComponentModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    carouselComponentModel.dispose();
  }
}
