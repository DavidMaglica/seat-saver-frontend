import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_reserver/themes/web_theme.dart';

class CircularStatCard extends StatelessWidget {
  final String title;
  final String description;
  final double? rating;
  final int? ratingCount;
  final double? utilisationRatio;
  final String? hint;

  const CircularStatCard({
    super.key,
    required this.title,
    required this.description,
    this.rating,
    this.ratingCount,
    this.utilisationRatio,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleAndDescription(context),
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            rating != null
                ? _buildRatingIndicator(context, rating!, ratingCount!)
                : _buildUtilisationRateIndicator(context, utilisationRatio!),
            if (hint != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6),
                child: Text(
                  '*${hint!}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingIndicator(
    BuildContext context,
    double rating,
    int ratingCount,
  ) {
    double ratingRatio = ratingCount > 0 ? (rating / 5.0) : 0.0;
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CircularPercentIndicator(
          percent: ratingRatio,
          radius: 55,
          lineWidth: 8,
          animation: true,
          animateFromLastPercent: true,
          progressColor: rating > 0.75
              ? WebTheme.successColor
              : rating > 0.25
              ? WebTheme.warningColor
              : WebTheme.errorColor,
          backgroundColor: Theme.of(context).colorScheme.outline,
          center: Text(
            rating.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildUtilisationRateIndicator(
    BuildContext context,
    double utilisationRatio,
  ) {
    final normalizedRatio = utilisationRatio / 100;
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CircularPercentIndicator(
          percent: normalizedRatio.clamp(0.0, 1.0),
          radius: 55,
          lineWidth: 8,
          animation: true,
          animateFromLastPercent: true,
          progressColor: utilisationRatio > 0.75
              ? WebTheme.errorColor
              : utilisationRatio > 0.25
              ? WebTheme.warningColor
              : WebTheme.successColor,
          backgroundColor: Theme.of(context).colorScheme.outline,
          center: Text(
            '${utilisationRatio.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
