import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/venue_api.dart';
import '../../components/custom_appbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/full_image_view.dart';

class VenuePage extends StatefulWidget {
  final String name;
  final String location;
  final String workingHours;
  final double rating;
  final String type;
  final String description;
  final String? userEmail;
  final Position? userLocation;

  const VenuePage({
    Key? key,
    required this.name,
    required this.location,
    required this.workingHours,
    required this.rating,
    required this.type,
    required this.description,
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _images = getImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _reserveSpot() {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    if (_selectedDate == null) {
      _showToast('Please select a date');
      return;
    }

    if (_selectedHour == null || _selectedMinute == null) {
      _showToast('Please select a time');
      return;
    }

    if (_selectedNumberOfGuests == null) {
      _showToast('Please select the number of guests');
      return;
    }

    String date = dateFormat.format(_selectedDate!).toString();
    String minutes = _selectedMinute == 0 ? '00' : '30';
    String time = '$_selectedHour:$minutes';

    Navigator.pushNamed(context, Routes.SUCCESSFUL_RESERVATION, arguments: {
      'venueName': widget.name,
      'numberOfPeople': _selectedNumberOfGuests,
      'reservationDate': date,
      'reservationTime': time,
      'userEmail': widget.userEmail,
      'userLocation': widget.userLocation,
    });
  }

  void _showToast(String message) => showToast(
        message,
        context: context,
        backgroundColor: AppThemes.errorColor,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
        borderRadius: BorderRadius.circular(8),
        textPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        alignment: Alignment.bottomLeft,
        duration: const Duration(seconds: 4),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CustomAppbar(
          title: widget.name,
          routeToPush: Routes.HOMEPAGE,
          args: {
            'userEmail': widget.userEmail,
            'userLocation': widget.userLocation
          },
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

            final images = snapshot.data!;
            return Stack(
              alignment: const AlignmentDirectional(0, 1),
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeadingImage(images[0]),
                      _buildObjectDetails(widget.name, widget.location,
                          widget.workingHours, widget.rating),
                      _buildObjectType(widget.type),
                      _buildObjectDescription(widget.description),
                      _buildLeaveRatingButton(),
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
                      _buildDivider(),
                      _buildMasonryView(images.skip(1).toList()),
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
            child: Image.network(
              image,
              width: double.infinity,
              height: 320,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );

  Flexible _buildObjectType(String type) => Flexible(
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
            child: Text(
              'Type: $type',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      );

  Flexible _buildObjectDescription(String description) => Flexible(
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 0, 16),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
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
              onPressed: () => {},
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

  Padding _buildObjectDetails(
          String name, String location, String workingHours, double rating) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Column(
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Text(
                location,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Text(
                'Working hours: $workingHours',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: RatingBar.builder(
                onRatingUpdate: (value) => {},
                itemBuilder: (context, index) => Icon(
                  CupertinoIcons.star_fill,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                unratedColor: Theme.of(context).colorScheme.onPrimary,
                direction: Axis.horizontal,
                glow: false,
                ignoreGestures: true,
                initialRating: rating,
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
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
        child: FFButtonWidget(
          onPressed: onPressed,
          text: 'Reserve your spot now',
          options: FFButtonOptions(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: Theme.of(context).colorScheme.onPrimary,
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
                  child: Image.network(
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
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      );
}
