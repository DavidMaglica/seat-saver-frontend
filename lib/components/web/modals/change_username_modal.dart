import 'package:table_reserver/models/web/change_username_model.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ChangeUsernameModal extends StatefulWidget {
  const ChangeUsernameModal({super.key});

  @override
  State<ChangeUsernameModal> createState() => _ChangeUsernameModalState();
}

class _ChangeUsernameModalState extends State<ChangeUsernameModal>
    with TickerProviderStateMixin {
  late ChangeUsernameModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChangeUsernameModel());
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
                buildTitle(context, 'Change Username'),
                const SizedBox(height: 16),
                _buildBody(context),
                const SizedBox(height: 8),
                buildButtons(
                  context,
                  _model.updateUsername,
                  'Change Username',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _model.emailTextController,
            focusNode: _model.emailFocusNode,
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Enter your new username',
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            minLines: 1,
            keyboardType: TextInputType.name,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
