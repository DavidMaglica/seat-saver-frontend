import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/user.dart';
import 'package:seat_saver/api/support_api.dart';
import 'package:seat_saver/utils/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportModel extends ChangeNotifier {
  final int userId;
  final Position? position;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SupportApi supportApi;
  final AccountApi accountApi;

  final FocusNode unfocusNode = FocusNode();
  final FocusNode ticketTitleFocusNode = FocusNode();
  final FocusNode ticketDescriptionFocusNode = FocusNode();

  final TextEditingController ticketTitleController = TextEditingController();
  final TextEditingController ticketDescriptionController =
      TextEditingController();

  late User loggedInUser;

  SupportModel({
    required this.userId,
    this.position,
    SupportApi? supportApi,
    AccountApi? accountApi,
  }) : supportApi = supportApi ?? SupportApi(),
       accountApi = accountApi ?? AccountApi();

  void init(BuildContext context) {
    _getUser(context);
  }

  Future<void> _getUser(BuildContext context) async {
    final response = await accountApi.getUser(userId);
    if (response.success && response.data != null) {
      loggedInUser = response.data!;
    } else {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to load user data.');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    ticketTitleFocusNode.dispose();
    ticketDescriptionFocusNode.dispose();

    ticketTitleController.dispose();
    ticketDescriptionController.dispose();
    super.dispose();
  }

  Future<void> openFAQs(BuildContext context) async {
    final Uri url = Uri.parse('https://flutter.dev');
    try {
      if (!await canLaunchUrl(url)) {
        if (!context.mounted) return;
        Toaster.displayError(
          context,
          'Could not launch default browser app. Please try again later.',
        );
      }
      await launchUrl(url);
    } catch (e) {
      if (!context.mounted) return;
      Toaster.displayError(
        context,
        'Could not open default browser app. Please try again later.',
      );
    }
  }

  Future<void> submitTicket(BuildContext context) async {
    final subject = ticketTitleController.text;
    final body = ticketDescriptionController.text;

    if (subject.isEmpty || body.isEmpty) {
      Toaster.displayError(context, 'Please fill in all fields.');
      return;
    }

    BasicResponse response = await supportApi.sendEmail(
      loggedInUser.email,
      subject,
      body,
    );

    if (!response.success) {
      if (!context.mounted) return;
      Toaster.displayError(context, response.message);
      return;
    } else {
      if (!context.mounted) return;
      Toaster.displaySuccess(context, 'Support ticket submitted successfully.');
    }

    ticketTitleController.clear();
    ticketDescriptionController.clear();
    notifyListeners();
  }
}
