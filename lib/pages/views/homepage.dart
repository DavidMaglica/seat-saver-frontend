import 'package:diplomski/api/venue_api.dart';
import 'package:diplomski/components/venue_suggested_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/data/venue.dart';
import '../../components/carousel_component.dart';
import '../../components/location_permission.dart';
import '../../components/navbar.dart';
import '../../components/venue_card.dart';
import '../../themes/theme.dart';
import '../../utils/routing_utils.dart';
import 'models/homepage_model.dart';

export 'models/homepage_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final int pageIndex = 0;
  late HomepageModel _model;
  String? _currentCity;
  List<String>? _nearbyCities;
  List<Venue>? _nearbyVenues;
  List<Venue>? _newVenues;
  List<Venue>? _trendingVenues;
  List<Venue>? _suggestedVenues;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepageModel());
    _getNearbyVenues();
    _getNewVenues();
    _getTrendingVenues();
    _getSuggestedVenues();

    _activateLocationPopUp();
  }

  void _getNearbyVenues() async {
    List<Venue> list = await getNearbyVenues();
    setState(() {
      _nearbyVenues = list;
    });
  }

  void _getNewVenues() async {
    List<Venue> list = await getNewVenues();
    setState(() {
      _newVenues = list;
    });
  }

  void _getTrendingVenues() async {
    List<Venue> list = await getTrendingVenues();
    setState(() {
      _trendingVenues = list;
    });
  }

  void _getSuggestedVenues() async {
    List<Venue> list = await getSuggestedVenues();
    setState(() {
      _suggestedVenues = list;
    });
  }

  void _activateLocationPopUp() {
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
              child: const SizedBox(
                height: 568,
                child: LocationPermissionPopUp(),
              ),
            ),
          );
        },
      ).then((locationPopUpState) => {
            if (locationPopUpState != null)
              {
                safeSetState(() {
                  _currentCity = locationPopUpState[0];
                  _nearbyCities = locationPopUpState[1];
                })
              }
          });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _openNearbyVenues() => Navigator.pushNamed(context, '/search');

  void _openNewVenues() => Navigator.pushNamed(context, '/search');

  void _openTrendingVenues() => Navigator.pushNamed(context, '/search');

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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildHeader(),
                          wrapWithModel(
                            model: _model.carouselComponentModel,
                            updateCallback: () => setState(() {}),
                            child: CarouselComponent(_currentCity),
                          ),
                          _buildVenues('Nearby Venues', _openNearbyVenues,
                              _nearbyVenues ?? []),
                          _buildVenues(
                              'New Venues', _openNewVenues, _newVenues ?? []),
                          _buildVenues('Trending Venues', _openTrendingVenues,
                              _trendingVenues ?? []),
                          _buildSuggestedVenues(_suggestedVenues ?? []),
                          _buildCategories(),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: NavBar(
                  currentIndex: pageIndex,
                  context: context,
                  onTap: (index, context) =>
                      onNavbarItemTapped(pageIndex, index, context),
                ))));
  }

  Padding _buildVenues(
          String title, Function() seeAllFunction, List<Venue> venues) =>
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(title),
                          _buildSeeAllButton(seeAllFunction),
                        ],
                      ),
                      _buildVenueCards(venues),
                    ]))
              ]));

  Padding _buildSuggestedVenues(List<Venue> venues) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Optional: Add padding inside the Container
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('We suggest'),
                        ],
                      ),
                      _buildVenueSuggestedCards(venues),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Padding _buildVenueCards(List<Venue> venues) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 0, 0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: venues.map((venue) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: VenueCard(
                    name: venue.name,
                    location: venue.location,
                    workingHours: venue.workingHours,
                    rating: venue.rating,
                    type: venue.type,
                    description: venue.description,
                  ),
                );
              }).toList())));

  Padding _buildVenueSuggestedCards(List<Venue> venues) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 0, 0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: venues.map((venue) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: VenueSuggestedCard(
                    name: venue.name,
                    location: venue.location,
                    workingHours: venue.workingHours,
                    rating: venue.rating,
                    type: venue.type,
                    description: venue.description,
                  ),
                );
              }).toList())));

  Padding _buildCategories() => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 72),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
                        child: Text('Categories',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: VenueType.values
                                .map((category) => _buildCategoryCard(category))
                                .toList(),
                          )))
                ]))
          ]));

  InkWell _buildCategoryCard(VenueType category) => InkWell(
      onTap: () => Navigator.pushNamed(context, '/search', arguments: {
            'type': category,
          }),
      child: Align(
          alignment: AlignmentDirectional.center,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 140,
                  child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Center(
                              child: Text(
                            category.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ))
                        ],
                      ))))));

  Padding _buildTitle(String title) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );

  Padding _buildSeeAllButton(Function() onPressed) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
      child: FFButtonWidget(
          showLoadingIndicator: true,
          onPressed: onPressed,
          text: 'See all',
          options: FFButtonOptions(
            width: 80,
            height: 24,
            color: Theme.of(context).colorScheme.background,
            textStyle: const TextStyle(
              color: AppThemes.accent1,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            elevation: 3,
            borderSide: const BorderSide(
              color: AppThemes.accent1,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          )));

  Row _buildHeader() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 0, 0),
                            child: Text(
                              'Welcome',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 12, 0),
                              child: FFButtonWidget(
                                  onPressed: () {},
                                  text: 'Help',
                                  options: FFButtonOptions(
                                    width: 80,
                                    height: 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    textStyle: const TextStyle(
                                      color: AppThemes.infoColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    elevation: 3,
                                    borderSide: const BorderSide(
                                      color: AppThemes.infoColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  )))
                        ])))
          ]);
}
