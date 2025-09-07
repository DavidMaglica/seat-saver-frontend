import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/support_api.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/components/web/modals/support_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class WebSupportModel extends FlutterFlowModel<SupportModal>
    with ChangeNotifier {
  FocusNode titleFocusNode = FocusNode();
  TextEditingController titleTextController = TextEditingController();
  String? titleErrorText;

  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();
  String? descriptionErrorText;

  final SupportApi accountApi = SupportApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();

    titleFocusNode.dispose();
    titleTextController.dispose();

    descriptionFocusNode.dispose();
    descriptionTextController.dispose();
  }

  Future<void> submitBugReport(BuildContext context) async {
    final String title = titleTextController.text.trim();
    final String description = descriptionTextController.text.trim();

    if (!isValid(title, description, SupportModalType.bugReport)) {
      notifyListeners();
      return;
    }

    final String userEmail = sharedPreferencesCache.getString('ownerEmail')!;

    final BasicResponse response = await accountApi.sendEmail(
      userEmail,
      'Bug report - $title',
      description,
    );

    if (response.success) {
      if (!context.mounted) return;

      titleTextController.clear();
      descriptionTextController.clear();
      WebToaster.displaySuccess(context, 'Bug report submitted successfully.');

      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }

    notifyListeners();
  }

  Future<void> submitFeatureRequest(BuildContext context) async {
    final String title = titleTextController.text.trim();
    final String description = descriptionTextController.text.trim();

    if (!isValid(title, description, SupportModalType.featureRequest)) {
      notifyListeners();
      return;
    }

    final String userEmail = sharedPreferencesCache.getString('ownerEmail')!;
    final BasicResponse response = await accountApi.sendEmail(
      userEmail,
      'Feature Request - $title',
      description,
    );

    if (response.success) {
      if (!context.mounted) return;

      titleTextController.clear();
      descriptionTextController.clear();
      WebToaster.displaySuccess(
        context,
        'Feature request submitted successfully.',
      );

      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }

    notifyListeners();
  }

  bool isValid(String title, String description, SupportModalType type) {
    if (title.isEmpty) {
      titleErrorText = type == SupportModalType.bugReport
          ? 'Please provide a title for the bug.'
          : 'Please provide a title for the feature request.';
      return false;
    }
    if (title.length < 5 || title.length > 50) {
      titleErrorText = 'Title must be between 5 and 50 characters long.';
      return false;
    }

    if (description.isEmpty) {
      descriptionErrorText = type == SupportModalType.bugReport
          ? 'Please describe the bug.'
          : 'Please describe the feature request.';
      return false;
    }

    titleErrorText = null;
    descriptionErrorText = null;
    return true;
  }
}
