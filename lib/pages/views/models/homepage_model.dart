import 'package:diplomski/components/location_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../../components/models/carousel_component_model.dart';
import '../../../components/models/category_card_model.dart';
import '../../../components/models/header_model.dart';
import '../../../components/models/suggested_object_model.dart';
import '../homepage.dart';

class HomepageModel extends FlutterFlowModel<Homepage> {
  final unfocusNode = FocusNode();

  late HeaderModel headerModel;

  late CarouselComponentModel carouselComponentModel;

  late LocationCard locationCard;

  late SuggestedObjectModel suggestedObjectModel;

  late CategoryCardModel categoryCardModel;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    carouselComponentModel =
        createModel(context, () => CarouselComponentModel());
    locationCard = const LocationCard();
    suggestedObjectModel = createModel(context, () => SuggestedObjectModel());
    categoryCardModel = createModel(context, () => CategoryCardModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    headerModel.dispose();
    carouselComponentModel.dispose();
    suggestedObjectModel.dispose();
    categoryCardModel.dispose();
  }
}
