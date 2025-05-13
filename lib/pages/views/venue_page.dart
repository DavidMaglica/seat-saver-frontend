import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../api/data/venue.dart';
import '../../components/custom_appbar.dart';
import '../../components/full_image_view.dart';
import '../../themes/theme.dart';
import '../../utils/extensions.dart';
import '../../models/venue_page_model.dart';

class VenuePage extends StatelessWidget {
  final int venueId;
  final List<String>? imageLinks;
  final String? userEmail;
  final Position? userLocation;

  const VenuePage({
    Key? key,
    required this.venueId,
    this.imageLinks,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => VenuePageModel(
            ctx: context,
            venueId: venueId,
            imageLinks: imageLinks,
            userEmail: userEmail,
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
                  title: model.venue.name,
                  onBack: () => Navigator.of(context).pop({
                    'userEmail': userEmail,
                    'userLocation': userLocation,
                  }),
                ),
                body: FutureBuilder<List<String>>(
                  future: model.images,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CupertinoActivityIndicator(
                        radius: 24,
                        color: AppThemes.infoColor,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No images available'));
                    }

                    return Stack(
                      alignment: const AlignmentDirectional(0, 1),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildHeadingImage(
                                  context,
                                  model.imageLinks != null
                                      ? model.imageLinks![0]
                                      : model.venueImages![0]),
                              _buildObjectDetails(
                                  context, model.venue, model.venueType),
                              _buildObjectDescription(
                                  context, model.venue.description),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildDatePickerButton(context, model),
                                  _buildNumberOfPeopleButton(context, model),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildTimePickerButton(context, model),
                                ],
                              ),
                              _buildLeaveRatingButton(context, model),
                              _buildDivider(context),
                              _buildMasonryView(model.imageLinks != null
                                  ? model.imageLinks!.skip(1).toList()
                                  : model.venueImages!.skip(1).toList()),
                            ],
                          ),
                        ),
                        _buildReserveSpotButton(context, model),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ));
  }

  Widget _buildHeadingImage(BuildContext ctx, String image) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => FullScreenImageView(
                imageUrl: image,
                heroTag: 'headerImageTag',
              ),
            ),
          );
        },
        child: Hero(
          tag: 'headerImageTag',
          child: Image.asset(
            image,
            width: double.infinity,
            height: 320,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildObjectDescription(BuildContext ctx, String? description) {
    return Flexible(
      child: Align(
        alignment: const AlignmentDirectional(-1, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
          child: Text(
            description ?? 'No description available',
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveRatingButton(BuildContext ctx, VenuePageModel model) {
    return Flexible(
      child: Align(
        alignment: const AlignmentDirectional(-1, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 0, 8),
          child: FFButtonWidget(
            onPressed: () => _buildRatingModal(ctx, model),
            text: 'Leave a rating',
            options: FFButtonOptions(
              width: 128,
              height: 30,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: Theme.of(ctx).colorScheme.background,
              textStyle: TextStyle(
                color: Theme.of(ctx).colorScheme.onPrimary,
                fontSize: 12,
              ),
              borderSide: BorderSide(
                color: Theme.of(ctx).colorScheme.onPrimary,
                width: 1,
              ),
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildRatingModal(BuildContext ctx, VenuePageModel model) {
    double rating = 0;

    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RatingBar.builder(
                        onRatingUpdate: (newRating) {
                          setModalState(() {
                            rating = newRating;
                          });
                        },
                        itemBuilder: (context, index) => Icon(
                          CupertinoIcons.star_fill,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        unratedColor: const Color(0xFF57636C).withOpacity(0.5),
                        direction: Axis.horizontal,
                        glow: false,
                        ignoreGestures: false,
                        initialRating: rating,
                        itemSize: 32,
                        allowHalfRating: true,
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: rating > 0
                        ? Text(
                            'Your rating: ${rating.toStringAsFixed(1)}',
                            key: ValueKey(rating),
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  _buildBorderedButton('Give Rating', AppThemes.successColor,
                      () {
                    if (rating > 0) model.rateVenue(rating);
                    Navigator.of(context).pop();
                  }),
                  const SizedBox(height: 16),
                  _buildBorderedButton('Cancel', AppThemes.errorColor, () {
                    Navigator.of(context).pop();
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBorderedButton(String text, Color colour, VoidCallback action) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: colour,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            onPressed: action,
            child: Text(
              text,
              style: TextStyle(
                color: colour,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ));
  }

  Widget _buildObjectDetails(BuildContext ctx, Venue venue, String type) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Column(
        children: [
          Text(
            venue.name.toUpperCase(),
            style: Theme.of(ctx).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Text(
              type.toFormattedUpperCase(),
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.6),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
            child: Text(
              venue.location,
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.6),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
            child: Text(
              'Working hours: ${venue.workingHours}',
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
            child: RatingBar.builder(
              onRatingUpdate: (_) => {},
              itemBuilder: (context, index) => Icon(
                CupertinoIcons.star_fill,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              unratedColor: const Color(0xFF57636C).withOpacity(0.5),
              direction: Axis.horizontal,
              glow: false,
              ignoreGestures: true,
              initialRating: venue.rating,
              itemSize: 24,
              allowHalfRating: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDatePickerButton(BuildContext ctx, VenuePageModel model) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 24, 0),
      child: FFButtonWidget(
        onPressed: () {
          _buildDatePicker(ctx, model);
        },
        text: model.selectedDate != null
            ? dateFormat.format(model.selectedDate!)
            : 'Select date',
        icon: const Icon(
          CupertinoIcons.calendar,
          size: 18,
        ),
        options: _selectorButtonOptions(ctx),
      ),
    );
  }

  Future<dynamic> _buildDatePicker(BuildContext ctx, VenuePageModel model) {
    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          height: 264,
          color: Theme.of(context).colorScheme.background,
          child: Column(children: [
            SizedBox(
              height: 196,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    model.selectedDate = newDate;
                  }),
            ),
            SizedBox(
                height: 50,
                child: CupertinoButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
          ]),
        );
      },
    );
  }

  Widget _buildNumberOfPeopleButton(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: FFButtonWidget(
        onPressed: () {
          _buildNumberOfPeoplePicker(ctx, model);
        },
        text: model.selectedNumberOfPeople != null
            ? '${model.selectedNumberOfPeople}'
            : 'Select no. of people attending',
        icon: const Icon(
          CupertinoIcons.person_2_alt,
          size: 18,
        ),
        options: _selectorButtonOptions(ctx),
      ),
    );
  }

  Future<dynamic> _buildNumberOfPeoplePicker(
    BuildContext ctx,
    VenuePageModel model,
  ) {
    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          height: 264,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 196,
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int selectedIndex) {
                    model.selectedNumberOfPeople = selectedIndex + 1;
                  },
                  children: List<Widget>.generate(10, (int index) {
                    return Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 50,
                child: CupertinoButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePickerButton(BuildContext ctx, VenuePageModel model) {
    String minutesToDisplay = model.selectedMinute == 0 ? '00' : '30';
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
      child: FFButtonWidget(
        onPressed: () {
          _buildTimePicker(ctx, model);
        },
        text: model.selectedHour != null && model.selectedMinute != null
            ? '${model.selectedHour}:$minutesToDisplay'
            : 'Select time',
        icon: const Icon(
          CupertinoIcons.clock,
          size: 18,
        ),
        options: _selectorButtonOptions(ctx),
      ),
    );
  }

  Future<dynamic> _buildTimePicker(BuildContext ctx, VenuePageModel model) {
    model.selectedMinute ??= 0;
    return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return Container(
          height: 264,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 196,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          model.selectedHour = index;
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: model.selectedHour ?? 0,
                        ),
                        children: List<Widget>.generate(24, (int index) {
                          return Center(
                            child: Text(
                              '$index',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          model.selectedMinute = index;
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: model.selectedMinute ?? 00,
                        ),
                        children: List<Widget>.generate(2, (int index) {
                          return Center(
                            child: Text(
                              index == 0 ? '00' : '30',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: CupertinoButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReserveSpotButton(BuildContext ctx, VenuePageModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 48),
      child: FFButtonWidget(
        onPressed: () => model.reserve(),
        text: 'Reserve your spot now',
        options: FFButtonOptions(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsetsDirectional.all(0),
          color: AppThemes.infoColor,
          splashColor: Theme.of(ctx).colorScheme.surfaceVariant,
          textStyle: TextStyle(
            color: Theme.of(ctx).colorScheme.background,
            fontSize: 16,
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildMasonryView(List<String> imageUrls) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 96),
      child: MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        crossAxisSpacing: 24,
        mainAxisSpacing: 12,
        itemCount: imageUrls.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImageView(
                    imageUrl: imageUrl,
                    heroTag: 'imageTag$index',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'imageTag$index',
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  width: 160,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Divider(
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(ctx).colorScheme.onPrimary,
    );
  }

  FFButtonOptions _selectorButtonOptions(BuildContext ctx) {
    return FFButtonOptions(
      width: 180,
      height: 40,
      color: Theme.of(ctx).colorScheme.background,
      textStyle: TextStyle(
        color: Theme.of(ctx).colorScheme.onPrimary,
        fontSize: 12,
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
      elevation: 3,
      borderSide: BorderSide(
        color: Theme.of(ctx).colorScheme.onPrimary,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
