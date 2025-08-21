import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/components/web/timer_dropdown.dart';
import 'package:table_reserver/models/web/views/ratings_page_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class WebRatingsPage extends StatelessWidget {
  final int ownerId;

  const WebRatingsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WebRatingsPageModel(ownerId: ownerId)..init(),
      child: Consumer<WebRatingsPageModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: CustomAppbar(
              title: 'Venue Ratings',
              onBack: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    page: WebHomepage(ownerId: ownerId),
                    routeName: Routes.webHomepage,
                  ),
                );
              },
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: 1920,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRefreshButton(context, model)
                              ..animateOnPageLoad(
                                model.animationsMap['titleRowOnLoad']!,
                              ),
                            const SizedBox(height: 16),
                            !model.isLoading
                                ? _buildMasonryGrid(
                                    context,
                                    model,
                                  ).animateOnPageLoad(
                                    model.animationsMap['gridOnLoad']!,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 96),
                                    child: Center(
                                      child:
                                          LoadingAnimationWidget.threeArchedCircle(
                                            color: WebTheme.accent1,
                                            size: 75,
                                          ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context, WebRatingsPageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TimerDropdown(
            selectedInterval: model.selectedInterval,
            onChanged: (value) {
              model.selectedInterval = value;
              model.startTimer();
            },
          ),
          const SizedBox(width: 8),
          FFButtonWidget(
            onPressed: () {
              model.fetchData(ownerId);
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

  Widget _buildMasonryGrid(BuildContext context, WebRatingsPageModel model) {
    final venueIds = model.ratingsByVenueId.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 450,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: model.ratingsByVenueId.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final venueId = venueIds[index];
          final counts = model.ratingsByVenueId[venueId]!;

          return _buildRatingSummary(context, model, venueId, counts);
        },
      ),
    );
  }

  Widget _buildRatingSummary(
    BuildContext context,
    WebRatingsPageModel model,
    int venueId,
    Map<int, int> counts,
  ) {
    final String venueName = model.venueNamesById[venueId]!;
    final int oneStar = counts[1] ?? 0;
    final int twoStars = counts[2] ?? 0;
    final int threeStars = counts[3] ?? 0;
    final int fourStars = counts[4] ?? 0;
    final int fiveStars = counts[5] ?? 0;
    final total = counts.values.fold(0, (sum, c) => sum + c);
    final weightedSum = counts.entries.fold(
      0,
      (sum, e) => sum + (e.key * e.value),
    );

    final double average = total > 0 ? weightedSum / total : 0.0;

    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    venueName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeInRoute(
                          page: WebVenuePage(
                            venueId: venueId,
                            shouldReturnToHomepage: false,
                            shouldOpenReviewsTab: true,
                          ),
                          routeName: '${Routes.webVenue}?venueId=$venueId',
                        ),
                      );
                    },
                    text: 'View venue ratings',
                    options: FFButtonOptions(
                      height: 40,
                      iconColor: Theme.of(context).colorScheme.primary,
                      color: WebTheme.infoColor,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: WebTheme.offWhite,
                      ),
                      elevation: 3,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RatingSummary(
                counter: total,
                average: average,
                showAverage: true,
                averageStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                starColor: WebTheme.accent1,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.2),
                counterFiveStars: fiveStars,
                counterFourStars: fourStars,
                counterThreeStars: threeStars,
                counterTwoStars: twoStars,
                counterOneStars: oneStar,
                color: WebTheme.accent1,
                thickness: 8,
                labelCounterOneStars: Text(
                  '1',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                labelCounterTwoStars: Text(
                  '2',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                labelCounterThreeStars: Text(
                  '3',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                labelCounterFourStars: Text(
                  '4',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                labelCounterFiveStars: Text(
                  '5',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
