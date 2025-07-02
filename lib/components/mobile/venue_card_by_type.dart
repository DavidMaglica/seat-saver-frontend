import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/models/mobile/venue_card_by_type_model.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VenueCardByType extends StatelessWidget {
  final Venue venue;
  final String venueType;

  const VenueCardByType({
    Key? key,
    required this.venue,
    required this.venueType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenueCardByTypeModel(
        context: context,
        venue: venue,
        venueType: venueType,
      )..init(),
      child: Consumer<VenueCardByTypeModel>(
        builder: (context, model, _) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Theme.of(context).colorScheme.outline,
                  offset: const Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildImage(context, model),
                  _buildVenueDetails(context, venue, venueType),
                  _buildIcon(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVenueDetails(
    BuildContext context,
    Venue venue,
    String venueType,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildName(context, venue.name),
            _buildCategory(context, venueType),
            _buildLocation(context, venue.location),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext ctx, VenueCardByTypeModel model) {
    return Hero(
      tag: 'venueHeadingImage${venue.id}',
      transitionOnUserGestures: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: model.venueImage != null
            ? Image.memory(
                model.venueImage!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackImage(ctx);
                },
              )
            : _buildFallbackImage(ctx),
      ),
    );
  }

  Widget _buildName(BuildContext context, String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildCategory(BuildContext context, String venueType) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: AutoSizeText(
        venueType,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _buildLocation(BuildContext context, String location) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: AutoSizeText(
        location,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage(BuildContext ctx) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: fallbackImageGradient(),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            venue.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(ctx)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
