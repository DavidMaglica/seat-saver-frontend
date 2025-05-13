import 'package:flutter/material.dart';

import '../api/carousel_api.dart';

class CarouselItemModel extends ChangeNotifier {
  final String currentCity;
  final CarouselApi _carouselApi = CarouselApi();

  String? _imageLink;

  String? get imageLink => _imageLink;

  CarouselItemModel(this.currentCity) {
    _loadImage();
  }

  void _loadImage() {
    _imageLink = _carouselApi.getImage(currentCity);
    notifyListeners();
  }
}
