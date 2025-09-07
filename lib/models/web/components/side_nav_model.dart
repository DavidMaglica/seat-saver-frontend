import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/theme_provider.dart';

class SideNavModel extends FlutterFlowModel<SideNav> with ChangeNotifier {
  final int ownerId = sharedPreferencesCache.getInt('ownerId')!;

  String ownerEmail = '';
  String ownerName = '';

  @override
  void initState(BuildContext context) {}

  void init() {
    getUserFromCache();
  }

  Future<void> getUserFromCache() async {
    ownerEmail = sharedPreferencesCache.getString('ownerEmail')!;
    ownerName = sharedPreferencesCache.getString('ownerName')!;
    notifyListeners();
  }

  Future<void> goTo(BuildContext context, Widget page, String routeName) async {
    Navigator.of(context).push(FadeInRoute(routeName: routeName, page: page));
  }

  void setDarkModeSetting(BuildContext context, bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleDarkTheme(isDarkMode);
    notifyListeners();
  }
}
