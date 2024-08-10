import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/models/carousel_component_model.dart';
import '../../components/models/category_card_model.dart';
import '../../components/models/header_model.dart';
import '../../components/models/location_card_model.dart';
import '../../components/models/suggested_object_model.dart';
import '../homepage.dart';

class HomepageModel extends FlutterFlowModel<Homepage> {

  final unfocusNode = FocusNode();

  late HeaderModel headerModel;

  late CarouselComponentModel carouselComponentModel;

  late LocationCardModel locationCardModel1;

  late LocationCardModel locationCardModel2;

  late LocationCardModel locationCardModel3;

  late LocationCardModel locationCardModel4;

  late LocationCardModel locationCardModel5;

  late LocationCardModel locationCardModel6;

  late LocationCardModel locationCardModel7;

  late LocationCardModel locationCardModel8;

  late LocationCardModel locationCardModel9;

  late LocationCardModel locationCardModel10;

  late LocationCardModel locationCardModel11;

  late LocationCardModel locationCardModel12;

  late LocationCardModel locationCardModel13;

  late LocationCardModel locationCardModel14;

  late SuggestedObjectModel suggestedObjectModel;

  late CategoryCardModel categoryCardModel1;

  late CategoryCardModel categoryCardModel2;

  late CategoryCardModel categoryCardModel3;

  late CategoryCardModel categoryCardModel4;

  late CategoryCardModel categoryCardModel5;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    carouselComponentModel =
        createModel(context, () => CarouselComponentModel());
    locationCardModel1 = createModel(context, () => LocationCardModel());
    locationCardModel2 = createModel(context, () => LocationCardModel());
    locationCardModel3 = createModel(context, () => LocationCardModel());
    locationCardModel4 = createModel(context, () => LocationCardModel());
    locationCardModel5 = createModel(context, () => LocationCardModel());
    locationCardModel6 = createModel(context, () => LocationCardModel());
    locationCardModel7 = createModel(context, () => LocationCardModel());
    locationCardModel8 = createModel(context, () => LocationCardModel());
    locationCardModel9 = createModel(context, () => LocationCardModel());
    locationCardModel10 = createModel(context, () => LocationCardModel());
    locationCardModel11 = createModel(context, () => LocationCardModel());
    locationCardModel12 = createModel(context, () => LocationCardModel());
    locationCardModel13 = createModel(context, () => LocationCardModel());
    locationCardModel14 = createModel(context, () => LocationCardModel());
    suggestedObjectModel = createModel(context, () => SuggestedObjectModel());
    categoryCardModel1 = createModel(context, () => CategoryCardModel());
    categoryCardModel2 = createModel(context, () => CategoryCardModel());
    categoryCardModel3 = createModel(context, () => CategoryCardModel());
    categoryCardModel4 = createModel(context, () => CategoryCardModel());
    categoryCardModel5 = createModel(context, () => CategoryCardModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    headerModel.dispose();
    carouselComponentModel.dispose();
    locationCardModel1.dispose();
    locationCardModel2.dispose();
    locationCardModel3.dispose();
    locationCardModel4.dispose();
    locationCardModel5.dispose();
    locationCardModel6.dispose();
    locationCardModel7.dispose();
    locationCardModel8.dispose();
    locationCardModel9.dispose();
    locationCardModel10.dispose();
    locationCardModel11.dispose();
    locationCardModel12.dispose();
    locationCardModel13.dispose();
    locationCardModel14.dispose();
    suggestedObjectModel.dispose();
    categoryCardModel1.dispose();
    categoryCardModel2.dispose();
    categoryCardModel3.dispose();
    categoryCardModel4.dispose();
    categoryCardModel5.dispose();
  }
}
