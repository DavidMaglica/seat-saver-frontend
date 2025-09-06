import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/components/web/modals/change_username_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class ChangeUsernameModel extends FlutterFlowModel<ChangeUsernameModal>
    with ChangeNotifier {
  FocusNode usernameFocusNode = FocusNode();
  TextEditingController usernameTextController = TextEditingController();
  String? usernameErrorText;

  final AccountApi accountApi = AccountApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    usernameFocusNode.dispose();
    usernameTextController.dispose();
  }

  void closeModal(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> updateUsername(BuildContext context) async {
    final String newUsername = usernameTextController.text.trim();
    final String currentUsername = sharedPreferencesCache.getString(
      'userName',
    )!;

    if (!isValidUsername(newUsername, currentUsername)) {
      notifyListeners();
      return;
    }

    usernameErrorText = null;

    final int ownerId = sharedPreferencesCache.getInt('ownerId')!;

    final BasicResponse response = await accountApi.changeUsername(
      ownerId,
      newUsername,
    );

    if (response.success) {
      if (!context.mounted) return;

      sharedPreferencesCache.setString('ownerName', newUsername);

      usernameTextController.clear();
      WebToaster.displaySuccess(context, response.message);

      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }

    notifyListeners();
  }

  bool isValidUsername(String newUsername, String currentUsername) {
    if (newUsername.isEmpty) {
      usernameErrorText = 'Username cannot be empty';
      return false;
    }
    if (newUsername == currentUsername) {
      usernameErrorText = 'New username cannot be the same as the current one';
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9_ ]+$').hasMatch(newUsername)) {
      usernameErrorText =
          'Username can only contain letters, numbers, and underscores';
      return false;
    }
    return true;
  }
}
