import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularStatCard extends StatelessWidget {
  final String title;
  final String description;

  const CircularStatCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 1000,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleAndDescription(context),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            _buildCircularIndicator(context),
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(BuildContext context) {
    double utilisationRatio = 0.9;
    double rating = 3.5;

    double ratingRatio = rating / 5.0;

    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: CircularPercentIndicator(
          percent: title == 'Rating' ? ratingRatio : utilisationRatio,
          radius: 80,
          lineWidth: 8,
          animation: true,
          animateFromLastPercent: true,
          progressColor: title == 'Rating'
              ? ratingRatio > 0.75
                  ? WebTheme.successColor
                  : ratingRatio > 0.25
                      ? WebTheme.warningColor
                      : WebTheme.errorColor
              : utilisationRatio > 0.75
                  ? WebTheme.errorColor
                  : utilisationRatio > 0.25
                      ? WebTheme.warningColor
                      : WebTheme.successColor,
          backgroundColor: Theme.of(context).colorScheme.outline,
          center: Text(
            title == 'Rating' ? '${rating.toDouble()}' : '${utilisationRatio * 100}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
