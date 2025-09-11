import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/components/web/modals/modal_widgets.dart';
import 'package:seat_saver/models/web/modals/change_username_model.dart';
import 'package:seat_saver/themes/web_theme.dart';

class ChangeUsernameModal extends StatefulWidget {
  const ChangeUsernameModal({super.key});

  @override
  State<ChangeUsernameModal> createState() => _ChangeUsernameModalState();
}

class _ChangeUsernameModalState extends State<ChangeUsernameModal>
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
      create: (_) => ChangeUsernameModel(),
      child: Consumer<ChangeUsernameModel>(
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
                      buildTitle(context, 'Change Username'),
                      const SizedBox(height: 16),
                      _buildBody(context, model),
                      const SizedBox(height: 8),
                      buildButtons(
                        context,
                        () => model.updateUsername(context),
                        'Change Username',
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

  Widget _buildBody(BuildContext context, ChangeUsernameModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: model.usernameTextController,
            focusNode: model.usernameFocusNode,
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Enter your new username',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              errorText: model.usernameErrorText,
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
                borderSide: const BorderSide(
                  color: WebTheme.infoColor,
                  width: 1,
                ),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
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
