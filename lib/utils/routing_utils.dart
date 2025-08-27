import 'package:flutter/cupertino.dart';
import 'package:table_reserver/pages/mobile/views/account.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/pages/mobile/views/nearby.dart';
import 'package:table_reserver/pages/mobile/views/search.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

void onNavbarItemTapped(BuildContext ctx, int pageIndex, int index) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      Navigator.of(ctx).push(
        MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
      );
      break;
    case 1:
      Navigator.of(
        ctx,
      ).push(MobileFadeInRoute(page: const Search(), routeName: Routes.search));
      break;
    case 2:
      Navigator.of(
        ctx,
      ).push(MobileFadeInRoute(page: const Nearby(), routeName: Routes.nearby));
      break;
    case 3:
      Navigator.of(ctx).push(
        MobileFadeInRoute(page: const Account(), routeName: Routes.account),
      );
      break;
    default:
      break;
  }
}
