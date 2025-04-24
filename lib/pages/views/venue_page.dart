import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/data/basic_response.dart';
import '../../api/data/venue.dart';
import '../../api/reservation_api.dart';
import '../../api/venue_api.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/full_image_view.dart';
import '../../utils/toaster.dart';

class VenuePage extends StatefulWidget {
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
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  late Future<List<String>> _images;
  DateTime? _selectedDate;
  int? _selectedHour;
  int? _selectedMinute;
  int? _selectedNumberOfGuests;
  List<String>? _venueImages;
  String _venueType = '';
  Venue _venue = Venue(
    id: 0,
    name: '',
    typeId: 0,
    location: '',
    description: '',
    workingHours: '',
    rating: 0.0,
  );

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ReservationApi reservationApi = ReservationApi();
  VenueApi venueApi = VenueApi();

  @override
  void initState() {
    super.initState();
    _loadVenueDetails(widget.venueId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadVenueDetails(int venueId) async {
    Venue venue = await venueApi.getVenue(venueId);
    safeSetState(() {
      _venue = venue;
    });

    venueApi.getVenueType(venue.typeId).then((value) => safeSetState(() {
          _venueType = value;
        }));

    _images = venueApi.getImages();
    if (widget.imageLinks == null) {
      _venueImages = venueApi.getVenueImages(_venue.name);
    }
  }

  bool _validateInput() {
    final validationErrors = [
      if (widget.userEmail.isNullOrEmpty) 'Please log in to reserve a spot',
      if (_selectedDate == null) 'Please select a date',
      if (_selectedHour == null || _selectedMinute == null)
        'Please select a time',
      if (_selectedNumberOfGuests == null) 'Please select the number of guests',
    ];

    if (validationErrors.isNotEmpty) {
      Toaster.displayError(context, validationErrors.first);
      return false;
    }

    return true;
  }

  void _reserveSpot() {
    if (!_validateInput()) {
      return;
    }

    DateTime reservationDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedHour!,
      _selectedMinute == 0 ? 0 : 30,
    );

    reservationApi.addReservation(widget.userEmail!, _venue.id,
        _selectedNumberOfGuests!, reservationDateTime);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.pushNamed(context, Routes.SUCCESSFUL_RESERVATION, arguments: {
      'venueName': _venue.name,
      'numberOfGuests': _selectedNumberOfGuests,
      'reservationDateTime': reservationDateTime,
      'userEmail': widget.userEmail,
      'userLocation': widget.userLocation,
    });

    return;
  }

  void _rateVenue(double newRating) async {
    BasicResponse response =
        await venueApi.rateVenue(widget.venueId, newRating);
    if (response.success) {
      if (!mounted) {
        return;
      }
      Toaster.displaySuccess(context, 'Rating submitted successfully');
    } else {
      if (!mounted) {
        return;
      }
      Toaster.displayError(context, 'Failed to submit rating');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppbar(
          title: _venue.name,
          onBack: () => Navigator.of(context).pushNamed(Routes.HOMEPAGE,
              arguments: {
                'userEmail': widget.userEmail,
                'userLocation': widget.userLocation
              }),
        ),
        body: FutureBuilder<List<String>>(
          future: _images,
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
                      _buildHeadingImage(widget.imageLinks != null
                          ? widget.imageLinks![0]
                          : _venueImages![0]),
                      _buildObjectDetails(_venue, _venueType),
                      _buildObjectDescription(_venue.description),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildDatePickerButton(),
                          _buildNumberOfGuestsButton(),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTimePickerButton(),
                        ],
                      ),
                      _buildLeaveRatingButton(),
                      _buildDivider(),
                      _buildMasonryView(widget.imageLinks != null
                          ? widget.imageLinks!.skip(1).toList()
                          : _venueImages!.skip(1).toList()),
                    ],
                  ),
                ),
                _buildReserveSpotButton(_reserveSpot),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _buildHeadingImage(String image) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).push(
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

  Flexible _buildObjectDescription(String? description) => Flexible(
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
            child: Text(
              description ?? 'No description available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ),
      );

  Flexible _buildLeaveRatingButton() => Flexible(
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 0, 8),
            child: FFButtonWidget(
              onPressed: () => _buildRatingModal(),
              text: 'Leave a rating',
              options: FFButtonOptions(
                width: 128,
                height: 30,
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: Theme.of(context).colorScheme.background,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1,
                ),
                elevation: 3,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );

  Future<dynamic> _buildRatingModal() {
    double rating = 0;

    return showCupertinoModalPopup(
      context: context,
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
                    if (rating > 0) _rateVenue(rating);
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

  Widget _buildBorderedButton(String text, Color colour, VoidCallback action) =>
      Padding(
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

  Padding _buildObjectDetails(Venue venue, String type) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Column(
          children: [
            Text(
              venue.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Text(
                type.toFormattedUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.6),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Text(
                venue.location,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.6),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Text(
                'Working hours: ${venue.workingHours}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: RatingBar.builder(
                onRatingUpdate: (value) => {
                  debugPrint('Rating: $value'),
                },
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

  Padding _buildDatePickerButton() {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 24, 0),
      child: FFButtonWidget(
        onPressed: () {
          _buildDatePicker();
        },
        text: _selectedDate != null
            ? dateFormat.format(_selectedDate!)
            : 'Select date',
        icon: const Icon(
          CupertinoIcons.calendar,
          size: 18,
        ),
        options: _selectorButtonOptions(),
      ),
    );
  }

  Future<dynamic> _buildDatePicker() {
    return showCupertinoModalPopup(
      context: context,
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
                    setState(() {
                      _selectedDate = newDate;
                    });
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

  Padding _buildNumberOfGuestsButton() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: FFButtonWidget(
          onPressed: () {
            _buildNumberOfGuestsPicker();
          },
          text: _selectedNumberOfGuests != null
              ? '$_selectedNumberOfGuests'
              : 'Select no. of guests',
          icon: const Icon(
            CupertinoIcons.person_2_alt,
            size: 18,
          ),
          options: _selectorButtonOptions(),
        ),
      );

  Future<dynamic> _buildNumberOfGuestsPicker() {
    return showCupertinoModalPopup(
      context: context,
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
                    setState(() {
                      _selectedNumberOfGuests = selectedIndex + 1;
                    });
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

  Padding _buildTimePickerButton() {
    String minutesToDisplay = _selectedMinute == 0 ? '00' : '30';
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
      child: FFButtonWidget(
        onPressed: () {
          _buildTimePicker();
        },
        text: _selectedHour != null && _selectedMinute != null
            ? '$_selectedHour:$minutesToDisplay'
            : 'Select time',
        icon: const Icon(
          CupertinoIcons.clock,
          size: 18,
        ),
        options: _selectorButtonOptions(),
      ),
    );
  }

  Future<dynamic> _buildTimePicker() {
    _selectedMinute ??= 0;
    return showCupertinoModalPopup(
      context: context,
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
                          setState(() {
                            _selectedHour = index;
                          });
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: _selectedHour ?? 0,
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
                          setState(() {
                            _selectedMinute = index;
                          });
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: _selectedMinute ?? 00,
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

  Padding _buildReserveSpotButton(Function() onPressed) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(36, 0, 36, 48),
        child: FFButtonWidget(
          onPressed: onPressed,
          text: 'Reserve your spot now',
          options: FFButtonOptions(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsetsDirectional.all(0),
            color: AppThemes.infoColor,
            splashColor: Theme.of(context).colorScheme.surfaceVariant,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 16,
            ),
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  Padding _buildMasonryView(List<String> imageUrls) => Padding(
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

  Divider _buildDivider() => Divider(
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  FFButtonOptions _selectorButtonOptions() => FFButtonOptions(
        width: 180,
        height: 40,
        color: Theme.of(context).colorScheme.background,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12,
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
        elevation: 3,
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onPrimary,
          width: .5,
        ),
        borderRadius: BorderRadius.circular(8),
      );
}
