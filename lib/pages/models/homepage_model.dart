import 'package:diplomski/components/carousel_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/models/category_card_model.dart';
import '../../components/models/header_model.dart';
import '../../components/models/location_card_model.dart';
import '../../components/models/suggested_object_model.dart';
import '../homepage.dart';

class HomepageModel extends FlutterFlowModel<Homepage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  // Model for Header component.
  late HeaderModel headerModel;

  // Model for Carousel component.
  late CarouselComponentModel carouselComponentModel;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel1;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel2;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel3;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel4;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel5;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel6;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel7;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel8;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel9;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel10;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel11;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel12;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel13;

  // Model for LocationCard component.
  late LocationCardModel locationCardModel14;

  // Model for SuggestedObject component.
  late SuggestedObjectModel suggestedObjectModel;

  // Model for CategoryCard component.
  late CategoryCardModel categoryCardModel1;

  // Model for CategoryCard component.
  late CategoryCardModel categoryCardModel2;

  // Model for CategoryCard component.
  late CategoryCardModel categoryCardModel3;

  // Model for CategoryCard component.
  late CategoryCardModel categoryCardModel4;

  // Model for CategoryCard component.
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
