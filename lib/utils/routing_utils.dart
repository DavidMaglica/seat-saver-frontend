import 'package:flutter/cupertino.dart';

void onNavbarItemTapped(int pageIndex, int index, BuildContext context) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/homepage');
      break;
    case 1:
      Navigator.pushNamed(context, '/search');
      break;
    case 2:
      Navigator.pushNamed(context, '/nearby');
      break;
    case 3:
      Navigator.pushNamed(context, '/account');
      break;
    default:
      break;
  }
}