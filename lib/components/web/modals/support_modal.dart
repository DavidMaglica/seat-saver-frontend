import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/views/support_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class SupportModal extends StatefulWidget {
  const SupportModal({super.key, required this.modalType});

  final SupportModalType modalType;

  @override
  State<SupportModal> createState() => _SupportModalState();
}

class _SupportModalState extends State<SupportModal>
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
      create: (_) => WebSupportModel(),
      child: Consumer<WebSupportModel>(
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
                      buildTitle(
                        context,
                        widget.modalType == SupportModalType.bugReport
                            ? 'Submit a bug'
                            : 'Request a feature',
                      ),
                      const SizedBox(height: 16),
                      _buildBody(context, model),
                      const SizedBox(height: 8),
                      buildButtons(
                        context,
                        widget.modalType == SupportModalType.bugReport
                            ? () => model.submitBugReport(context)
                            : () => model.submitFeatureRequest(context),
                        widget.modalType == SupportModalType.bugReport
                            ? 'Submit bug'
                            : 'Request feature',
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

  Widget _buildBody(BuildContext context, WebSupportModel model) {
    String titleLabel = widget.modalType == SupportModalType.bugReport
        ? 'Bug title (short & clear)'
        : 'Feature title (short & clear)';
    String descriptionLabel = widget.modalType == SupportModalType.bugReport
        ? 'Describe the bug in as much detail as possible'
        : 'Describe new feature in as much detail as possible';

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          context,
          model,
          model.titleTextController,
          model.titleFocusNode,
          titleLabel,
          model.titleErrorText,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          context,
          model,
          model.descriptionTextController,
          model.descriptionFocusNode,
          descriptionLabel,
          model.descriptionErrorText,
          minLines: 6,
          maxLines: 16,
        ),
      ],
    );
  }

  Padding _buildInputField(
    BuildContext context,
    WebSupportModel model,
    TextEditingController controller,
    FocusNode focusNode,
    String labelText,
    String? errorText, {
    int? minLines,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: errorText,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: maxLines,
        minLines: minLines,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
