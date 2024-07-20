import 'dart:developer';

import 'package:localstore/localstore.dart';

final localstore = Localstore.instance;

final CURRENT_CITY_ID = 'currentCityID';

Future<String?> loadCity() async {
  final data = await localstore.collection('currentCity').doc(CURRENT_CITY_ID).get();

  if (data != null) {
    log('Loaded city: ${data.values.first} from localstore', level: 1);
    return data.values.first;
  }else {
    return null;
  }
}

void saveCity(String city) {
  log('Setting city: $city to localstore', level: 1);

  localstore
      .collection('currentCity')
      .doc(CURRENT_CITY_ID)
      .set({'currentCity': city});
}
