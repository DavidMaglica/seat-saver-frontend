import 'package:TableReserver/components/web/circular_stat_card.dart';
import 'package:TableReserver/components/web/performance_card.dart';
import 'package:TableReserver/components/web/side_nav.dart';
import 'package:TableReserver/components/web/stat_card.dart';
import 'package:TableReserver/models/web/homepage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class WebHomepage extends StatefulWidget {
  const WebHomepage({super.key});

  static String routeName = 'Homepage';
  static String routePath = '/homepage';

  @override
  State<WebHomepage> createState() => _WebHomepageState();
}

class _WebHomepageState extends State<WebHomepage>
    with TickerProviderStateMixin {
  late HomepageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.sideNavModel,
              updateCallback: () => safeSetState(() {}),
              child: const SideNav(),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTitle(context),
                          _buildTopStats(context),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCircularStats(),
                              _buildVenuesTable(context),
                            ]
                                .divide(const SizedBox(width: 16))
                                .addToStart(const SizedBox(width: 16)),
                          ),
                          _buildPerformance(context),
                        ]
                            .addToStart(const SizedBox(height: 24))
                            .addToEnd(const SizedBox(height: 24)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Overview',
      style: Theme.of(context).textTheme.titleLarge,
    ).animateOnPageLoad(_model.animationsMap['titleOnPageLoadAnimation']!);
  }

  Align _buildTopStats(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const StatCard(title: 'Reservations this Month', value: 208),
              const StatCard(title: 'Total Reservations Received', value: 2208),
              const StatCard(title: 'Total Reviews Received', value: 2193),
            ]
                .divide(const SizedBox(width: 16))
                .addToStart(const SizedBox(width: 16))
                .addToEnd(const SizedBox(width: 16)),
          ),
        ).animateOnPageLoad(
            _model.animationsMap['topStatsOnPageLoadAnimation']!),
      ),
    );
  }

  Flexible _buildCircularStats() {
    return Flexible(
      flex: 6,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const CircularStatCard(
              title: 'Rating',
              description: 'Your average rating across all venues.'),
          const CircularStatCard(
            title: 'Overall Utilization Rate',
            description:
                'The overall utilization rate of your venues. (Sum of (available_capacity) / Sum of (maximum_capacity)) × 100',
          ),
        ].divide(const SizedBox(height: 16)),
      ).animateOnPageLoad(_model.animationsMap['circularStatsOnPageLoadAnimation']!),
    );
  }

  Expanded _buildVenuesTable(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1270,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 12, 0),
                              child: Text(
                                'Your Venues',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 12, 0),
                              child: Text(
                                'View and edit or delete your venues',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Add New Venue',
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconColor:
                          Theme.of(context).colorScheme.primary,
                          color: Theme.of(context).colorScheme.primary,
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Name',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Location',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Working Hours',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Maximum capacity',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Available capacity',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Average rating',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Actions',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ].divide(const SizedBox(width: 4)),
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0,
                                color: Theme.of(context).colorScheme.primary,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    'Lamai',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    'Porec',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    '08:00 - 16:00',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    '120',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    '80',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 0),
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 12, 0),
                                      child: Text(
                                        '4.5',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ).animateOnPageLoad(_model.animationsMap[
                                      'containerOnPageLoadAnimation2']!),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 44,
                                      icon: Icon(
                                        Icons.edit_sharp,
                                        color:
                                        Theme.of(context).colorScheme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                // child: EditVenueWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      },
                                    ),
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 44,
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color:
                                        Theme.of(context).colorScheme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                // child: DeleteVenueWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      },
                                    ),
                                  ],
                                ),
                              ].divide(const SizedBox(width: 4)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animateOnPageLoad(
            _model.animationsMap['containerOnPageLoadAnimation1']!),
      ),
    );
  }

  Widget _buildPerformance(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: PerformanceCard(
              title: 'Best Performing Venue',
              venueId: 1,
            ),
          ),
          const Expanded(
            child: PerformanceCard(
              title: 'Worst Performing Venue',
              venueId: 1,
            ),
          ),
        ]
            .divide(const SizedBox(width: 16))
            .addToStart(const SizedBox(width: 16)),
      ).animateOnPageLoad(_model.animationsMap['rowOnPageLoadAnimation3']!),
    );
  }
}
