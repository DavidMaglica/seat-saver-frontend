import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../support.dart';

class SupportModel extends FlutterFlowModel<Support> {

  final unfocusNode = FocusNode();

  FocusNode? ticketTitleFocusNode;
  TextEditingController? ticketTitleController;
  String? Function(BuildContext, String?)? ticketTitleValidator;

  FocusNode? ticketDescriptionFocusNode;
  TextEditingController? ticketDescriptionController;
  String? Function(BuildContext, String?)? ticketDescriptionValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    ticketTitleFocusNode?.dispose();
    ticketTitleController?.dispose();

    ticketDescriptionFocusNode?.dispose();
    ticketDescriptionController?.dispose();
  }
}
