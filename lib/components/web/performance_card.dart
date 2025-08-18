import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/models/web/performance_card_model.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:table_reserver/utils/venue_image_cache/venue_image_cache_interface.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PerformanceCardModel()..fetchVenueData(context, widget.venueId),
      child: Consumer<PerformanceCardModel>(
        builder: (context, model, _) {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                      _buildVenueDetails(context, model),
                      _buildHeaderImage(context, model),
                    ].divide(const SizedBox(height: 8)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildVenueDetails(BuildContext context, PerformanceCardModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model.loadedVenue?.name ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            model.loadedVenue?.rating.toStringAsFixed(2) ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, PerformanceCardModel model) {
    Uint8List? cachedImage = VenueImageCache.getImage(widget.venueId);

    if (cachedImage != null) {
      return _buildImage(model, cachedImage);
    }
    return FutureBuilder<Uint8List?>(
      future: model.venueApi.getVenueHeaderImage(widget.venueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: WebTheme.transparentColour,
            ),
            child: const CircularProgressIndicator(
              color: WebTheme.successColor,
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _buildFallbackImage(context, model);
        }

        VenueImageCache.setImage(widget.venueId, snapshot.data!);

        return _buildImage(model, snapshot.data!);
      },
    );
  }

  Widget _buildImage(PerformanceCardModel model, Uint8List cachedImage) {
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
            return _buildFallbackImage(context, model);
          },
        ),
      ),
    );
  }

  Widget _buildFallbackImage(BuildContext context, PerformanceCardModel model) {
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
          model.loadedVenue?.name ?? '',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: WebTheme.offWhite),
        ),
      ),
    );
  }
}
