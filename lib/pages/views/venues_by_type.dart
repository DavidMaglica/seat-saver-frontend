import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/components/custom_appbar.dart';
import 'package:TableReserver/models/venue_by_type_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class VenuesByType extends StatelessWidget {
  final String type;
  final int? userId;
  final Position? position;

  const VenuesByType({
    super.key,
    required this.type,
    this.userId,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenuesByTypeModel(
        context: context,
        userId: userId,
        type: type,
        position: position,
      )..init(),
      child: Consumer<VenuesByTypeModel>(builder: (context, model, _) {
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
              onBack: model.goBack,
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
      }),
    );
  }

  Widget _buildListView(BuildContext context, VenuesByTypeModel model) {
    return ListView.builder(
      controller: model.scrollController,
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: model.venues.length,
      itemBuilder: (context, index) {
        if (index == model.venues.length && model.hasMorePages) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: AppThemes.successColor,
              ),
            ),
          );
        }

        final venue = model.venues[index];

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
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
                  _buildHeadingImage(),
                  _buildVenueDetails(context, venue),
                  _buildIconButton(context, model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ClipRRect _buildHeadingImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Image.network(
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1760&q=80',
        width: 80.0,
        height: 80.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVenueDetails(BuildContext context, Venue venue) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildName(context, venue.name, venue.id),
            _buildCategory(context, venue.typeId.toString()),
            _buildLocation(context, venue.location),
          ],
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context, String name, int id) {
    return Text(
      '$id - $name',
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildCategory(BuildContext context, String type) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: AutoSizeText(
        type,
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

  Widget _buildIconButton(BuildContext context, VenuesByTypeModel model) {
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
}
