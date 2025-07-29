import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/components/web/circular_stat_card.dart';
import 'package:TableReserver/components/web/modals/delete_modal.dart';
import 'package:TableReserver/components/web/modals/edit_venue_modal.dart';
import 'package:TableReserver/components/web/modals/modal_widgets.dart';
import 'package:TableReserver/components/web/performance_card.dart';
import 'package:TableReserver/components/web/side_nav.dart';
import 'package:TableReserver/components/web/stat_card.dart';
import 'package:TableReserver/models/web/homepage_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_table/flutter_advanced_table.dart';
import 'package:flutter_advanced_table/params.dart' hide ActionParamBuilder;
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
                              _buildVenues(context),
                            ].divide(const SizedBox(width: 16))),
                        const SizedBox(height: 16),
                        _buildPerformance(context),
                      ].addToStart(const SizedBox(height: 24)),
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
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        'Overview',
        style: Theme.of(context).textTheme.titleLarge,
      ).animateOnPageLoad(_model.animationsMap['titleOnPageLoadAnimation']!),
    );
  }

  Widget _buildTopStats(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const StatCard(title: 'Reservations this Month', value: 208),
              const StatCard(title: 'Total Reservations Received', value: 2208),
              const StatCard(title: 'Total Reviews Received', value: 2193),
            ].divide(const SizedBox(width: 16))),
      ).animateOnPageLoad(_model.animationsMap['topStatsOnPageLoadAnimation']!),
    );
  }

  Widget _buildCircularStats() {
    return Flexible(
      flex: 5,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const CircularStatCard(
              title: 'Rating',
              description: 'Your average rating across all venues.'),
          const CircularStatCard(
            title: 'Overall Utilization Rate',
            description: 'The overall utilization rate of your venues.',
            hint:
                'Sum of available capacity divided by sum of maximum capacity times 100',
          ),
        ].divide(const SizedBox(height: 16)),
      ).animateOnPageLoad(
          _model.animationsMap['circularStatsOnPageLoadAnimation']!),
    );
  }

  Widget _buildVenues(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: const EdgeInsets.all(0),
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
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(8),
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
                            Text(
                              'Your Venues',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'View and edit or delete your venues in this scrollable table.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          debugPrint('Button pressed ...');
                        },
                        text: 'Add New Venue',
                        icon: const Icon(
                          CupertinoIcons.add_circled,
                          size: 24,
                        ),
                        options: FFButtonOptions(
                          height: 40,
                          iconColor: Theme.of(context).colorScheme.primary,
                          color: WebTheme.successColor,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: WebTheme.offWhite,
                          ),
                          elevation: 3,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 360,
                    child: _buildTable(context),
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

  dynamic _buildTable(BuildContext context) {
    List<int> venueIds = _model.venues.map((venue) => venue.id).toList();

    return AdvancedTableWidget(
      headerBuilder: (context, header) {
        return _buildHeader(context, header);
      },
      headerDecoration: const BoxDecoration(
        color: WebTheme.accent1,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      rowElementsBuilder: (context, rowParams) {
        return _buildRows(
          context,
          rowParams,
          _model.venues,
        );
      },
      items: _model.venues,
      isLoadingAll: ValueNotifier(false),
      fullLoadingPlaceHolder: const Center(
        child: CircularProgressIndicator(),
      ),
      headerItems: _model.headers,
      actionBuilder: (context, actionParams) {
        final venueId = venueIds[actionParams.rowIndex];
        return _buildActions(context, venueId);
      },
      actions: const [
        {
          "label": "edit and delete",
        },
      ],
      rowDecorationBuilder: (index, isHovered) {
        return _buildRowDecoration(context, index, isHovered);
      },
    );
  }

  Row _buildActions(BuildContext context, int venueId) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: EditVenueModal(venueId: venueId),
                    ),
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.trash,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (_) {
                return DeleteModal(
                  modalType: DeleteModalType.venue,
                  venueId: venueId,
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context, HeaderBuilder header) {
    return Container(
      width: header.defualtWidth,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          header.value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: WebTheme.offWhite,
              ),
        ),
      ),
    );
  }

  List<SizedBox> _buildRows(
    BuildContext context,
    RowBuilderParams rowParams,
    List<Venue> venues,
  ) {
    final venue = venues[rowParams.index];
    return [
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(child: Text(venue.name)),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(child: Text(venue.location)),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(child: Text(venue.workingHours)),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(child: Text(venue.maximumCapacity.toString())),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(child: Text(venue.availableCapacity.toString())),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: venue.rating >= 4.0
                ? WebTheme.successColor
                : venue.rating >= 2.5
                    ? WebTheme.warningColor
                    : WebTheme.errorColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                venue.rating.toString(),
                style: const TextStyle(
                  color: WebTheme.offWhite,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  BoxDecoration _buildRowDecoration(
    BuildContext context,
    int index,
    bool isHover,
  ) {
    final isOdd = index % 2 == 0;
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: isHover
          ? WebTheme.infoColor
          : !isOdd
              ? Colors.transparent
              : Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildPerformance(BuildContext context) {
    return Row(
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
            ].divide(const SizedBox(width: 16)))
        .animateOnPageLoad(
      _model.animationsMap['rowOnPageLoadAnimation3']!,
    );
  }
}
