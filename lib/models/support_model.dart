import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/data/basic_response.dart';
import '../api/data/user.dart';
import '../api/support_api.dart';
import '../components/toaster.dart';

class SupportModel extends ChangeNotifier {
  final BuildContext context;
  final User user;
  final Position? position;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SupportApi emailSender = SupportApi();

  final FocusNode unfocusNode = FocusNode();
  final FocusNode ticketTitleFocusNode = FocusNode();
  final FocusNode ticketDescriptionFocusNode = FocusNode();

  final TextEditingController ticketTitleController = TextEditingController();
  final TextEditingController ticketDescriptionController = TextEditingController();

  SupportModel({
    required this.context,
    required this.user,
    this.position,
  });

  @override
  void dispose() {
    unfocusNode.dispose();
    ticketTitleFocusNode.dispose();
    ticketDescriptionFocusNode.dispose();

    ticketTitleController.dispose();
    ticketDescriptionController.dispose();
    super.dispose();
  }

  Future<void> openFAQs() async {
    final Uri url = Uri.parse('https://flutter.dev');
    try {
      if (!await canLaunchUrl(url)) {
        if (!context.mounted) return;
        Toaster.displayError(context, 'Could not launch default browser app. Please try again later.');
      }
      await launchUrl(url);
    } catch (e) {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Could not open default browser app. Please try again later.');
    }
  }

  Future<void> submitTicket() async {
    final subject = ticketTitleController.text;
    final body = ticketDescriptionController.text;

    if (subject.isEmpty || body.isEmpty) {
      Toaster.displayError(context, 'Please fill in all fields.');
      return;
    }

    BasicResponse response = await emailSender.sendEmail(
      user.email,
      subject,
      body,
    );

    if (!response.success) {
      if (!context.mounted) return;
      Toaster.displayError(context, response.message);
      return;
    }

    ticketTitleController.clear();
    ticketDescriptionController.clear();
    notifyListeners();
  }
}