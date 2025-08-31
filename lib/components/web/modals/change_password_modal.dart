import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/modals/change_password_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal>
    with TickerProviderStateMixin {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordModel(),
      child: Consumer<ChangePasswordModel>(
        builder: (context, model, _) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 670),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(context, 'Change Password'),
                      const SizedBox(height: 16),
                      _buildBody(context, model),
                      const SizedBox(height: 8),
                      buildButtons(
                        context,
                        () => model.changePassword(context),
                        'Save changes',
                      ),
                    ],
                  ),
                ).animateOnPageLoad(model.animationsMap['modalOnLoad']!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChangePasswordModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildNewPasswordField(context, model),
        const SizedBox(height: 16),
        _buildConfirmPasswordField(context, model),
      ],
    );
  }

  Widget _buildNewPasswordField(
    BuildContext context,
    ChangePasswordModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: model.newPasswordTextController,
        focusNode: model.newPasswordFocusNode,
        obscureText: !model.newPasswordVisibility,
        decoration: InputDecoration(
          labelText: 'Enter your new password',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.newPasswordErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.all(24),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => model.newPasswordVisibility = !model.newPasswordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              model.newPasswordVisibility
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildConfirmPasswordField(
    BuildContext context,
    ChangePasswordModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: model.confirmPasswordTextController,
        focusNode: model.confirmPasswordFocusNode,
        obscureText: !model.confirmPasswordVisibility,
        decoration: InputDecoration(
          labelText: 'Confirm your new password',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.confirmPasswordErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.all(24),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => model.confirmPasswordVisibility =
                  !model.confirmPasswordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              model.confirmPasswordVisibility
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
