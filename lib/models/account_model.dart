import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/account_api.dart';
import '../api/data/user.dart';
import '../components/toaster.dart';
import '../utils/constants.dart';

class AccountModel extends ChangeNotifier {
  final String? userEmail;
  final Position? userLocation;
  final BuildContext context;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final int pageIndex = 3;

  User? user;
  final AccountApi accountApi = AccountApi();

  AccountModel({
    required this.context,
    this.userEmail,
    this.userLocation,
  });

  Future<void> init() async {
    if (userEmail != null && userEmail!.isNotEmpty) {
      await _getUserByEmail(userEmail!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUserByEmail(String email) async {
    final response = await accountApi.getUser(email);
    if (response != null && response.success) {
      user = response.user;
      notifyListeners();
    }
  }

  void openSettingsItem(String route, String? action) {
    if (route == Routes.TERMS_OF_SERVICE) {
      Navigator.pushNamed(context, route,
          arguments: {'userEmail': user?.email, 'userLocation': userLocation});
      return;
    }
    if (user == null) {
      Toaster.displayInfo(context, 'Please log in to $action.');
      return;
    }
    Navigator.pushNamed(context, route, arguments: {
      'user': user,
      'userLocation': userLocation,
    });
  }
}
