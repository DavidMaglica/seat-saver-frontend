import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/models/web/views/ratings_page_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
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
                            _buildTitle(context, model),
                            const SizedBox(height: 32),
                            !model.isLoading
                                ? _buildMasonryGrid(context, model)
                                : Padding(
                                    padding: const EdgeInsets.only(top: 96),
                                    child: Column(
                                      children: [
                                        Center(
                                          child:
                                              LoadingAnimationWidget.threeArchedCircle(
                                                color: WebTheme.accent1,
                                                size: 75,
                                              ),
                                        ),
                                      ].divide(const SizedBox(height: 16)),
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

  Widget _buildTitle(BuildContext context, WebRatingsPageModel model) {
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
      ).animateOnPageLoad(model.animationsMap['titleOnPageLoadAnimation']!),
    );
  }

  Widget _buildMasonryGrid(BuildContext context, WebRatingsPageModel model) {
    final venueIds = model.ratingsByVenueId.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: venueIds.length,
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

  Material _buildRatingSummary(
      BuildContext context,
      WebRatingsPageModel model,
      int venueId,
      Map<int, int> counts,
      ) {
    final String venueName = model.venueNamesById[venueId]!;
    final oneStar = counts[1] ?? 0;
    final twoStars = counts[2] ?? 0;
    final threeStars = counts[3] ?? 0;
    final fourStars = counts[4] ?? 0;
    final fiveStars = counts[5] ?? 0;
    final total = oneStar + twoStars + threeStars + fourStars + fiveStars;

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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venueName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              RatingSummary(
                counter: total,
                showAverage: false,
                counterFiveStars: fiveStars,
                counterFourStars: fourStars,
                counterThreeStars: threeStars,
                counterTwoStars: twoStars,
                counterOneStars: oneStar,
                color: Theme.of(context).colorScheme.primary,
                labelCounterOneStars: Text('1',
                    style: Theme.of(context).textTheme.bodyMedium),
                labelCounterTwoStars: Text('2',
                    style: Theme.of(context).textTheme.bodyMedium),
                labelCounterThreeStars: Text('3',
                    style: Theme.of(context).textTheme.bodyMedium),
                labelCounterFourStars: Text('4',
                    style: Theme.of(context).textTheme.bodyMedium),
                labelCounterFiveStars: Text('5',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
