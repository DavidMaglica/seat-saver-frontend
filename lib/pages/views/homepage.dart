import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/account_api.dart';
import '../../api/data/user.dart';
import '../../api/data/venue.dart';
import '../../api/geolocation_api.dart';
import '../../api/venue_api.dart';
import '../../components/carousel_item.dart';
import '../../components/location_permission.dart';
import '../../components/navbar.dart';
import '../../components/venue_card.dart';
import '../../components/venue_suggested_card.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/routing_utils.dart';
import '../../utils/toaster.dart';

class Homepage extends StatefulWidget {
  final String? userEmail;
  final Position? userLocation;

  const Homepage({Key? key, this.userEmail, this.userLocation})
      : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final unfocusNode = FocusNode();

  final int pageIndex = 0;
  List<Venue>? _nearbyVenues;
  List<Venue>? _newVenues;
  List<Venue>? _trendingVenues;
  List<Venue>? _suggestedVenues;
  CarouselController? _carouselController;
  int carouselCurrentIndex = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String>? _nearbyCities;
  Position? currentUserLocation;
  User? loggedInUser;

  AccountApi accountApi = AccountApi();
  GeolocationApi geolocationApi = GeolocationApi();
  VenueApi venueApi = VenueApi();

  @override
  void initState() {
    super.initState();
    int locationPopUpCounter = 0;

    if (widget.userEmail.isNotNullAndNotEmpty) {
      accountApi.getUser(widget.userEmail!).then((response) => {
            if (response != null && response.success)
              setState(() {
                loggedInUser = response.user;
              })
          });
    }

    if (locationPopUpCounter <= 1) {
      if (widget.userEmail != null && widget.userEmail!.isNotEmpty) {
        accountApi.getNotificationOptions(widget.userEmail!).then((value) => {
              if (!value.locationServicesTurnedOn)
                {
                  _activateLocationPopUp(widget.userEmail!),
                }
              else
                {
                  accountApi
                      .getLastKnownLocation(widget.userEmail!)
                      .then((value) => {
                            geolocationApi
                                .getNearbyCities(value)
                                .then((cities) => {
                                      setState(() {
                                        _nearbyCities = cities;
                                      }),
                                    }),
                          }),
                }
            });
      }
      locationPopUpCounter++;
    }

    if (widget.userLocation != null) {
      _getNearbyCities(widget.userLocation);
    } else {
      if (loggedInUser != null &&
          loggedInUser?.notificationOptions.locationServicesTurnedOn == true) {
        setState(() => currentUserLocation = loggedInUser!.lastKnownLocation);
        _getNearbyCities(loggedInUser!.lastKnownLocation);
      }
    }

    _getNearbyVenues();
    _getNewVenues();
    _getTrendingVenues();
    _getSuggestedVenues();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    super.dispose();
  }

  void _getNearbyCities(Position? position) async {
    // List<String> cities = await getNearbyCities(position!);
    // setState(() => _nearbyCities = cities);
  }

  void _getNearbyVenues() async {
    List<Venue> list = await venueApi.getNearbyVenues();
    setState(() {
      _nearbyVenues = list;
    });
  }

  void _getNewVenues() async {
    List<Venue> list = await venueApi.getNewVenues();
    setState(() {
      _newVenues = list;
    });
  }

  void _getTrendingVenues() async {
    List<Venue> list = await venueApi.getTrendingVenues();
    setState(() {
      _trendingVenues = list;
    });
  }

  void _getSuggestedVenues() async {
    List<Venue> list = await venueApi.getSuggestedVenues();
    setState(() {
      _suggestedVenues = list;
    });
  }

  void _activateLocationPopUp(String userEmail) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Theme.of(context).colorScheme.onSecondary,
          enableDrag: false,
          context: context,
          builder: (context) {
            return GestureDetector(
                onTap: () => unfocusNode.canRequestFocus
                    ? FocusScope.of(context).requestFocus(unfocusNode)
                    : FocusScope.of(context).unfocus(),
                child: Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: SizedBox(
                      height: 568,
                      child: LocationPermissionPopUp(userEmail: userEmail),
                    )));
          });
    });
  }

  void _openNearbyVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    return;
  }

  void _openNewVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    return;
  }

  void _openTrendingVenues() {
    Toaster.displayInfo(context, 'Currently unavailable');
    return;
  }

  Future<void> _searchByCategory(VenueType category) =>
      Navigator.pushNamed(context, Routes.SEARCH, arguments: {
        'userEmail': widget.userEmail,
        'userLocation': widget.userLocation,
        'selectedChip': category.toString(),
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: SafeArea(
                  top: true,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildHeader(),
                          _buildCarouselComponent(_nearbyCities ?? []),
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
                  onTap: (index, context) => onNavbarItemTapped(
                      pageIndex,
                      index,
                      context,
                      widget.userEmail,
                      currentUserLocation ?? widget.userLocation),
                ))));
  }

  Row _buildCarouselComponent(List<String> nearbyCities) {
    if (nearbyCities.isEmpty) {
      return const Row();
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: SizedBox(
              width: double.infinity,
              height: 212,
              child: CarouselSlider(
                items: nearbyCities
                    .map((city) => Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 12),
                        child: CarouselItem(city)))
                    .toList(),
                carouselController: _carouselController ??=
                    CarouselController(),
                options: CarouselOptions(
                  initialPage: 1,
                  viewportFraction: .75,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  enlargeFactor: .25,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayCurve: Curves.linear,
                  pauseAutoPlayInFiniteScroll: true,
                  onPageChanged: (index, _) => carouselCurrentIndex = index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 24),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: VenueCard(
                    venueName: venue.name,
                    location: venue.location,
                    workingHours: venue.workingHours,
                    rating: venue.rating,
                    type: venue.type,
                    description: venue.description,
                    userEmail: widget.userEmail,
                    userLocation: widget.userLocation,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: VenueSuggestedCard(
                    venueName: venue.name,
                    location: venue.location,
                    workingHours: venue.workingHours,
                    rating: venue.rating,
                    type: venue.type,
                    description: venue.description,
                    userEmail: widget.userEmail,
                    userLocation: widget.userLocation,
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
      onTap: () => _searchByCategory(category),
      child: Align(
          alignment: AlignmentDirectional.center,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 140,
                  child: Card(
                      elevation: 5,
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
                              loggedInUser != null
                                  ? 'Welcome, ${loggedInUser!.username}'
                                  : 'Welcome',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          // Padding(
                          //     padding: const EdgeInsetsDirectional.fromSTEB(
                          //         0, 0, 12, 0),
                          //     child: FFButtonWidget(
                          //         onPressed: () {},
                          //         text: 'Help',
                          //         options: FFButtonOptions(
                          //           width: 80,
                          //           height: 24,
                          //           color: Theme.of(context)
                          //               .colorScheme
                          //               .background,
                          //           textStyle: const TextStyle(
                          //             color: AppThemes.infoColor,
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //           elevation: 3,
                          //           borderSide: const BorderSide(
                          //             color: AppThemes.infoColor,
                          //             width: 1,
                          //           ),
                          //           borderRadius: BorderRadius.circular(8),
                          //         ))),
                        ])))
          ]);
}
