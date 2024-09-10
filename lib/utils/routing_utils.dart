import 'package:flutter/cupertino.dart';

import 'constants.dart';

void onNavbarItemTapped(int pageIndex, int index, BuildContext context, String? email) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      debugPrint('Opening account page with email: $email');
      Navigator.pushNamed(context, Routes.HOMEPAGE, arguments: {'email': email});
      break;
    case 1:
      Navigator.pushNamed(context, Routes.SEARCH);
      break;
    case 2:
      Navigator.pushNamed(context, Routes.NEARBY);
      break;
    case 3:
      debugPrint('Opening account page with email: $email');
      Navigator.pushNamed(context, Routes.ACCOUNT, arguments: {'email': email});
      break;
    default:
      break;
  }
}