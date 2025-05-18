import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'constants.dart';

void onNavbarItemTapped(
  BuildContext ctx,
  int pageIndex,
  int index,
  String? userEmail,
  Position? userLocation,
) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      Navigator.pushNamed(ctx, Routes.homepage,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 1:
      Navigator.pushNamed(ctx, Routes.search,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 2:
      Navigator.pushNamed(ctx, Routes.nearby,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    case 3:
      Navigator.pushNamed(ctx, Routes.account,
          arguments: {'userEmail': userEmail, 'userLocation': userLocation});
      break;
    default:
      break;
  }
}
