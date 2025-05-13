import 'package:TableReserver/api/data/basic_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../api/reservation_api.dart';
import '../api/venue_api.dart';
import '../components/toaster.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class VenuePageModel extends ChangeNotifier {
  final BuildContext ctx;
  final int venueId;
  final List<String>? imageLinks;
  final String? userEmail;
  final Position? userLocation;

  Future<List<String>>? images;
  DateTime? selectedDate;
  int? selectedHour;
  int? selectedMinute;
  int? selectedNumberOfPeople;
  List<String>? venueImages;
  String venueType = '';
  Venue venue = Venue(
    id: 0,
    name: '',
    location: '',
    workingHours: '',
    rating: 0.0,
    typeId: 1,
    description: '',
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final ReservationApi reservationApi = ReservationApi();
  final VenueApi venueApi = VenueApi();

  VenuePageModel({
    required this.ctx,
    required this.venueId,
    this.imageLinks,
    this.userEmail,
    this.userLocation,
  });

  Future<void> init() async {
    await _loadData();
    await _loadImages();
    notifyListeners();
  }

  Future<void> _loadImages() async {
    if (imageLinks != null && imageLinks!.isNotEmpty) {
      images = Future.value(imageLinks);
    } else {
      images = Future.value(venueApi.getVenueImages(venue.name));
      venueImages = venueApi.getVenueImages(venue.name);
    }
  }

  Future<void> _loadData() async {
    venue = await venueApi.getVenue(venueId);
    venueType = await venueApi.getVenueType(venue.typeId);
  }

  bool _validateInput() {
    final validationErrors = [
      if (userEmail.isNullOrEmpty) 'Please log in to reserve a spot',
      if (selectedDate == null) 'Please select a date',
      if (selectedHour == null || selectedMinute == null)
        'Please select a time',
      if (selectedNumberOfPeople == null) 'Please select the number of people',
    ];

    if (validationErrors.isNotEmpty) {
      Toaster.displayError(ctx, validationErrors.first);
      return false;
    }

    return true;
  }

  Future<void> reserve() async {
    if (!_validateInput()) return;

    DateTime reservationDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedHour!,
      selectedMinute!,
    );

    BasicResponse response = await reservationApi.addReservation(
      userEmail!,
      venueId,
      selectedNumberOfPeople!,
      reservationDateTime,
    );

    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

    if (!response.success) {
      Toaster.displayError(ctx, 'Error reserving venue');
      return;
    }

    Navigator.pushNamed(ctx, Routes.SUCCESSFUL_RESERVATION, arguments: {
      'venueName': venue.name,
      'numberOfGuests': selectedNumberOfPeople,
      'reservationDateTime': reservationDateTime,
      'userEmail': userEmail,
      'userLocation': userLocation,
    });

    return;
  }

  Future<void> rateVenue(double newRating) async {
    BasicResponse response = await venueApi.rateVenue(venueId, newRating);
    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    if (response.success) {
      Toaster.displaySuccess(ctx, 'Rating updated successfully');
    } else {
      Toaster.displayError(ctx, 'Error updating rating');
    }
  }
}
