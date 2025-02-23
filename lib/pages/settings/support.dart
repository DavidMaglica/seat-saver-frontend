import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/data/user.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/toaster.dart';
import 'utils/banner.dart';
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

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'dmaglica@unipu.hr');
    debugPrint('url: $emailLaunchUri');
    try {
      if (!await canLaunchUrl(emailLaunchUri)) {
        if (!mounted) return;
        Toaster.displayError(context,
            'Could not launch default browser app. Please try again later.');
      }
      await launchUrl(emailLaunchUri);
    } catch (e) {
      if (!mounted) return;
      Toaster.displayError(context,
          'Could not open default browser app. Please try again later.');
    }
  }

  void _openFAQs() async {
    final Uri url = Uri.parse('https://flutter.dev');
    try {
      if (!await canLaunchUrl(url)) {
        if (!mounted) return;
        Toaster.displayError(context,
            'Could not launch default browser app. Please try again later.');
      }
      await launchUrl(url);
    } catch (e) {
      if (!mounted) return;
      Toaster.displayError(context,
          'Could not open default browser app. Please try again later.');
    }
  }

  Future<void> _submitTicket(String subject, String body) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'dmaglica@unipu.hr',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    debugPrint('url: $emailLaunchUri');
    try {
      if (!await canLaunchUrl(emailLaunchUri)) {
        if (!mounted) return;
        Toaster.displayError(context,
            'Could not launch default browser app. Please try again later.');
      }
      await launchUrl(emailLaunchUri);
    } catch (e) {
      if (!mounted) return;
      Toaster.displayError(context,
          'Could not open default browser app. Please try again later.');
    }
  }

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
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 24),
                    child: Text(
                      'Have you encountered an issue with the application? Click on the buttons below to contact us or search for answers in our FAQs.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async => _sendEmail(),
                          child: SupportBanner(
                            context: context,
                            title: 'Email Us',
                            icon: CupertinoIcons.mail_solid,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _openFAQs(),
                          child: SupportBanner(
                            context: context,
                            title: 'Search FAQs',
                            icon: CupertinoIcons.search_circle_fill,
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 12)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            thickness: 1,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 8),
                          child: Text('Submit a Ticket',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
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
                  ActionButton(
                      title: 'Submit Ticket',
                      onPressed: () => _submitTicket(
                            _ticketTitleController.text,
                            _ticketDescriptionController.text,
                          ),
                      iconData: CupertinoIcons.paperplane_fill),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
