import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/logger.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:table_reserver/utils/venue_image_cache/venue_image_cache_interface.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class PerformanceCard extends StatefulWidget {
  final String title;
  final int venueId;

  const PerformanceCard({
    super.key,
    required this.title,
    required this.venueId,
  });

  @override
  State<PerformanceCard> createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  final VenueApi venueApi = VenueApi();

  Venue? loadedVenue;

  @override
  void initState() {
    super.initState();
    fetchVenueData(context, widget.venueId);
  }

  Future<void> fetchVenueData(BuildContext context, int venueId) async {
    Venue? venue = await venueApi.getVenue(venueId);
    logger.i('Fetched venue: ${venue?.name ?? 'null'} with ID: $venueId');
    if (venue != null) {
      loadedVenue = venue;
      logger.d(
        'Loaded venue: ${loadedVenue?.name} with ID: ${loadedVenue?.id}',
      );
    } else {
      WebToaster.displayError(
        context,
        'Error while fetching venue. Try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          FadeInRoute(
            page: WebVenuePage(
              venueId: widget.venueId,
              shouldReturnToHomepage: true,
            ),
            routeName: '${Routes.webVenue}?venueId=${widget.venueId}',
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTitle(context),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                _buildVenueDetails(context),
                _buildHeaderImage(context),
              ].divide(const SizedBox(height: 8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildVenueDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loadedVenue?.name ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            loadedVenue?.rating.toStringAsFixed(2) ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }



  Widget _buildHeaderImage(BuildContext context) {
    Uint8List? cachedImage = VenueImageCache.getImage(widget.venueId);

    if (cachedImage != null) {
      return _buildImage(cachedImage);
    }
    return FutureBuilder<Uint8List?>(
      future: venueApi.getVenueHeaderImage(widget.venueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: WebTheme.successColor),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _buildFallbackImage(context);
        }

        VenueImageCache.setImage(widget.venueId, snapshot.data!);

        return _buildImage(snapshot.data!);
      },
    );
  }

  Widget _buildImage(Uint8List cachedImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          cachedImage,
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

  Widget _buildFallbackImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: fallbackImageGradient(),
        ),
        child: Text(
          loadedVenue?.name ?? '',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
        ),
      ),
    );
  }
}
