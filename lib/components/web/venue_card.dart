import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';

class WebVenueCard extends StatefulWidget {
  final Venue venue;

  const WebVenueCard({super.key, required this.venue});

  @override
  State<WebVenueCard> createState() => _WebVenueCardState();
}

class _WebVenueCardState extends State<WebVenueCard> {
  final VenueApi venueApi = VenueApi();

  Uint8List? _venueImage;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _fetchImages() async {
    List<Uint8List> venueImages = await venueApi.getVenueImages(
      widget.venue.id,
    );
    if (venueImages.isNotEmpty) {
      setState(() {
        _venueImage = venueImages.first;
      });
    } else {
      setState(() {
        _venueImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        Navigator.of(context).push(
          FadeInRoute(
            page: WebVenuePage(venueId: widget.venue.id),
            routeName: Routes.webVenue,
            arguments: {'venueId': widget.venue.id},
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 300,
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildImage(),
                _buildVenueData(context),
              ].divide(const SizedBox(height: 8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: _venueImage != null
            ? Image.memory(
                _venueImage!,
                width: double.infinity,
                height: 200,
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
      decoration: BoxDecoration(gradient: fallbackImageGradient()),
      child: Text(
        widget.venue.name,
        style: Theme.of(
          ctx,
        ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
      ),
    );
  }

  Widget _buildVenueData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.venue.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
