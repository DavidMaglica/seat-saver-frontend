import 'package:diplomski/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'models/suggested_object_model.dart';
import 'suggested_item.dart';

export 'models/suggested_object_model.dart';

class SuggestedObject extends StatefulWidget {
  const SuggestedObject({super.key});

  @override
  State<SuggestedObject> createState() => _SuggestedObjectState();
}

class _SuggestedObjectState extends State<SuggestedObject> {
  late SuggestedObjectModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuggestedObjectModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 296,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We suggest',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              color: AppThemes.accent1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 24, 0),
                            child: wrapWithModel(
                              model: _model.suggestedItemModel1,
                              updateCallback: () => setState(() {}),
                              child: const SuggestedItem(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 24, 0),
                            child: wrapWithModel(
                              model: _model.suggestedItemModel2,
                              updateCallback: () => setState(() {}),
                              child: const SuggestedItem(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 24, 0),
                            child: wrapWithModel(
                              model: _model.suggestedItemModel3,
                              updateCallback: () => setState(() {}),
                              child: const SuggestedItem(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 24, 0),
                            child: wrapWithModel(
                              model: _model.suggestedItemModel4,
                              updateCallback: () => setState(() {}),
                              child: const SuggestedItem(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 24, 0),
                            child: wrapWithModel(
                              model: _model.suggestedItemModel5,
                              updateCallback: () => setState(() {}),
                              child: const SuggestedItem(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
