import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'constants.dart';

void onNavbarItemTapped(int pageIndex, int index, BuildContext context,
    String? userEmail, Position? userLocation) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      debugPrint('Opening homepage with args: $userEmail, $userLocation');
      Navigator.pushNamed(context, Routes.HOMEPAGE,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 1:
      debugPrint('Opening search with args: $userEmail, $userLocation');
      Navigator.pushNamed(context, Routes.SEARCH,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 2:
      debugPrint('Opening nearby with args: $userEmail, $userLocation');
      Navigator.pushNamed(context, Routes.NEARBY,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 3:
      debugPrint('Opening account page with args: $userEmail, $userLocation');
      Navigator.pushNamed(context, Routes.ACCOUNT,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    default:
      break;
  }
}
