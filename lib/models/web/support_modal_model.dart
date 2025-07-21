import 'package:TableReserver/components/web/support_modal.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class SupportModalModel extends FlutterFlowModel<SupportModal> {
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  void initAnimations(TickerProvider ticker) {
    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      ticker,
    );
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    descriptionTextController.dispose();
  }
}
