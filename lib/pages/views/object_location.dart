import 'package:diplomski/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/object_location_api.dart';
import '../../components/appbar.dart';
import '../../utils/full_image_view.dart';

class ObjectLocation extends StatefulWidget {
  const ObjectLocation({super.key});

  @override
  State<ObjectLocation> createState() => _ObjectLocationState();
}

class _ObjectLocationState extends State<ObjectLocation> {
  late Future<List<String>> _images;
  double? _ratingBarValue;
  DateTime? _selectedDate;
  int? _selectedNumberOfGuests;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _images = getImages();
    _ratingBarValue = 3.5;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppbar(title: 'Object Location'),
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
                      _buildObjectDetails(
                          'Object Name', 'Location', '8:00 AM - 10:00 PM'),
                      _buildObjectType('Restaurant'),
                      _buildObjectDescription(
                        'Description provided by object Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin accumsan eu sapien vitae tincidunt. Fusce quis dui mauris. Vivamus quam leo, vestibulum in mi non, rhoncus elementum purus.',
                      ),
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

  void _reserveSpot() => debugPrint('Reserve your spot now');

  Widget _buildHeadingImage(String image) => Padding(
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

  Widget _buildObjectType(String type) => Flexible(
        child: Align(
          alignment: const AlignmentDirectional(-1, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
            child: Text(
              'Type: Restaurant',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );

  Widget _buildObjectDescription(String description) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
        child: Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );

  Widget _buildObjectDetails(
          String name, String location, String workingHours) =>
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
                onRatingUpdate: (newValue) =>
                    setState(() => _ratingBarValue = newValue),
                itemBuilder: (context, index) => Icon(
                  CupertinoIcons.star_fill,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                unratedColor: Theme.of(context).colorScheme.onPrimary,
                direction: Axis.horizontal,
                glow: false,
                ignoreGestures: true,
                initialRating: _ratingBarValue ??= 0,
                itemSize: 24,
                allowHalfRating: true,
              ),
            )
          ],
        ),
      );

  Widget _buildDatePickerButton() {
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
          height: 250,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumDate:
                        DateTime.now().subtract(const Duration(days: 1)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (DateTime newDate) {
                      _selectedDate = newDate;
                      debugPrint('Selected date: $_selectedDate');
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumberOfGuestsButton() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: FFButtonWidget(
          onPressed: () {
            _buildNumberOfGuestsPicker();
          },
          text: _selectedNumberOfGuests?.toString() ?? 'Select no. of guests',
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
          height: 250,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int selectedIndex) {
                    _selectedNumberOfGuests = selectedIndex+1;
                    debugPrint('Selected number of guests: $_selectedNumberOfGuests');
                  },
                  children: List<Widget>.generate(10, (int index) {
                    return Center(
                      child: Text(
                        '${index+1}',
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

  Widget _buildTimePickerButton() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
        child: FFButtonWidget(
          onPressed: () {
            _buildTimePicker();
          },
          text: 'Select time',
          icon: const Icon(
            CupertinoIcons.clock,
            size: 18,
          ),
          options: _selectorButtonOptions(),
        ),
      );

  Future<dynamic> _buildTimePicker() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = DateTime.now().hour;
        int selectedMinute = DateTime.now().minute;

        return Container(
          height: 250,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                          debugPrint('Selected hour: $selectedHour');
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedHour,
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
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedMinute = index;
                          debugPrint('Selected minute: $selectedMinute');
                        },
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinute,
                        ),
                        children: List<Widget>.generate(60, (int index) {
                          return Center(
                            child: Text(
                              '$index'.padLeft(2, '0'),
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
                    debugPrint('Selected time: $selectedHour:$selectedMinute');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReserveSpotButton(Function() onPressed) => Padding(
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

  Widget _buildMasonryView(List<String> imageUrls) => Padding(
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

  Widget _buildDivider() => Divider(
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
