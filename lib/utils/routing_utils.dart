import 'package:flutter/cupertino.dart';

void onNavbarItemTapped(int pageIndex, int index, BuildContext context, String? email) {
  if (index == pageIndex) {
    return;
  }
  switch (index) {
    case 0:
      debugPrint('Opening account page with email: $email');
      Navigator.pushNamed(context, '/homepage', arguments: {'email': email});
      break;
    case 1:
      Navigator.pushNamed(context, '/search');
      break;
    case 2:
      Navigator.pushNamed(context, '/nearby');
      break;
    case 3:
      debugPrint('Opening account page with email: $email');
      Navigator.pushNamed(context, '/account', arguments: {'email': email});
      break;
    default:
      break;
  }
}