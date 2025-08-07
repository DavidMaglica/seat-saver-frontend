import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AccountModel extends ChangeNotifier {
  final BuildContext context;
  final int? userId;
  final Position? userLocation;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final int pageIndex = 3;

  User? currentUser;
  final AccountApi accountApi = AccountApi();

  AccountModel({
    required this.context,
    this.userId,
    this.userLocation,
  });

  Future<void> init() async {
    if (userId != null) {
      await _getUser(userId!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _getUser(int userId) async {
    final response = await accountApi.getUser(userId);
    if (response != null && response.success) {
      currentUser = response.user;
      notifyListeners();
    }
  }

  void openSettingsItem(String route, String? action) {
    if (route == Routes.termsOfService) {
      Navigator.pushNamed(context, route,
          arguments: {'userId': currentUser?.id, 'userLocation': userLocation});
      return;
    }
    if (currentUser == null) {
      Toaster.displayInfo(context, 'Please log in to $action.');
      return;
    }
    Navigator.pushNamed(context, route, arguments: {
      'userId': userId,
      'userLocation': userLocation,
    });
  }
}
