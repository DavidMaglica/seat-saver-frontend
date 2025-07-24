import 'package:TableReserver/models/web/change_password_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/components/web/modals/modal_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal>
    with TickerProviderStateMixin {
  late ChangePasswordModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChangePasswordModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 670,
            ),
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
                _buildBody(context),
                const SizedBox(height: 8),
                buildButtons(
                  context,
                  _model.changePassword,
                  'Save changes',
                ),
              ],
            ),
          ).animateOnPageLoad(
              _model.animationsMap['containerOnPageLoadAnimation']!),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _model.passwordTextController,
            focusNode: _model.passwordFocusNode,
            obscureText: !_model.passwordVisibility,
            decoration: InputDecoration(
              labelText: 'Enter your current password',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: WebTheme.infoColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(24),
              suffixIcon: InkWell(
                onTap: () => safeSetState(
                  () => _model.passwordVisibility = !_model.passwordVisibility,
                ),
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  _model.passwordVisibility
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _model.newPasswordTextController,
            focusNode: _model.newPasswordFocusNode,
            obscureText: !_model.newPasswordVisibility,
            decoration: InputDecoration(
              labelText: 'Enter your new password',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: WebTheme.infoColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(24),
              suffixIcon: InkWell(
                onTap: () => safeSetState(
                  () => _model.newPasswordVisibility =
                      !_model.newPasswordVisibility,
                ),
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  _model.newPasswordVisibility
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _model.passwordConfirmTextController,
            focusNode: _model.passwordConfirmFocusNode,
            obscureText: !_model.passwordConfirmVisibility,
            decoration: InputDecoration(
              labelText: 'Confirm your new password',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: WebTheme.infoColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(24),
              suffixIcon: InkWell(
                onTap: () => safeSetState(
                  () => _model.passwordConfirmVisibility =
                      !_model.passwordConfirmVisibility,
                ),
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  _model.passwordConfirmVisibility
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
        ),
      ],
    );
  }
}
