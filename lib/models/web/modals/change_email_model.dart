import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/components/web/modals/change_email_modal.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/utils/animations.dart';
import 'package:seat_saver/utils/web_toaster.dart';

class ChangeEmailModel extends FlutterFlowModel<ChangeEmailModal>
    with ChangeNotifier {
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailTextController = TextEditingController();
  String? emailErrorText;

  final AccountApi accountApi = AccountApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    emailTextController.dispose();
  }

  void closeModal(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> updateEmail(BuildContext context) async {
    final String newEmail = emailTextController.text.trim();
    final String currentEmail = sharedPreferencesCache.getString('ownerEmail')!;

    if (!isValidEmail(newEmail, currentEmail)) {
      notifyListeners();
      return;
    }

    emailErrorText = null;

    final int ownerId = sharedPreferencesCache.getInt('ownerId')!;

    final BasicResponse response = await accountApi.changeEmail(
      ownerId,
      newEmail,
    );

    if (response.success) {
      if (!context.mounted) return;

      sharedPreferencesCache.setString('ownerEmail', newEmail);

      emailTextController.clear();
      WebToaster.displaySuccess(context, response.message);

      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }

    notifyListeners();
  }

  bool isValidEmail(String newEmail, String currentEmail) {
    if (newEmail.isEmpty) {
      emailErrorText = 'Email cannot be empty';
      return false;
    } else if (newEmail == currentEmail) {
      emailErrorText = 'New email cannot be the same as the current email';
      return false;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(newEmail)) {
      emailErrorText = 'Invalid email format';
      return false;
    }
    return true;
  }
}
