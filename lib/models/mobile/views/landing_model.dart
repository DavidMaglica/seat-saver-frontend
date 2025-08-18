import 'package:table_reserver/utils/routes.dart';
import 'package:flutter/material.dart';

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
    Navigator.pushNamed(
      context,
      Routes.homepage,
      arguments: {'userId': ''},
    );
  }
}
