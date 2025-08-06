import 'package:table_reserver/components/web/modals/support_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class SupportModalModel extends FlutterFlowModel<SupportModal> {
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    descriptionTextController.dispose();
  }

  Future<void> submitBugReport() async {
    debugPrint('Submitting bug report...');
  }

  Future<void> submitFeatureRequest() async {
    debugPrint('Submitting feature request...');
  }
}
