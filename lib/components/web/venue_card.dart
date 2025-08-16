import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:table_reserver/utils/venue_image_cache.dart';

class WebVenueCard extends StatefulWidget {
  final Venue venue;

  const WebVenueCard({super.key, required this.venue});

  @override
  State<WebVenueCard> createState() => _WebVenueCardState();
}

class _WebVenueCardState extends State<WebVenueCard> {
  final VenueApi venueApi = VenueApi();

  @override
  void initState() {
    super.initState();
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
            page: WebVenuePage(
              venueId: widget.venue.id,
              shouldReturnToHomepage: false,
            ),
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
    final cachedImage = VenueImageCache.getImage(widget.venue.id);

    if (cachedImage != null) {
      return _buildImageMemory(cachedImage);
    }

    return FutureBuilder<Uint8List?>(
      future: venueApi.getVenueHeaderImage(widget.venue.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: WebTheme.successColor),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _buildFallbackImage(context);
        }

        VenueImageCache.setImage(widget.venue.id, snapshot.data!);

        return _buildImageMemory(snapshot.data!);
      },
    );
  }

  Widget _buildImageMemory(Uint8List bytes) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.memory(
          bytes,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage(context);
          },
        ),
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext ctx) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: fallbackImageGradient(),
        ),
        child: Text(
          widget.venue.name,
          style: Theme.of(
            ctx,
          ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
        ),
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
