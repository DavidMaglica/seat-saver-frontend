import 'package:flutter/cupertino.dart';
import 'package:seat_saver/pages/mobile/views/account.dart';
import 'package:seat_saver/pages/mobile/views/homepage.dart';
import 'package:seat_saver/pages/mobile/views/nearby.dart';
import 'package:seat_saver/pages/mobile/views/search.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';

void onNavbarItemTapped(BuildContext context, int pageIndex, int index) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      Navigator.of(context).push(
        MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
      );
      break;
    case 1:
      Navigator.of(
        context,
      ).push(MobileFadeInRoute(page: const Search(), routeName: Routes.search));
      break;
    case 2:
      Navigator.of(
        context,
      ).push(MobileFadeInRoute(page: const Nearby(), routeName: Routes.nearby));
      break;
    case 3:
      Navigator.of(context).push(
        MobileFadeInRoute(page: const Account(), routeName: Routes.account),
      );
      break;
    default:
      break;
  }
}
