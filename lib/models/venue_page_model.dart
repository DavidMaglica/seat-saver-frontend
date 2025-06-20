import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/api/reservation_api.dart';
import 'package:TableReserver/api/venue_api.dart';
import 'package:TableReserver/components/toaster.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class VenuePageModel extends ChangeNotifier {
  final BuildContext ctx;
  final int venueId;
  final List<String>? imageLinks;
  final int? userId;
  final Position? userLocation;

  Future<List<String>>? images;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();
  int? selectedNumberOfPeople;
  List<String>? venueImages;
  String venueType = '';
  Venue venue = Venue(
    id: 0,
    name: '',
    location: '',
    workingHours: '',
    maximumCapacity: 0,
    availableCapacity: 0,
    rating: 0.0,
    typeId: 1,
    description: '',
  );
  final List<TimeOfDay> timeOptions = List.generate(
    48,
    (index) {
      final hour = index ~/ 2;
      final minute = (index % 2) * 30;
      if (hour >= 24) {
        return const TimeOfDay(hour: 23, minute: 30);
      }
      return TimeOfDay(hour: hour, minute: minute);
    },
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final ReservationApi reservationApi = ReservationApi();
  final VenueApi venueApi = VenueApi();

  VenuePageModel({
    required this.ctx,
    required this.venueId,
    this.imageLinks,
    this.userId,
    this.userLocation,
  });

  Future<void> init() async {
    await _loadData();
    await _loadImages();
    final currentTime = _roundToNearestHalfHour(
        TimeOfDay(hour: selectedTime!.hour, minute: selectedTime!.minute));
    selectedTime = addOneHour(currentTime);
    notifyListeners();
  }

  Future<void> _loadData() async {
    final loadedVenue = await venueApi.getVenue(venueId);
    if (loadedVenue == null) {
      if (!ctx.mounted) return;
      Toaster.displayError(ctx, 'Failed to load venue data');
      return;
    }
    venue = loadedVenue;
    final loadedVenueType = await venueApi.getVenueType(venue.typeId);
    if (loadedVenueType == null) {
      if (!ctx.mounted) return;
      Toaster.displayError(ctx, 'Failed to load venue type');
      return;
    }
    venueType = loadedVenueType;
  }

  Future<void> _loadImages() async {
    if (imageLinks != null && imageLinks!.isNotEmpty) {
      images = Future.value(imageLinks);
    } else {
      images = Future.value(venueApi.getVenueImages(venue.name));
      venueImages = venueApi.getVenueImages(venue.name);
    }
  }

  TimeOfDay _roundToNearestHalfHour(TimeOfDay time) {
    int hour = time.hour;
    int minute = time.minute;

    if (minute < 15) {
      minute = 0;
    } else if (minute < 45) {
      minute = 30;
    } else {
      minute = 0;
      hour = (hour + 1) % 24;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay addOneHour(TimeOfDay time) {
    return TimeOfDay(hour: (time.hour + 1) % 24, minute: time.minute);
  }

  bool _validateInput() {
    final validationErrors = [
      if (userId == null) 'Please log in to reserve a spot',
      if (selectedDate == null) 'Please select a date',
      if (selectedTime == null) 'Please select a time',
      if (selectedNumberOfPeople == null) 'Please select the number of people',
    ];

    if (validationErrors.isNotEmpty) {
      Toaster.displayError(ctx, validationErrors.first);
      return false;
    }

    return true;
  }

  void selectDate(BuildContext ctx) async {
    DateTime? minDate = DateTime.now();
    DateTime? maxDate = DateTime.now().add(const Duration(days: 31));

    final date = await _showDatePicker(ctx, maxDate, minDate);

    if (date == null) return;

    if (selectedDate != null && date == selectedDate) {
      selectedDate = null;
      notifyListeners();
      return;
    }

    final parsedDate = DateUtils.dateOnly(date);
    selectedDate = parsedDate;

    notifyListeners();
  }

  Future<void> reserve() async {
    if (!_validateInput()) return;

    DateTime reservationDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    BasicResponse response = await reservationApi.createReservation(
      userId!,
      venueId,
      selectedNumberOfPeople!,
      reservationDateTime,
    );
    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

    if (!response.success) {
      Toaster.displayError(ctx, response.message);
      return;
    }

    Navigator.pushNamed(ctx, Routes.successfulReservation, arguments: {
      'venueName': venue.name,
      'numberOfGuests': selectedNumberOfPeople,
      'reservationDateTime': reservationDateTime,
      'userId': userId,
      'userLocation': userLocation,
    });

    return;
  }

  void setPeople(int? value) {
    if (value != null) {
      if (selectedNumberOfPeople != null && selectedNumberOfPeople == value) {
        selectedNumberOfPeople = null;
      } else {
        selectedNumberOfPeople = value;
      }
      notifyListeners();
    }
  }

  void setTime(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      if (selectedTime != null &&
          selectedTime!.hour == timeOfDay.hour &&
          selectedTime!.minute == timeOfDay.minute) {
        selectedTime = null;
      } else {
        selectedTime = timeOfDay;
      }

      TimeOfDay currentTime = _roundToNearestHalfHour(TimeOfDay.now());

      if (!isBeforeOrEqual(currentTime, selectedTime!)) {
        if (!ctx.mounted) return;
        Toaster.displayWarning(ctx, 'Please select a different time');
        selectedTime = null;
      }

      notifyListeners();
    }
  }

  Future<DateTime?> _showDatePicker(
    BuildContext ctx,
    DateTime maxDate,
    DateTime minDate,
  ) {
    return showDatePickerDialog(
      context: ctx,
      maxDate: maxDate,
      minDate: minDate,
      selectedDate: selectedDate,
      centerLeadingDate: true,
      slidersColor: Theme.of(ctx).colorScheme.onPrimary,
      currentDateTextStyle: Theme.of(ctx).textTheme.bodyMedium,
      currentDateDecoration: const BoxDecoration(
        color: AppThemes.transparentColour,
        shape: BoxShape.circle,
        border: Border(
          top: BorderSide(
            color: AppThemes.infoColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: AppThemes.infoColor,
            width: 1,
          ),
          left: BorderSide(
            color: AppThemes.infoColor,
            width: 1,
          ),
          right: BorderSide(
            color: AppThemes.infoColor,
            width: 1,
          ),
        ),
      ),
      selectedCellTextStyle:
          Theme.of(ctx).textTheme.titleMedium?.copyWith(color: Colors.white),
      selectedCellDecoration: const BoxDecoration(
        color: AppThemes.infoColor,
        shape: BoxShape.circle,
      ),
      enabledCellsTextStyle: Theme.of(ctx).textTheme.bodyMedium,
      disabledCellsTextStyle: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
            color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.4),
          ),
      leadingDateTextStyle: Theme.of(ctx)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold),
      daysOfTheWeekTextStyle: Theme.of(ctx)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  bool isBeforeOrEqual(TimeOfDay currentTime, TimeOfDay selectedTime) {
    final now = DateTime.now();

    final current = DateTime(
      now.year,
      now.month,
      now.day,
      currentTime.hour,
      currentTime.minute,
    );

    final selected = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    return current.isBefore(selected) || current.isAtSameMomentAs(selected);
  }
}
