import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

void onNavbarItemTapped(
  BuildContext ctx,
  int pageIndex,
  int index,
  int? userId,
  Position? userLocation,
) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      Navigator.pushNamed(ctx, Routes.homepage,
          arguments: {'userId': userId, 'userLocation': userLocation});
      break;
    case 1:
      Navigator.pushNamed(ctx, Routes.search,
          arguments: {'userId': userId, 'userLocation': userLocation});
      break;
    case 2:
      Navigator.pushNamed(ctx, Routes.nearby,
          arguments: {'userId': userId, 'userLocation': userLocation});
      break;
    case 3:
      Navigator.pushNamed(ctx, Routes.account,
          arguments: {'userId': userId, 'userLocation': userLocation});
      break;
    default:
      break;
  }
}
