import 'package:TableReserver/models/web/support_modal_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

enum ModalTypes {
  featureRequest,
  bugReport,
}

class SupportModal extends StatefulWidget {
  const SupportModal({super.key, required this.modalType});

  final ModalTypes modalType;

  @override
  State<SupportModal> createState() => _SupportModalState();
}

class _SupportModalState extends State<SupportModal>
    with TickerProviderStateMixin {
  late SupportModalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportModalModel());
    _model.initAnimations(this);
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
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
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
                  _buildTitle(context),
                  const SizedBox(height: 16),
                  _buildBody(context),
                  const SizedBox(height: 32),
                  _buildButtons(context),
                ],
              ),
            ).animateOnPageLoad(
                _model.animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16),
      child: Text(
        widget.modalType == ModalTypes.bugReport
            ? 'Submit a bug'
            : 'Request a feature',
        style: Theme.of(context).textTheme.titleLarge,
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
            controller: _model.descriptionTextController,
            focusNode: _model.descriptionFocusNode,
            obscureText: false,
            decoration: InputDecoration(
              labelText: widget.modalType == ModalTypes.bugReport
                  ? 'Describe the bug'
                  : 'Describe new feature in as much detail as possible',
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
            maxLines: null,
            minLines: 1,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'The user associated with this account is:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'username',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 2),
              Text(
                'user@email.com',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FFButtonWidget(
            onPressed: () async {
              Navigator.pop(context);
            },
            text: 'Cancel',
            options: FFButtonOptions(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              color: WebTheme.errorColor,
              textStyle: const TextStyle(
                color: Color(0xFFFFFBF4),
                fontFamily: 'Oswald',
                fontSize: 18,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          FFButtonWidget(
            onPressed: () {
              debugPrint('Button pressed ...');
            },
            text: widget.modalType == ModalTypes.bugReport
                ? 'Submit bug'
                : 'Request feature',
            options: FFButtonOptions(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              color: WebTheme.successColor,
              textStyle: const TextStyle(
                color: Color(0xFFFFFBF4),
                fontFamily: 'Oswald',
                fontSize: 18,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
