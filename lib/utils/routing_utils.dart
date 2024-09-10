import 'package:flutter/cupertino.dart';

import 'constants.dart';

void onNavbarItemTapped(int pageIndex, int index, BuildContext context, String? userEmail) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      debugPrint('Opening homepage with email: $userEmail');
      Navigator.pushNamed(context, Routes.HOMEPAGE, arguments: {'userEmail': userEmail});
      break;
    case 1:
      debugPrint('Opening search with email: $userEmail');
      Navigator.pushNamed(context, Routes.SEARCH, arguments: {'userEmail': userEmail});
      break;
    case 2:
      debugPrint('Opening nearby with email: $userEmail');
      Navigator.pushNamed(context, Routes.NEARBY, arguments: {'userEmail': userEmail});
      break;
    case 3:
      debugPrint('Opening account page with email: $userEmail');
      Navigator.pushNamed(context, Routes.ACCOUNT, arguments: {'userEmail': userEmail});
      break;
    default:
      break;
  }
}