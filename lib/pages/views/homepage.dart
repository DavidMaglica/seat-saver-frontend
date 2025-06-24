import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/components/carousel_item.dart';
import 'package:TableReserver/components/navbar.dart';
import 'package:TableReserver/components/homepage_venue_card.dart';
import 'package:TableReserver/components/suggested_venue_card.dart';
import 'package:TableReserver/models/homepage_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/routing_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  final int? userId;
  final Position? userLocation;

  const Homepage({Key? key, this.userId, this.userLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomepageModel(
              context: context,
              userId: userId,
              userLocation: userLocation,
            )..init(),
        child: Consumer<HomepageModel>(
          builder: (context, model, _) {
            var brightness = Theme.of(context).brightness;
            return GestureDetector(
              onTap: () => model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: WillPopScope(
                  onWillPop: () async => false,
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: brightness == Brightness.dark
                          ? SystemUiOverlayStyle.light
                          : SystemUiOverlayStyle.dark,
                      child: Scaffold(
                          key: model.scaffoldKey,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          body: SafeArea(
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
                                    if (model.suggestedVenues != null &&
                                        model.suggestedVenues!.isNotEmpty)
                                      _buildSuggestedVenues(
                                        context,
                                        model.suggestedVenues!,
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          bottomNavigationBar: NavBar(
                            currentIndex: model.pageIndex,
                            onTap: (index, context) => onNavbarItemTapped(
                                context,
                                model.pageIndex,
                                index,
                                userId,
                                model.currentUserLocation ?? userLocation),
                          )))),
            );
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
                      userId: userId,
                      userLocation: userLocation,
                      venueIndex: venue.id,
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
                      userId: userId,
                      userLocation: userLocation,
                    ),
                  );
                }).toList())));
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
              elevation: 1,
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
