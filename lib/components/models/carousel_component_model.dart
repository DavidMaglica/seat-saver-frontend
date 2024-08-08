import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../carousel_component.dart';
import 'carouse_item_model.dart';

class CarouselComponentModel extends FlutterFlowModel<CarouselComponent> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselController? carouselController;
  int carouselCurrentIndex = 1;

  // Model for CarouselItem component.
  late CarouselItemModel carouselItemModel1;

  // Model for CarouselItem component.
  late CarouselItemModel carouselItemModel2;

  // Model for CarouselItem component.
  late CarouselItemModel carouselItemModel3;

  // Model for CarouselItem component.
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
