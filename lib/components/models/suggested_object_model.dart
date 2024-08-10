import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../suggested_object.dart';
import 'suggested_item_model.dart';

class SuggestedObjectModel extends FlutterFlowModel<SuggestedObject> {

  late SuggestedItemModel suggestedItemModel1;

  late SuggestedItemModel suggestedItemModel2;

  late SuggestedItemModel suggestedItemModel3;

  late SuggestedItemModel suggestedItemModel4;

  late SuggestedItemModel suggestedItemModel5;

  @override
  void initState(BuildContext context) {
    suggestedItemModel1 = createModel(context, () => SuggestedItemModel());
    suggestedItemModel2 = createModel(context, () => SuggestedItemModel());
    suggestedItemModel3 = createModel(context, () => SuggestedItemModel());
    suggestedItemModel4 = createModel(context, () => SuggestedItemModel());
    suggestedItemModel5 = createModel(context, () => SuggestedItemModel());
  }

  @override
  void dispose() {
    suggestedItemModel1.dispose();
    suggestedItemModel2.dispose();
    suggestedItemModel3.dispose();
    suggestedItemModel4.dispose();
    suggestedItemModel5.dispose();
  }
}
