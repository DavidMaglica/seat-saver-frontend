import 'package:TableReserver/components/web/side_nav.dart';
import 'package:TableReserver/utils/fade_in_route.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class SideNavModel extends FlutterFlowModel<SideNav> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> goTo(BuildContext ctx, Widget page, String routeName) async {
    Navigator.of(ctx).push(
      FadeInRoute(
        routeName: routeName,
        page: page,
      ),
    );
  }

  void setDarkModeSetting(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    if (isDarkMode) {
      // TODO implement with store management
      // theme.setThemeMode(ThemeMode.dark);
    } else {
      // theme.setThemeMode(ThemeMode.light);
    }
  }
}
