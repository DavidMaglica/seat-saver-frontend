import 'package:TableReserver/models/homepage_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../api/data/venue.dart';
import '../../components/carousel_item.dart';
import '../../components/navbar.dart';
import '../../components/venue_card.dart';
import '../../components/venue_suggested_card.dart';
import '../../themes/theme.dart';
import '../../utils/extensions.dart';
import '../../utils/routing_utils.dart';

class Homepage extends StatelessWidget {
  final String? userEmail;
  final Position? userLocation;

  const Homepage({Key? key, this.userEmail, this.userLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomepageModel(
            context: context, userEmail: userEmail, userLocation: userLocation)
          ..init(),
        child: Consumer<HomepageModel>(
          builder: (context, model, _) {
            return GestureDetector(
                onTap: () => model.unfocusNode.canRequestFocus
                    ? FocusScope.of(context).requestFocus(model.unfocusNode)
                    : FocusScope.of(context).unfocus(),
                child: WillPopScope(
                    onWillPop: () async => false,
                    child: Scaffold(
                        key: model.scaffoldKey,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        body: SafeArea(
                          top: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 16, 0, 0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  _buildHeader(context, model),
                                  _buildCarouselComponent(model),
                                  _buildVenues(
                                    context,
                                    'Nearby Venues',
                                    model.openNearbyVenues,
                                    model.nearbyVenues ?? [],
                                  ),
                                  _buildVenues(
                                    context,
                                    'New Venues',
                                    model.openNewVenues,
                                    model.newVenues ?? [],
                                  ),
                                  _buildVenues(
                                    context,
                                    'Trending Venues',
                                    model.openTrendingVenues,
                                    model.trendingVenues ?? [],
                                  ),
                                  _buildSuggestedVenues(
                                    context,
                                    model.suggestedVenues ?? [],
                                  ),
                                  _buildCategories(context, model),
                                ],
                              ),
                            ),
                          ),
                        ),
                        bottomNavigationBar: NavBar(
                          currentIndex: model.pageIndex,
                          context: context,
                          onTap: (index, context) => onNavbarItemTapped(
                              model.pageIndex,
                              index,
                              context,
                              userEmail,
                              model.currentUserLocation ?? userLocation),
                        ))));
          },
        ));
  }

  Widget _buildCarouselComponent(HomepageModel model) {
    final nearby = model.nearbyCities ?? [];
    if (nearby.isEmpty) {
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
                items: nearby
                    .map((city) => Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 12),
                        child: CarouselItem(city)))
                    .toList(),
                carouselController: model.carouselController ??=
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
                  onPageChanged: (index, _) =>
                      model.carouselCurrentIndex = index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenues(
    BuildContext ctx,
    String title,
    Function() seeAllFunction,
    List<Venue> venues,
  ) {
    return Padding(
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
                        _buildTitle(ctx, title),
                        _buildSeeAllButton(ctx, seeAllFunction),
                      ],
                    ),
                    _buildVenueCards(venues),
                  ]))
            ]));
  }

  Widget _buildSuggestedVenues(BuildContext ctx, List<Venue> venues) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(.2),
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
                        _buildTitle(ctx, 'We suggest'),
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
  }

  Widget _buildVenueCards(List<Venue> venues) {
    return Padding(
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
                      venue: venue,
                      userEmail: userEmail,
                      userLocation: userLocation,
                    ),
                  );
                }).toList())));
  }

  Widget _buildVenueSuggestedCards(List<Venue> venues) {
    return Padding(
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
                      venue: venue,
                      userEmail: userEmail,
                      userLocation: userLocation,
                    ),
                  );
                }).toList())));
  }

  Widget _buildCategories(BuildContext ctx, HomepageModel model) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 72),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
            child:
                Text('Categories', style: Theme.of(ctx).textTheme.titleMedium),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: model.venueTypeMap.entries
                        .map((entry) => _buildCategoryCard(
                              ctx,
                              model,
                              entry.key,
                              entry.value,
                            ))
                        .toList(),
                  ))),
        ]));
  }

  Widget _buildCategoryCard(
    BuildContext ctx,
    HomepageModel model,
    int id,
    String label,
  ) {
    return InkWell(
        onTap: () => model.searchByVenueType(id),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 140,
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(ctx).colorScheme.onPrimary,
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
                            color: Theme.of(ctx).colorScheme.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        Center(
                            child: Text(
                          label.toTitleCase(),
                          style: Theme.of(ctx).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ))
                      ],
                    )))));
  }

  Widget _buildTitle(BuildContext ctx, String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
      child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
    );
  }

  Widget _buildSeeAllButton(BuildContext ctx, Function() onPressed) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
        child: FFButtonWidget(
            showLoadingIndicator: true,
            onPressed: onPressed,
            text: 'See all',
            options: FFButtonOptions(
              width: 80,
              height: 24,
              color: Theme.of(ctx).colorScheme.background,
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
  }

  Widget _buildHeader(BuildContext ctx, HomepageModel model) {
    return Row(
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            model.loggedInUser != null
                                ? 'Welcome, ${model.loggedInUser!.username}'
                                : 'Welcome',
                            style: Theme.of(ctx).textTheme.titleLarge,
                          ),
                        ),
                      ])))
        ]);
  }
}
