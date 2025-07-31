import 'package:TableReserver/components/web/modals/change_email_modal.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ChangeEmailModel extends FlutterFlowModel<ChangeEmailModal> {
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode.dispose();
    emailTextController.dispose();
  }

  void closeModal(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> updateEmail() async {
    debugPrint('Changing email...');
  }
}
