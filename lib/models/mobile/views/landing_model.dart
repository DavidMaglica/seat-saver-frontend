import 'package:flutter/material.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class LandingModel extends ChangeNotifier {
  final BuildContext context;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();

  LandingModel({required this.context});

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> sendToMainPage() async {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
    );
  }
}
