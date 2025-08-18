import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/toaster.dart';
import 'package:flutter/material.dart';

class RatingsPageModel extends ChangeNotifier {
  final BuildContext ctx;
  final int venueId;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final VenueApi venueApi = VenueApi();

  final FocusNode commentFocusNode = FocusNode();
  final TextEditingController commentTextController = TextEditingController();

  List<Rating>? ratings;
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

  RatingsPageModel({
    required this.ctx,
    required this.venueId,
  });

  void init() {
    _loadVenue();
    _loadReviews();
  }

  Future<void> _loadVenue() async {
    try {
      final loadedVenue = await venueApi.getVenue(venueId);
      if (loadedVenue == null) {
        if (!ctx.mounted) return;
        Toaster.displayError(ctx, 'Failed to load venue data');
        return;
      }
      venue = loadedVenue;
      notifyListeners();
    } catch (e) {
      if (!ctx.mounted) return;
      Toaster.displayError(
          ctx, 'Failed to load venue. Please try again later.');
    }
  }

  Future<void> _loadReviews() async {
    try {
      ratings = await venueApi.getAllVenueRatings(venueId);
      notifyListeners();
    } catch (e) {
      if (!ctx.mounted) return;
      Toaster.displayError(
          ctx, 'Failed to load reviews. Please try again later.');
    }
  }

  Future<void> rateVenue(int userId, double newRating, String comment) async {
    BasicResponse response =
        await venueApi.rateVenue(venueId, newRating, userId, comment);

    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

    if (response.success) {
      Toaster.displaySuccess(ctx, 'Rating updated successfully');
    } else {
      Toaster.displayError(ctx, response.message);
    }

    final updatedRating = await venueApi.getVenueRating(venueId);
    if (updatedRating == null) {
      if (!ctx.mounted) return;
      Toaster.displayError(ctx, 'Error fetching updated rating');
      return;
    }

    if (!ctx.mounted) return;
    Toaster.displaySuccess(ctx, 'Thanks for your feedback!');

    venue.rating = updatedRating;
    commentTextController.clear();
    commentFocusNode.unfocus();
    ratings = await venueApi.getAllVenueRatings(venueId);

    notifyListeners();
  }
}
