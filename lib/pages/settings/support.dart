import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/data/user.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import 'utils/settings_utils.dart';

class Support extends StatefulWidget {
  final User user;
  final Position? userLocation;

  const Support({
    Key? key,
    required this.user,
    this.userLocation,
  }) : super(key: key);

  @override
  State<Support> createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<Support> with TickerProviderStateMixin {
  final _unfocusNode = FocusNode();
  FocusNode? _ticketTitleFocusNode;
  TextEditingController? _ticketTitleController;

  FocusNode? _ticketDescriptionFocusNode;
  TextEditingController? _ticketDescriptionController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();

    _ticketTitleFocusNode?.dispose();
    _ticketTitleController?.dispose();

    _ticketDescriptionFocusNode?.dispose();
    _ticketDescriptionController?.dispose();

    super.dispose();
  }

  void _submitTicket() => debugPrint('Submit ticket');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppbar(
            title: 'Support',
            routeToPush: Routes.ACCOUNT,
            args: {
              'userEmail': widget.user.email,
              'userLocation': widget.userLocation
            }),
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
                          _ticketTitleController,
                          _ticketTitleFocusNode,
                          'Ticket title',
                          'Enter a title for your ticket.',
                          null,
                          null,
                        ),
                        _buildInputField(
                          _ticketDescriptionController,
                          _ticketDescriptionFocusNode,
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

  Padding _buildBanner(
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

  TextFormField _buildInputField(
    TextEditingController? controller,
    FocusNode? focusNode,
    String labelText,
    String hintText,
    int? maxLines,
    int? minLines,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          hintText: hintText,
          enabledBorder:
              outlineInputBorder(Theme.of(context).colorScheme.onPrimary),
          focusedBorder: outlineInputBorder(AppThemes.infoColor),
          errorBorder: outlineInputBorder(Theme.of(context).colorScheme.error),
          focusedErrorBorder: outlineInputBorder(AppThemes.infoColor),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: maxLines,
        minLines: minLines,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );
}
