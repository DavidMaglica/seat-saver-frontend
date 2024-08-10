import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../search.dart';

class SearchModel extends FlutterFlowModel<Search> {
  final unfocusNode = FocusNode();

  FormFieldController<List<String>>? choiceChipsValueController;

  List<String>? get choiceChipsValues => choiceChipsValueController?.value;

  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
