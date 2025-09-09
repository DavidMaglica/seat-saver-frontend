import 'dart:typed_data';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/mobile/views/successful_reservation.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:table_reserver/utils/utils.dart';

class VenuePageModel extends ChangeNotifier {
  final int venueId;
  final int? userId;

  final ReservationsApi reservationsApi;
  final VenuesApi venuesApi;

  VenuePageModel({
    required this.venueId,
    this.userId,
    ReservationsApi? reservationsApi,
    VenuesApi? venuesApi,
  }) : reservationsApi = reservationsApi ?? ReservationsApi(),
       venuesApi = venuesApi ?? VenuesApi();

  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();
  int? selectedNumberOfPeople;

  String venueType = '';
  Venue venue = Venue(
    id: 0,
    name: '',
    location: '',
    workingDays: [],
    workingHours: '',
    maximumCapacity: 0,
    availableCapacity: 0,
    rating: 0.0,
    typeId: 1,
    description: '',
  );
  final List<TimeOfDay> timeOptions = List.generate(48, (index) {
    final hour = index ~/ 2;
    final minute = (index % 2) * 30;
    if (hour >= 24) {
      return const TimeOfDay(hour: 23, minute: 30);
    }
    return TimeOfDay(hour: hour, minute: minute);
  });

  List<Uint8List>? venueImageBytes;
  Uint8List? venueHeadingImage;
  List<Uint8List>? menuImageBytes;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> init(BuildContext context) async {
    await _loadData(context);
    await _loadImages();
    final currentTime = _roundToNearestHalfHour(
      TimeOfDay(hour: selectedTime!.hour, minute: selectedTime!.minute),
    );
    selectedTime = addOneHour(currentTime);
    notifyListeners();
  }

  Future<void> _loadData(BuildContext context) async {
    final loadedVenue = await venuesApi.getVenue(venueId);
    if (loadedVenue == null) {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to load venue data');
      return;
    }
    venue = loadedVenue;
    final loadedVenueType = await venuesApi.getVenueType(venue.typeId);
    if (loadedVenueType == null) {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Failed to load venue type');
      return;
    }
    venueType = loadedVenueType;
  }

  Future<void> _loadImages() async {
    venueImageBytes = await venuesApi.getVenueImages(venueId);
    venueHeadingImage = venueImageBytes?.isNotEmpty == true
        ? venueImageBytes!.first
        : null;
    menuImageBytes = await venuesApi.getMenuImages(venueId);
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

  bool _validateInput(BuildContext context) {
    final validationErrors = [
      if (userId == null) 'Please log in to reserve a spot',
      if (selectedDate == null) 'Please select a date',
      if (selectedTime == null) 'Please select a time',
      if (selectedNumberOfPeople == null) 'Please select the number of people',
    ];

    if (validationErrors.isNotEmpty) {
      Toaster.displayError(context, validationErrors.first);
      return false;
    }

    final reservationDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final isWorkingDay = venue.workingDays.contains(
      reservationDateTime.weekday - 1,
    );
    if (!isWorkingDay) {
      Toaster.displayError(
        context,
        'The selected date is not a working day for the venue.',
      );
      return false;
    }

    if (!isWithinWorkingHours(reservationDateTime, venue.workingHours)) {
      Toaster.displayError(
        context,
        'The selected time is outside of the venue\'s working hours.',
      );
      return false;
    }

    return true;
  }

  void selectDate(BuildContext context) async {
    DateTime? minDate = DateTime.now();
    DateTime? maxDate = DateTime.now().add(const Duration(days: 31));

    final date = await _showDatePicker(context, maxDate, minDate);

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

  Future<void> reserve(BuildContext context) async {
    if (!_validateInput(context)) return;

    DateTime reservationDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    BasicResponse response = await reservationsApi.createReservation(
      userId: userId!,
      venueId: venueId,
      numberOfGuests: selectedNumberOfPeople!,
      reservationDate: reservationDateTime,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (!response.success) {
      Toaster.displayError(context, response.message);
      return;
    }

    Navigator.of(context).push(
      MobileFadeInRoute(
        page: SuccessfulReservation(
          venueName: venue.name,
          numberOfGuests: selectedNumberOfPeople!,
          reservationDateTime: reservationDateTime,
        ),
        routeName: Routes.successfulReservation,
        arguments: {
          'venueName': venue.name,
          'numberOfGuests': selectedNumberOfPeople!,
          'reservationDateTime': reservationDateTime,
        },
      ),
    );

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

  void setTime(BuildContext context, TimeOfDay? timeOfDay) {
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
        if (!context.mounted) return;
        Toaster.displayWarning(context, 'Please select a different time');
        selectedTime = null;
      }

      notifyListeners();
    }
  }

  Future<DateTime?> _showDatePicker(BuildContext context,
    DateTime maxDate,
    DateTime minDate,
  ) {
    return showDatePickerDialog(
      context: context,
      maxDate: maxDate,
      minDate: minDate,
      selectedDate: selectedDate,
      centerLeadingDate: true,
      slidersColor: Theme.of(context).colorScheme.onPrimary,
      currentDateTextStyle: Theme.of(context).textTheme.bodyMedium,
      currentDateDecoration: const BoxDecoration(
        color: MobileTheme.transparentColour,
        shape: BoxShape.circle,
        border: Border(
          top: BorderSide(color: MobileTheme.infoColor, width: 1),
          bottom: BorderSide(color: MobileTheme.infoColor, width: 1),
          left: BorderSide(color: MobileTheme.infoColor, width: 1),
          right: BorderSide(color: MobileTheme.infoColor, width: 1),
        ),
      ),
      selectedCellTextStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: Colors.white),
      selectedCellDecoration: const BoxDecoration(
        color: MobileTheme.infoColor,
        shape: BoxShape.circle,
      ),
      enabledCellsTextStyle: Theme.of(context).textTheme.bodyMedium,
      disabledCellsTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.4),
      ),
      leadingDateTextStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      daysOfTheWeekTextStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
