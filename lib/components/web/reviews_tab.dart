import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/models/web/venue_page_model.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ReviewsTab extends StatelessWidget {
  final _model = VenuePageModel();

  ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.onSurface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildOverall(context),
                const SizedBox(height: 8),
                Divider(
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ).animateOnPageLoad(
                    _model.animationsMap['textOnPageLoadAnimation5']!),
                const SizedBox(height: 8),
                _buildReviews(context).animateOnPageLoad(
                    _model.animationsMap['rowOnPageLoadAnimation']!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverall(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalReviews(context),
          const SizedBox(height: 8),
          _buildRating(
            context,
            _model.loadedVenue.rating,
            'Average Rating',
          ),
        ],
      ),
    ).animateOnPageLoad(_model.animationsMap['textOnPageLoadAnimation5']!);
  }

  Widget _buildTotalReviews(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Total number of reviews:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        Text(
          _model.reviews.length.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: _model.reviews
              .mapIndexed((index, review) {
                return Column(
                  children: [
                    _buildReview(context, review),
                    if (index < _model.reviews.length - 1)
                      Divider(
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                  ],
                );
              })
              .toList()
              .divide(const SizedBox(height: 16)),
        ),
      ),
    );
  }

  Widget _buildReview(BuildContext context, Rating review) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              review.username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _buildRating(context, review.rating, null),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          review.comment,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildRating(BuildContext context, double rating, String? label) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        label != null
            ? Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              )
            : const SizedBox.shrink(),
        const SizedBox(width: 16),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: rating >= 4.0
                ? WebTheme.successColor
                : rating >= 2.5
                    ? WebTheme.warningColor
                    : WebTheme.errorColor,
            borderRadius: BorderRadius.circular(56),
          ),
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                color: WebTheme.offWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
