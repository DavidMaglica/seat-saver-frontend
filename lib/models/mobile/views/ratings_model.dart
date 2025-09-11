import 'package:flutter/material.dart';
import 'package:seat_saver/api/data/basic_response.dart';
import 'package:seat_saver/api/data/rating.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/utils/toaster.dart';

class RatingsPageModel extends ChangeNotifier {
  final int venueId;
  final VenuesApi venuesApi;

  RatingsPageModel({required this.venueId, VenuesApi? venuesApi})
    : venuesApi = venuesApi ?? VenuesApi();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode commentFocusNode = FocusNode();
  final TextEditingController commentTextController = TextEditingController();

  List<Rating>? ratings;
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

  void init(BuildContext context) {
    _loadVenue(context);
    _loadReviews(context);
  }

  Future<void> _loadVenue(BuildContext context) async {
    try {
      final loadedVenue = await venuesApi.getVenue(venueId);
      if (loadedVenue == null) {
        if (!context.mounted) return;
        Toaster.displayError(context, 'Failed to load venue data');
        return;
      }
      venue = loadedVenue;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      Toaster.displayError(
        context,
        'Failed to load venue. Please try again later.',
      );
    }
  }

  Future<void> _loadReviews(BuildContext context) async {
    try {
      ratings = await venuesApi.getAllVenueRatings(venueId);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      Toaster.displayError(
        context,
        'Failed to load reviews. Please try again later.',
      );
    }
  }

  Future<void> rateVenue(
    BuildContext context,
    int userId,
    double newRating,
    String comment,
  ) async {
    BasicResponse response = await venuesApi.rateVenue(
      venueId,
      newRating,
      userId,
      comment,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (response.success) {
      Toaster.displaySuccess(context, 'Rating updated successfully');
    } else {
      Toaster.displayError(context, response.message);
    }

    final updatedRating = await venuesApi.getVenueRating(venueId);
    if (updatedRating == null) {
      if (!context.mounted) return;
      Toaster.displayError(context, 'Error fetching updated rating');
      return;
    }

    if (!context.mounted) return;
    Toaster.displaySuccess(context, 'Thanks for your feedback!');

    venue.rating = updatedRating;
    commentTextController.clear();
    commentFocusNode.unfocus();
    ratings = await venuesApi.getAllVenueRatings(venueId);

    notifyListeners();
  }
}
