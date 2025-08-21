import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/pages/mobile/views/account.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/pages/mobile/views/nearby.dart';
import 'package:table_reserver/pages/mobile/views/search.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

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
      Navigator.of(ctx).push(
        FadeInRoute(
          page: Homepage(userId: userId, userLocation: userLocation),
          routeName: Routes.homepage,
        ),
      );
      break;
    case 1:
      Navigator.of(ctx).push(
        FadeInRoute(
          page: Search(userId: userId, userLocation: userLocation),
          routeName: Routes.search,
        ),
      );
      break;
    case 2:
      Navigator.of(ctx).push(
        FadeInRoute(
          page: Nearby(userId: userId, userLocation: userLocation),
          routeName: Routes.nearby,
        ),
      );
      break;
    case 3:
      Navigator.of(ctx).push(
        FadeInRoute(
          page: Account(userId: userId, userLocation: userLocation),
          routeName: Routes.account,
        ),
      );
      break;
    default:
      break;
  }
}
