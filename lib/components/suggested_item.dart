import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../themes/theme.dart';
import 'models/suggested_item_model.dart';

export 'models/suggested_item_model.dart';

class SuggestedItem extends StatefulWidget {
  const SuggestedItem({super.key});

  @override
  State<SuggestedItem> createState() => _SuggestedItemState();
}

class _SuggestedItemState extends State<SuggestedItem> {
  late SuggestedItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuggestedItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          // context.pushNamed('ObjectPage');
        },
        child: Container(
          width: 256,
          height: 212,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: .3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Hero(
                tag: 'suggestedItemImage${randomDouble(0, 100)}',
                transitionOnUserGestures: true,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1528114039593-4366cc08227d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8aXRhbHl8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                    width: double.infinity,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Giardino Bardini',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                              )),
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Firenze',
                                    style: TextStyle(
                                      color: AppThemes.accent1,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => const Icon(
                                    CupertinoIcons.star_fill,
                                    color: AppThemes.warningColor,
                                  ),
                                  direction: Axis.horizontal,
                                  rating: 4,
                                  unratedColor: const Color(0xFF57636C),
                                  itemCount: 5,
                                  itemSize: 14,
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 2, 0, 0),
                                  child: Text('4★',
                                      style: TextStyle(
                                        color: Color(0xFF14181B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
