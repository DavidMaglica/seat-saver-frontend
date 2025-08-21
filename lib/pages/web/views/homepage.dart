import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_table/flutter_advanced_table.dart';
import 'package:flutter_advanced_table/params.dart' hide ActionParamBuilder;
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/components/web/circular_stat_card.dart';
import 'package:table_reserver/components/web/modals/create_venue_modal.dart';
import 'package:table_reserver/components/web/modals/delete_modal.dart';
import 'package:table_reserver/components/web/modals/edit_venue_modal.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/components/web/stat_card.dart';
import 'package:table_reserver/models/web/modals/create_venue_model.dart';
import 'package:table_reserver/models/web/views/homepage_model.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/venue_image_cache/venue_image_cache_stub.dart';

class WebHomepage extends StatefulWidget {
  final int ownerId;

  const WebHomepage({super.key, required this.ownerId});

  @override
  State<WebHomepage> createState() => _WebHomepageState();
}

class _WebHomepageState extends State<WebHomepage>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomepageModel(ownerId: widget.ownerId)..init(context),
      child: Consumer<HomepageModel>(
        builder: (context, model, _) {
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
                  const SideNav(),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildTitleRow(context, model).animateOnPageLoad(
                                model.animationsMap['titleRowOnLoad']!,
                              ),
                              _buildTopStats(context, model).animateOnPageLoad(
                                model.animationsMap['titleRowOnLoad']!,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCircularStats(model).animateOnPageLoad(
                                    model.animationsMap['circularStatsOnLoad']!,
                                  ),
                                  _buildVenues(
                                    context,
                                    model,
                                  ).animateOnPageLoad(
                                    model.animationsMap['tableOnLoad']!,
                                  ),
                                ].divide(const SizedBox(width: 16)),
                              ),
                              const SizedBox(height: 16),
                              _buildPerformance(
                                context,
                                model,
                              ).animateOnPageLoad(
                                model.animationsMap['performanceOnLoad']!,
                              ),
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
        },
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, HomepageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          FFButtonWidget(
            onPressed: () {
              model.fetchData(context);
            },
            text: 'Refresh data',
            icon: const Icon(CupertinoIcons.refresh, size: 18),
            options: FFButtonOptions(
              height: 40,
              iconColor: Theme.of(context).colorScheme.primary,
              color: WebTheme.infoColor,
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
    );
  }

  Widget _buildTopStats(BuildContext context, HomepageModel model) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          StatCard(
            title: 'Reservations last 30 days',
            value: model.lastMonthReservationsCount,
          ),
          StatCard(
            title: 'Reservations next 30 days',
            value: model.nextMonthReservationsCount,
          ),
          StatCard(
            title: 'Total Reservations Received',
            value: model.totalReservationsCount,
          ),
          StatCard(
            title: 'Total Reviews Received',
            value: model.totalReviewsCount,
          ),
        ].divide(const SizedBox(width: 16)),
      ),
    );
  }

  Widget _buildCircularStats(HomepageModel model) {
    return Flexible(
      flex: 5,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircularStatCard(
            title: 'Rating',
            description: 'Your average rating across all venues.',
            onPressed: model.goToRatingsPage(context),
            rating: model.overallRating,
            ratingCount: model.totalReviewsCount,
          ),
          CircularStatCard(
            title: 'How Busy You Are',
            description: 'A quick look at how busy your venues are right now.',
            onPressed: model.goToReservationsGraphsPage(context),
            utilisationRatio: model.overallUtilisationRate,
            hint:
                'Sum of available capacity divided by sum of maximum capacity times 100',
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildVenues(BuildContext context, HomepageModel model) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1270),
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
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                backgroundColor: Colors.transparent,
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 1000,
                                    ),
                                    child: ChangeNotifierProvider(
                                      create: (_) => CreateVenueModel()..init(),
                                      child: Consumer<CreateVenueModel>(
                                        builder: (context, model, _) {
                                          return CreateVenueModal(model: model);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        text: 'Create a Venue',
                        icon: const Icon(CupertinoIcons.add_circled, size: 24),
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
                  SizedBox(height: 379, child: _buildTable(context, model)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic _buildTable(BuildContext context, HomepageModel model) {
    List<int> venueIds = model.venues.map((venue) => venue.id).toList();

    if (model.venues.isEmpty && !model.isLoadingTable.value) {
      return Center(
        child: Text(
          'You haven\'t registered any venues yet.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return AdvancedTableWidget(
      headerBuilder: (context, header) {
        return _buildHeader(context, header);
      },
      headerDecoration: const BoxDecoration(
        color: WebTheme.accent1,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      rowElementsBuilder: (context, rowParams) {
        return _buildRows(context, rowParams, model.venues);
      },
      items: model.venues,
      isLoadingAll: model.isLoadingTable,
      fullLoadingPlaceHolder: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: WebTheme.accent1,
          size: 75,
        ),
      ),
      headerItems: model.headers,
      actionBuilder: (context, actionParams) {
        final venueId = venueIds[actionParams.rowIndex];
        return _buildActions(context, model, venueId);
      },
      actions: const [
        {"label": "edit and delete"},
      ],
      rowDecorationBuilder: (index, isHovered) {
        return _buildRowDecoration(context, index, isHovered);
      },
      onRowTap: (rowIndex) {
        final venueId = venueIds[rowIndex];
        Navigator.of(context).push(
          FadeInRoute(
            page: WebVenuePage(venueId: venueId, shouldReturnToHomepage: true),
            routeName: '${Routes.webVenue}?venueId=$venueId',
          ),
        );
      },
    );
  }

  Row _buildActions(BuildContext context, HomepageModel model, int venueId) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            bool? shouldRefresh = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
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
            if (shouldRefresh == true) {
              if (!context.mounted) return;
              model.fetchVenues(context);
            }
          },
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.trash,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            bool? shouldRefresh = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: DeleteModal(
                        modalType: DeleteModalType.venue,
                        venueName: model.venues
                            .firstWhere((v) => v.id == venueId)
                            .name,
                        venueId: venueId,
                      ),
                    ),
                  ),
                );
              },
            );
            if (shouldRefresh == true) {
              if (!context.mounted) return;
              model.fetchVenues(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, HeaderBuilder header) {
    bool isWideHeader =
        header.value == 'Name' ||
        header.value == 'Location' ||
        header.value == 'Working Hours';
    return Container(
      width: isWideHeader ? 130 : 100,
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
        width: 130,
        child: Text(venue.name, overflow: TextOverflow.ellipsis),
      ),
      SizedBox(
        width: 130,
        child: Center(
          child: Text(venue.location, overflow: TextOverflow.ellipsis),
        ),
      ),
      SizedBox(
        width: 130,
        child: Center(
          child: Text(venue.workingHours, overflow: TextOverflow.ellipsis),
        ),
      ),
      SizedBox(
        width: 100,
        child: Center(child: Text(venue.maximumCapacity.toString())),
      ),
      SizedBox(
        width: 100,
        child: Center(child: Text(venue.availableCapacity.toString())),
      ),
      SizedBox(
        width: 100,
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
                venue.rating.toStringAsFixed(2),
                style: const TextStyle(color: WebTheme.offWhite),
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

  Widget _buildPerformance(BuildContext context, HomepageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildPerformanceCard(
            context,
            model,
            model.bestPerformingVenue,
          ),
        ),
        Expanded(
          child: _buildPerformanceCard(
            context,
            model,
            model.worstPerformingVenue,
          ),
        ),
      ].divide(const SizedBox(width: 16)),
    );
  }

  InkWell _buildPerformanceCard(
    BuildContext context,
    HomepageModel model,
    Venue? venue,
  ) {
    return InkWell(
      mouseCursor: venue != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onTap: () {
        if (venue != null) {
          Navigator.of(context).push(
            FadeInRoute(
              page: WebVenuePage(
                venueId: venue.id,
                shouldReturnToHomepage: true,
              ),
              routeName: '${Routes.webVenue}?venueId=${venue.id}',
            ),
          );
        }
      },
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildPerformanceTitle(context, venue),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                _buildPerformanceVenueDetails(context, venue),
                _buildPerformanceHeaderImage(context, model, venue),
              ].divide(const SizedBox(height: 8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceTitle(BuildContext context, Venue? venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        venue != null
            ? venue.name
            : 'Not enough data to display. Please add more venues.',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildPerformanceVenueDetails(BuildContext context, Venue? venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(venue?.name ?? '', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            venue?.rating.toStringAsFixed(2) ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeaderImage(
    BuildContext context,
    HomepageModel model,
    Venue? venue,
  ) {
    if (venue == null) {
      return _buildFallbackImage(context, venue);
    }
    Uint8List? cachedImage = VenueImageCache.getImage(venue.id);

    if (cachedImage != null) {
      return _buildPerformanceImage(venue, cachedImage);
    }

    return FutureBuilder<Uint8List?>(
      future: model.venuesApi.getVenueHeaderImage(venue.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: WebTheme.transparentColour,
            ),
            child: LoadingAnimationWidget.threeArchedCircle(
              color: WebTheme.accent1,
              size: 75,
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _buildFallbackImage(context, venue);
        }

        VenueImageCache.setImage(venue.id, snapshot.data!);

        return _buildPerformanceImage(venue, snapshot.data!);
      },
    );
  }

  Widget _buildPerformanceImage(Venue model, Uint8List cachedImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          cachedImage,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage(context, model);
          },
        ),
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext context, Venue? venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: WebTheme.transparentColour,
        ),
        child: const Icon(
          Icons.no_photography_outlined,
          color: WebTheme.accent1,
          size: 50,
        ),
        // TODO check later
        // child: Text(
        //   venue?.name ?? 'No data',
        //   style: Theme.of(
        //     context,
        //   ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
        // ),
      ),
    );
  }
}
