import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';

class VenueSuggestedCard extends StatefulWidget {
  final Venue venue;
  final int? userId;
  final Position? userLocation;

  const VenueSuggestedCard({
    super.key,
    required this.venue,
    this.userId,
    this.userLocation,
  });

  @override
  State<VenueSuggestedCard> createState() => _VenueSuggestedCardState();
}

class _VenueSuggestedCardState extends State<VenueSuggestedCard> {
  Uint8List? _venueImage;
  String _venueType = '';

  VenuesApi venuesApi = VenuesApi();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    _getVenueType();
    _loadVenueImage();
    super.initState();
  }

  Future<void> _getVenueType() async {
    venuesApi.getVenueType(widget.venue.typeId).then((value) {
      if (value != null) {
        setState(() {
          _venueType = value;
        });
      }
    });
  }

  Future<void> _loadVenueImage() async {
    List<Uint8List> venues = await venuesApi.getVenueImages(widget.venue.id);
    if (venues.isNotEmpty) {
      setState(() => _venueImage = venues.first);
    } else {
      setState(() => _venueImage = null);
    }
  }

  void _openVenuePage() {
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: VenuePage(venueId: widget.venue.id),
        routeName: Routes.venue,
        arguments: {'venueId': widget.venue.id},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: 196,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: InkWell(
              key: const Key('venueSuggestedCard'),
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _openVenuePage();
              },
              child: Column(
                children: [
                  _buildImage(),
                  const SizedBox(height: 8),
                  _buildNameAndType(widget.venue.name, _venueType),
                  const SizedBox(height: 8),
                  _buildLocationAndAvailability(),
                  const SizedBox(height: 8),
                  _buildRatingBarAndWorkingHours(widget.venue.rating),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'locationCardImage${widget.venue.id}',
      transitionOnUserGestures: true,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: _venueImage != null
            ? Image.memory(
                _venueImage!,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackImage(context);
                },
              )
            : _buildFallbackImage(context),
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext ctx) {
    return Container(
      width: double.infinity,
      height: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(gradient: fallbackImageGradientReverted()),
      child: Text(
        widget.venue.name,
        style: Theme.of(
          ctx,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNameAndType(String name, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: MobileTheme.accent1),
          ),
          Text(
            type.isNotEmpty ? type.toTitleCase() : '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndAvailability() {
    final availabilityColour = calculateAvailabilityColour(
      widget.venue.maximumCapacity,
      widget.venue.availableCapacity,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.venue.location,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person_2_fill,
                color: availabilityColour,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.venue.availableCapacity}/${widget.venue.maximumCapacity}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: availabilityColour,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBarAndWorkingHours(double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RatingBarIndicator(
            itemBuilder: (context, index) => Icon(
              CupertinoIcons.star_fill,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            direction: Axis.horizontal,
            rating: rating,
            unratedColor: const Color(0xFF57636C).withValues(alpha: 0.5),
            itemCount: 5,
            itemSize: 14,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Text(
              ' ${rating.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
