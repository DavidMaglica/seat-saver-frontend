import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/utils/animations.dart';

class GraphsPageModel extends ChangeNotifier {
  final Map<String, AnimationInfo> animationsMap =
      Animations.utilityPagesAnimations;

  bool isMonthly = false;

  void toggleGraphType(bool value) {
    isMonthly = value;
    notifyListeners();
  }
}
