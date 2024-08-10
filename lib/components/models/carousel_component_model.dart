import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../carousel_component.dart';
import 'carouse_item_model.dart';

class CarouselComponentModel extends FlutterFlowModel<CarouselComponent> {
  CarouselController? carouselController;
  int carouselCurrentIndex = 1;

  late CarouselItemModel carouselItemModel1;

  late CarouselItemModel carouselItemModel2;

  late CarouselItemModel carouselItemModel3;

  late CarouselItemModel carouselItemModel4;

  @override
  void initState(BuildContext context) {
    carouselItemModel1 = createModel(context, () => CarouselItemModel());
    carouselItemModel2 = createModel(context, () => CarouselItemModel());
    carouselItemModel3 = createModel(context, () => CarouselItemModel());
    carouselItemModel4 = createModel(context, () => CarouselItemModel());
  }

  @override
  void dispose() {
    carouselItemModel1.dispose();
    carouselItemModel2.dispose();
    carouselItemModel3.dispose();
    carouselItemModel4.dispose();
  }
}
