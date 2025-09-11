import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/components/mobile/custom_appbar.dart';
import 'package:seat_saver/components/mobile/venue_card_by_type.dart';
import 'package:seat_saver/models/mobile/views/venues_by_type_model.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/utils/extensions.dart';

class VenuesByType extends StatelessWidget {
  final String type;
  final Position? userLocation;
  final VenuesByTypeModel? modelOverride;

  const VenuesByType({
    super.key,
    required this.type,
    this.userLocation,
    this.modelOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          modelOverride ??
                VenuesByTypeModel(type: type, userLocation: userLocation)
            ..init(),
      child: Consumer<VenuesByTypeModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(
                title: '${type.toTitleCase()} Venues',
                onBack: () => model.goBack(context),
              ),
              body: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _buildListView(context, model),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context, VenuesByTypeModel model) {
    return model.venues.isNotEmpty
        ? ListView.builder(
            key: const Key('venuesListView'),
            controller: model.scrollController,
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: model.venues.length,
            itemBuilder: (context, index) {
              if (index == model.venues.length && model.hasMorePages) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: MobileTheme.accent1,
                      size: 75,
                    ),
                  ),
                );
              }

              final venue = model.venues[index];
        final venueType = model.venueTypeMap[venue.typeId] ?? '';

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InkWell(
                  key: Key('venueCard'),
                  onTap: () {
                    model.goToVenuePage(context, venue.id);
                  },
                  child: VenueCardByType(venue: venue, venueType: venueType),
                ),
              );
            },
          )
        : Center(child: Text('No $type venues found.'));
  }
}
