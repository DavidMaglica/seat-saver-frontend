import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/models/web/venue_page_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class VenueDetailsTab extends StatelessWidget {
  final VenuePageModel model;

  const VenueDetailsTab({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.onSurface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildTextDetails(context),
            const SizedBox(height: 8),
            Divider(
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ).animateOnPageLoad(
              model.animationsMap['textOnPageLoadAnimation5']!,
            ),
            _buildIconDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, 'Venue Type'),
          _buildDetail(context, model.venueType),
          const SizedBox(height: 8),
          _buildTitle(context, 'Description'),
          _buildDetail(context, model.loadedVenue.description ?? ''),
          const SizedBox(height: 8),
          _buildTitle(context, 'Location'),
          _buildDetail(context, model.loadedVenue.location),
          const SizedBox(height: 8),
          _buildTitle(context, 'Working Hours'),
          _buildDetail(context, model.loadedVenue.workingHours),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    ).animateOnPageLoad(model.animationsMap['textOnPageLoadAnimation5']!);
  }

  Widget _buildDetail(
    BuildContext context,
    String detail, {
    bool isDescription = false,
  }) {
    return Text(
      detail,
      style: isDescription
          ? Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)
          : Theme.of(context).textTheme.bodyLarge,
    ).animateOnPageLoad(model.animationsMap['textOnPageLoadAnimation5']!);
  }

  Widget _buildIconDetails(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIconDetail(
          context,
          Icons.table_restaurant_outlined,
          'Maximum Capacity',
          model.loadedVenue.maximumCapacity.toString(),
        ),
        _buildIconDetail(
          context,
          Icons.event_available_outlined,
          'Available Capacity',
          model.loadedVenue.availableCapacity.toString(),
        ),
        _buildIconDetail(
          context,
          Icons.rsvp_outlined,
          'Lifetime reservations',
          model.lifetimeReservations.toString(),
        ),
      ],
    ).animateOnPageLoad(model.animationsMap['rowOnPageLoadAnimation']!);
  }

  Column _buildIconDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon, color: WebTheme.accent1, size: 44),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
