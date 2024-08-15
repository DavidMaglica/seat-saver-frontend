import 'package:diplomski/pages/settings/utils/settings_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';
import 'models/support_model.dart';

export 'models/support_model.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<Support> with TickerProviderStateMixin {
  late SupportModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportModel());

    _model.ticketTitleController ??= TextEditingController();
    _model.ticketTitleFocusNode ??= FocusNode();

    _model.ticketDescriptionController ??= TextEditingController();
    _model.ticketDescriptionFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _submitTicket() => debugPrint('Submit ticket');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppbar(title: 'Support'),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to our support center',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text('Submit a Ticket',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: _buildBanner(
                              'Email Us', CupertinoIcons.mail_solid)),
                      Expanded(
                        child: _buildBanner(
                            'Search FAQs', CupertinoIcons.search_circle_fill),
                      ),
                    ].divide(const SizedBox(width: 12)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _buildInputField(
                          _model.ticketTitleController,
                          _model.ticketTitleFocusNode,
                          _model.ticketTitleValidator,
                          'Ticket title',
                          'Enter a title for your ticket.',
                          null,
                          null,
                        ),
                        _buildInputField(
                          _model.ticketDescriptionController,
                          _model.ticketDescriptionFocusNode,
                          _model.ticketDescriptionValidator,
                          'Short description',
                          'Short description of what is going on...',
                          16,
                          6,
                        ),
                      ].divide(const SizedBox(height: 12)),
                    ),
                  ),
                  buildActionButton(context, 'Submit Ticket', _submitTicket,
                      CupertinoIcons.paperplane_fill),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(
    String title,
    IconData icon,
  ) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
        child: Container(
          width: 120,
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildInputField(
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
    String labelText,
    String hintText,
    int? maxLines,
    int? minLines,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: maxLines,
        minLines: minLines,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        validator: validator.asValidator(context),
      );
}
