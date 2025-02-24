class CarouselApi {
  final List<String> mockedCities = [
    'Pula',
    'Umag',
    'Novigrad',
    'Labin',
    'Rovinj',
  ];

  Map<String, String> imagesStore = {
    'Pula': 'assets/images/carousel/pula.jpg',
    'Umag': 'assets/images/carousel/umag.jpg',
    'Novigrad': 'assets/images/carousel/novigrad.jpg',
    'Labin': 'assets/images/carousel/labin.jpg',
    'Rovinj': 'assets/images/carousel/rovinj.jpg',
  };

  String getImage(String city) {
    String placeholder = 'assets/images/carousel/placeholder.jpg';
    if (imagesStore.containsKey(city)) {
      return imagesStore[city]!;
    } else {
      return placeholder;
    }
  }
}
