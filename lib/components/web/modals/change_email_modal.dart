import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/modals/change_email_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class ChangeEmailModal extends StatefulWidget {
  const ChangeEmailModal({super.key});

  @override
  State<ChangeEmailModal> createState() => _ChangeEmailModalState();
}

class _ChangeEmailModalState extends State<ChangeEmailModal>
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
      create: (_) => ChangeEmailModel(),
      child: Consumer<ChangeEmailModel>(
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
                      buildTitle(context, 'Change Email'),
                      const SizedBox(height: 16),
                      _buildBody(context, model),
                      const SizedBox(height: 8),
                      buildButtons(
                        context,
                        () => model.updateEmail(context),
                        'Change Email',
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

  Widget _buildBody(BuildContext context, ChangeEmailModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: model.emailTextController,
            focusNode: model.emailFocusNode,
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Enter your new email',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              errorText: model.emailErrorText,
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
            keyboardType: TextInputType.emailAddress,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
