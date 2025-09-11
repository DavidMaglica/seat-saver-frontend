import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/components/mobile/carousel_item.dart';
import 'package:seat_saver/components/mobile/homepage_venue_card.dart';
import 'package:seat_saver/components/mobile/navbar.dart';
import 'package:seat_saver/components/mobile/suggested_venue_card.dart';
import 'package:seat_saver/models/mobile/views/homepage_model.dart';
import 'package:seat_saver/pages/mobile/views/search.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';
import 'package:seat_saver/utils/routing_utils.dart';

class Homepage extends StatelessWidget {
  final int? userId;
  final Position? userLocation;
  final HomepageModel? modelOverride;

  const Homepage({
    super.key,
    this.userId,
    this.userLocation,
    this.modelOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          modelOverride ??
                HomepageModel(userId: userId, userLocation: userLocation)
            ..init(context),
      child: Consumer<HomepageModel>(
        builder: (context, model, _) {
          var brightness = Theme.of(context).brightness;
          return GestureDetector(
            onTap: () => model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: PopScope(
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: Scaffold(
                  key: model.scaffoldKey,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await model.init(context);
                        },
                        elevation: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _buildHeader(context, model),
                              _buildCarouselComponent(context, model),
                              const SizedBox(height: 24),
                              _buildVenues(
                                context,
                                'Nearby Venues',
                                () => model.openNearbyVenues(context),
                                model.nearbyVenues ?? [],
                              ),
                              const SizedBox(height: 24),
                              _buildVenues(
                                context,
                                'New Venues',
                                () => model.openNewVenues(context),
                                model.newVenues ?? [],
                              ),
                              const SizedBox(height: 24),
                              _buildVenues(
                                context,
                                'Trending Venues',
                                () => model.openTrendingVenues(context),
                                model.trendingVenues ?? [],
                              ),
                              const SizedBox(height: 24),
                              if (model.suggestedVenues != null &&
                                  model.suggestedVenues!.isNotEmpty)
                                _buildSuggestedVenues(
                                  context,
                                  () => model.openSuggestedVenues(context),
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
                  ),
                  bottomNavigationBar: NavBar(
                    currentIndex: model.pageIndex,
                    onTap: (index, context) =>
                        onNavbarItemTapped(context, model.pageIndex, index),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselComponent(BuildContext context, HomepageModel model) {
    if (model.nearbyCities.isEmpty) {
      return const SizedBox.shrink();
    } else {
      if (model.cityImages.isEmpty) {
        /// Loading city image is currently commented out as it queries Google Places API which is not free.
        // model.loadCarouselData(model.nearbyCities);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 212,
            child: CarouselSlider(
              key: const Key('carouselSlider'),
              items: model.nearbyCities
                  .mapIndexed(
                    (index, city) => Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 12,
                      ),
                      child: InkWell(
                        key: Key('carouselItem'),
                        onTap: () {
                          Navigator.of(context).push(
                            MobileFadeInRoute(
                              page: Search(locationQuery: city),
                              routeName: Routes.search,
                              arguments: {'locationQuery': city},
                            ),
                          );
                        },
                        child: CarouselItem(city, model.cityImages[city]),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: model.carouselController,
              options: CarouselOptions(
                initialPage: 0,
                viewportFraction: .75,
                disableCenter: false,
                enlargeCenterPage: true,
                enlargeFactor: .25,
                enableInfiniteScroll: true,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayCurve: Curves.linear,
                pauseAutoPlayInFiniteScroll: true,
                onPageChanged: (index, _) => model.carouselCurrentIndex = index,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenues(BuildContext context,
    String title,
    Function() seeAllFunction,
    List<Venue> venues,
  ) {
    return Row(
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
                  _buildTitle(context, title),
                  _buildSeeAllButton(context, seeAllFunction),
                ],
              ),
              const SizedBox(height: 12),
              _buildVenueCards(venues),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedVenues(BuildContext context,
    Function() seeAllFunction,
    List<Venue> venues,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        decoration: BoxDecoration(
          color: MobileTheme.successColor.withValues(alpha: 0.4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 24),
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
                        _buildTitle(context, 'We suggest'),
                        _buildSeeAllButton(context, seeAllFunction),
                      ],
                    ),
                    const SizedBox(height: 12),
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
      padding: const EdgeInsets.only(left: 4),
      child: SingleChildScrollView(
        key: const Key('venueCardsScrollView'),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: venues.map((venue) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: VenueCard(
                venue: venue,
                userId: userId,
                userLocation: userLocation,
                venueId: venue.id,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVenueSuggestedCards(List<Venue> venues) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: SingleChildScrollView(
        key: const Key('venueSuggestedCardsScrollView'),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: venues.map((venue) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: VenueSuggestedCard(
                venue: venue,
                userId: userId,
                userLocation: userLocation,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildSeeAllButton(BuildContext context, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FFButtonWidget(
        key: const Key('seeAllButton'),
        showLoadingIndicator: true,
        onPressed: onPressed,
        text: 'See all',
        options: FFButtonOptions(
          width: 80,
          height: 24,
          color: Theme.of(context).colorScheme.onSurface,
          textStyle: const TextStyle(
            color: MobileTheme.accent1,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          elevation: 1,
          borderSide: const BorderSide(color: MobileTheme.accent1, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomepageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    key: const Key('welcomeText'),
                    model.loggedInUser != null
                        ? 'Welcome back, ${model.loggedInUser!.username}!'
                        : 'Welcome',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
