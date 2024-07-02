import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'carousel_item.dart';
import 'models/carousel_component_model.dart';

export 'models/carousel_component_model.dart';

class CarouselComponent extends StatefulWidget {
  final String? currentCity;

  const CarouselComponent(this.currentCity, {super.key});

  @override
  State<CarouselComponent> createState() => _CarouselComponentState();
}

class _CarouselComponentState extends State<CarouselComponent> {
  late CarouselComponentModel _model;


  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: SizedBox(
              width: double.infinity,
              height: 196,
              child: CarouselSlider(
                items: [
                  wrapWithModel(
                    model: _model.carouselItemModel1,
                    updateCallback: () => setState(() {}),
                    child: CarouselItem(widget.currentCity ?? 'Zagreb'),
                  ),
                  wrapWithModel(
                    model: _model.carouselItemModel2,
                    updateCallback: () => setState(() {}),
                    child: CarouselItem(widget.currentCity ?? 'Zagreb'),
                  ),
                  wrapWithModel(
                    model: _model.carouselItemModel3,
                    updateCallback: () => setState(() {}),
                    child: CarouselItem(widget.currentCity ?? 'Zagreb'),
                  ),
                  wrapWithModel(
                    model: _model.carouselItemModel4,
                    updateCallback: () => setState(() {}),
                    child: CarouselItem(widget.currentCity ?? 'Zagreb'),
                  ),
                ],
                carouselController: _model.carouselController ??=
                    CarouselController(),
                options: CarouselOptions(
                  initialPage: 1,
                  viewportFraction: 0.75,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayInterval: const Duration(milliseconds: (800 + 4000)),
                  autoPlayCurve: Curves.linear,
                  pauseAutoPlayInFiniteScroll: true,
                  onPageChanged: (index, _) =>
                      _model.carouselCurrentIndex = index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
