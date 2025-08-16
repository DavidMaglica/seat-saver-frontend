import 'package:table_reserver/components/mobile/custom_appbar.dart';
import 'package:table_reserver/components/common/full_image_view.dart';
import 'package:table_reserver/components/mobile/venue_images_tab.dart';
import 'package:table_reserver/models/mobile/venue_page_model.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class VenuePage extends StatelessWidget {
  final int venueId;
  final int? userId;
  final Position? userLocation;

  const VenuePage({
    Key? key,
    required this.venueId,
    this.userId,
    this.userLocation,
  }) : super(key: key);

  Function() goBack(BuildContext context) {
    return () => Navigator.of(context).pop({
          'userId': userId,
          'userLocation': userLocation,
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenuePageModel(
          ctx: context,
          venueId: venueId,
          userId: userId,
          userLocation: userLocation)
        ..init(),
      child: Consumer<VenuePageModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(
                onBack: goBack(context),
              ),
              body: model.venueImageBytes == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      alignment: const AlignmentDirectional(0, 1),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildHeadingImage(context, model),
                              _buildObjectDetails(context, model),
                              const SizedBox(height: 8),
                              _buildDivider(context),
                              const SizedBox(height: 8),
                              _buildMakeReservation(context, model),
                              const SizedBox(height: 8),
                              _buildDivider(context),
                              VenueImagesTab(
                                venueImages: model.venueImageBytes,
                                menuImages: model.menuImageBytes,
                              )
                            ],
                          ),
                        ),
                        _buildReserveSpotButton(context, model),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadingImage(BuildContext ctx, VenuePageModel model) {
    final bool hasImage =
        model.venueHeadingImage != null && model.venueHeadingImage!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          if (!hasImage) return;

          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageView(
                imageBytes: model.venueHeadingImage!,
                heroTag: 'headerImageTag',
              ),
            ),
          );
        },
        child: Hero(
          tag: 'headerImageTag',
          child: hasImage
              ? Image.memory(
                  model.venueHeadingImage!,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                    gradient: fallbackImageGradient(),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    model.venue.name,
                    style: Theme.of(ctx)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildObjectDetails(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.venue.name.toUpperCase(),
            style: Theme.of(ctx).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildVenueType(ctx, model),
          const SizedBox(height: 8),
          _buildVenueLocation(ctx, model),
          const SizedBox(height: 8),
          _buildAvailability(ctx, model),
          const SizedBox(height: 8),
          _buildVenueHours(ctx, model),
          const SizedBox(height: 8),
          _buildVenueRating(ctx, model),
          const SizedBox(height: 8),
          _buildViewRatingsButton(ctx, model),
          _buildVenueDescription(ctx, model),
        ],
      ),
    );
  }

  Widget _buildViewRatingsButton(BuildContext ctx, VenuePageModel model) {
    return FFButtonWidget(
      onPressed: () => Navigator.of(ctx).pushNamed(
        Routes.venueRatings,
        arguments: {
          'venueId': model.venue.id,
          'userId': model.userId,
          'userLocation': model.userLocation,
        },
      ),
      text: 'View Ratings & Reviews',
      showLoadingIndicator: false,
      options: FFButtonOptions(
        width: 164,
        height: 30,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: Theme.of(ctx).colorScheme.surface,
        textStyle: const TextStyle(
          color: MobileTheme.accent1,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        borderSide: const BorderSide(
          color: MobileTheme.accent1,
          width: 1,
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildVenueType(BuildContext ctx, VenuePageModel model) {
    return Text(
      model.venueType.toFormattedUpperCase(),
      style: Theme.of(ctx).textTheme.bodyMedium,
    );
  }

  Widget _buildVenueLocation(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.location_solid,
          color: Theme.of(ctx).colorScheme.onPrimary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          model.venue.location,
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAvailability(BuildContext ctx, VenuePageModel model) {
    final availabilityColour = calculateAvailabilityColour(
        model.venue.maximumCapacity, model.venue.availableCapacity);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.person_2,
          color: availabilityColour,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '${model.venue.availableCapacity} / ${model.venue.maximumCapacity} currently available',
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                color: availabilityColour,
              ),
        ),
      ],
    );
  }

  Widget _buildVenueHours(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.clock,
          color: Theme.of(ctx).colorScheme.onPrimary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Working hours: ${model.venue.workingHours}',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildVenueRating(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RatingBar.builder(
          onRatingUpdate: (_) => {},
          itemBuilder: (context, index) => const Icon(
            CupertinoIcons.star_fill,
            color: MobileTheme.accent1,
          ),
          unratedColor: const Color(0xFF57636C).withValues(alpha: 0.5),
          direction: Axis.horizontal,
          glow: false,
          ignoreGestures: true,
          initialRating: model.venue.rating,
          itemCount: 1,
          itemSize: 18,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            ' ${model.venue.rating.toStringAsFixed(1)}',
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildVenueDescription(BuildContext ctx, VenuePageModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'About this venue',
            style: Theme.of(ctx)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            model.venue.description ?? 'No description available',
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMakeReservation(BuildContext ctx, VenuePageModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make a reservation',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 16),
              _buildPeopleButton(ctx, model),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildDatePicker(ctx, model),
                  const SizedBox(width: 22),
                  _buildTimeButton(ctx, model),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPeopleButton(BuildContext ctx, VenuePageModel model) {
    return OutlinedButton(
      onPressed: () {},
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 350,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_2,
              color: Theme.of(ctx).colorScheme.onPrimary,
              size: 28,
            ),
            const SizedBox(width: 12),
            _buildPeopleDropdown(ctx, model)
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleDropdown(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: DropdownButton<int>(
        value: model.selectedNumberOfPeople,
        hint: Text(
          'Select no. of people attending',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        style: Theme.of(ctx).textTheme.bodyMedium,
        dropdownColor: Theme.of(ctx).colorScheme.onSurface,
        underline: Container(),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        items: List.generate(12, (i) => i + 1)
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value == 1 ? '$value person' : '$value people'),
                ))
            .toList(),
        onChanged: (value) {
          model.setPeople(value);
        },
        selectedItemBuilder: (context) => List.generate(12, (i) => i + 1)
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value == 1 ? '$value person' : '$value people'),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext ctx, VenuePageModel model) {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    var displayDate = model.selectedDate != null
        ? dateFormat.format(model.selectedDate!)
        : 'Select date';
    return OutlinedButton(
      onPressed: () => model.selectDate(ctx),
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 148,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.calendar,
              color: Theme.of(ctx).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Text(displayDate, style: Theme.of(ctx).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext ctx, VenuePageModel model) {
    return OutlinedButton(
      onPressed: () {},
      style: _reservationButtonsStyle(ctx),
      child: SizedBox(
        height: 46,
        width: 148,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.clock,
              color: Theme.of(ctx).colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            _buildTimeDropdown(ctx, model)
          ],
        ),
      ),
    );
  }

  DropdownButton<TimeOfDay> _buildTimeDropdown(
    BuildContext ctx,
    VenuePageModel model,
  ) {
    return DropdownButton<TimeOfDay>(
      value: model.selectedTime,
      hint: Text(
        'Select time',
        style: Theme.of(ctx).textTheme.bodyLarge,
      ),
      style: Theme.of(ctx).textTheme.bodyMedium,
      dropdownColor: Theme.of(ctx).colorScheme.onSurface,
      underline: Container(),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      items: model.timeOptions.map((time) {
        final formatted = time.format(ctx);
        return DropdownMenuItem(
          value: time,
          child: Text(formatted),
        );
      }).toList(),
      onChanged: (value) {
        model.setTime(value);
      },
    );
  }

  Widget _buildReserveSpotButton(BuildContext ctx, VenuePageModel model) {
    bool isDisabled = model.venue.availableCapacity == 0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 48),
      child: FFButtonWidget(
        onPressed: () => isDisabled ? null : model.reserve(),
        text: isDisabled
            ? 'No seats currently available'
            : 'Reserve your spot now',
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsetsDirectional.all(0),
          color: isDisabled ? Colors.grey : MobileTheme.successColor,
          splashColor: isDisabled
              ? MobileTheme.transparentColour
              : Theme.of(ctx).colorScheme.surfaceDim,
          textStyle: TextStyle(
            color: isDisabled
                ? Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.4)
                : Theme.of(ctx).colorScheme.onSurface,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(ctx).colorScheme.onPrimary.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _reservationButtonsStyle(BuildContext ctx) {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: Theme.of(ctx).colorScheme.onPrimary,
        width: 1,
      ),
      splashFactory: NoSplash.splashFactory,
      elevation: 3,
      backgroundColor: Theme.of(ctx).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
