import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

class VenueCard extends StatefulWidget {
  final Venue venue;
  final int venueId;
  final int? userId;
  final Position? userLocation;

  const VenueCard({
    Key? key,
    required this.venue,
    required this.venueId,
    this.userId,
    this.userLocation,
  }) : super(key: key);

  @override
  State<VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  Uint8List? _venueImage;

  VenuesApi venuesApi = VenuesApi();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    _loadVenueImage();
    super.initState();
  }

  Future<void> _loadVenueImage() async {
    List<Uint8List> venueImages = await venuesApi.getVenueImages(widget.venue.id);
    if (venueImages.isNotEmpty) {
      setState(() => _venueImage = venueImages.first);
    } else {
      setState(() => _venueImage = null);
    }
  }

  void _openVenuePage() =>
      Navigator.pushNamed(context, Routes.venue, arguments: {
        'venueId': widget.venue.id,
        'userId': widget.userId,
        'userLocation': widget.userLocation,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: InkWell(
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 6, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(widget.venue.name),
                        _buildLocationAndAvailability(widget.venue.location),
                        _buildRatingBar(widget.venue.rating),
                      ],
                    ),
                  ),
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
      tag: 'venueCardImage${randomDouble(0, 100)}${widget.venue.id}',
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
                height: 80,
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
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: fallbackImageGradient(),
      ),
      child: Text(
        widget.venue.name,
        style:
            Theme.of(ctx).textTheme.titleSmall?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildName(String name) {
    return Text(
      name.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: MobileTheme.accent1, fontSize: 12),
    );
  }

  Widget _buildLocationAndAvailability(String location) {
    final availabilityColour = calculateAvailabilityColour(
        widget.venue.maximumCapacity, widget.venue.availableCapacity);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            location,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w800,
              fontSize: 9,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: availabilityColour,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRatingBar(double rating) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
            itemSize: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 1),
            child: Text(
              ' ${rating.toStringAsFixed(1)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
