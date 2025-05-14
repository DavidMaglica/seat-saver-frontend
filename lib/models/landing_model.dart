 import 'package:flutter/material.dart';

import '../utils/constants.dart';

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
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;
    Navigator.pushNamed(
      context,
      Routes.HOMEPAGE,
      arguments: {'userEmail': ''},
    );
  }
}
