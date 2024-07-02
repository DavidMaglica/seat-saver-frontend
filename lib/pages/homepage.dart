import 'package:diplomski/components/carousel_component.dart';
import 'package:diplomski/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../components/category_card.dart';
import '../components/location_card.dart';
import '../components/location_permission.dart';
import '../components/suggested_object.dart';
import '../theme.dart';
import 'models/homepage_model.dart';

export 'models/homepage_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomepageModel _model;
  String? _currentCity;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Theme.of(context).colorScheme.onSecondary,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: Container(
                height: 568,
                child: const LocationPermissionPopUp(),
              ),
            ),
          );
        },
      ).then((locality) => safeSetState(() {
            _currentCity = locality;
          }));
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    wrapWithModel(
                      model: _model.headerModel,
                      updateCallback: () => setState(() {}),
                      child: const Header(),
                    ),
                    wrapWithModel(
                      model: _model.carouselComponentModel,
                      updateCallback: () => setState(() {}),
                      child: CarouselComponent(_currentCity),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Text('Nearby',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 12, 0),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
                                        text: 'See all',
                                        options: FFButtonOptions(
                                          width: 80,
                                          height: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          textStyle: const TextStyle(
                                            color: AppThemes.accent1,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          elevation: 2,
                                          borderSide: const BorderSide(
                                            color: AppThemes.accent1,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        wrapWithModel(
                                          model: _model.locationCardModel1,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel2,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel3,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel4,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel5,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Text('New Venues',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 12, 0),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
                                        text: 'See all',
                                        options: FFButtonOptions(
                                          width: 80,
                                          height: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          textStyle: const TextStyle(
                                            color: AppThemes.accent1,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          elevation: 2,
                                          borderSide: const BorderSide(
                                            color: AppThemes.accent1,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        wrapWithModel(
                                          model: _model.locationCardModel6,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel7,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel8,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel9,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel10,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Text('Trending Venues',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 12, 0),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
                                        text: 'See all',
                                        options: FFButtonOptions(
                                          width: 80,
                                          height: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          textStyle: const TextStyle(
                                            color: AppThemes.accent1,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          elevation: 2,
                                          borderSide: const BorderSide(
                                            color: AppThemes.accent1,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        wrapWithModel(
                                          model: _model.locationCardModel11,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel12,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel13,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.locationCardModel14,
                                          updateCallback: () => setState(() {}),
                                          child: const LocationCard(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    wrapWithModel(
                      model: _model.suggestedObjectModel,
                      updateCallback: () => setState(() {}),
                      child: const SuggestedObject(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 72),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Text('Categories',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        wrapWithModel(
                                          model: _model.categoryCardModel1,
                                          updateCallback: () => setState(() {}),
                                          child: const CategoryCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.categoryCardModel2,
                                          updateCallback: () => setState(() {}),
                                          child: const CategoryCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.categoryCardModel3,
                                          updateCallback: () => setState(() {}),
                                          child: const CategoryCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.categoryCardModel4,
                                          updateCallback: () => setState(() {}),
                                          child: const CategoryCard(),
                                        ),
                                        wrapWithModel(
                                          model: _model.categoryCardModel5,
                                          updateCallback: () => setState(() {}),
                                          child: const CategoryCard(),
                                        ),
                                      ],
                                    ),
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
          ),
        ),
      ),
    );
  }
}
