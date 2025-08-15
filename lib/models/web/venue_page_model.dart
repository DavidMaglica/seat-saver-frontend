import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/file_picker/file_picker_interface.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class VenuePageModel extends FlutterFlowModel<WebVenuePage>
    with ChangeNotifier {
  final int venueId;

  VenuePageModel({required this.venueId});

  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  PageController pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 1.0,
  );

  int get pageViewCurrentIndex =>
      pageViewController.hasClients && pageViewController.page != null
      ? pageViewController.page!.round()
      : 0;

  final VenueApi venueApi = VenueApi();

  final Map<String, AnimationInfo> animationsMap =
      Animations.venuePageAnimations;

  Uint8List? headerImage;

  Venue loadedVenue = Venue(
    id: 0,
    name: "",
    location: "",
    workingHours: "",
    maximumCapacity: 0,
    availableCapacity: 0,
    rating: 0,
    typeId: 0,
    description: "",
  );
  String venueType = '';
  int lifetimeReservations = 0;

  final int averageRating = 0;
  final List<Rating> reviews = [];

  List<Uint8List> venueImages = [];
  List<Uint8List> menuImages = [];

  @override
  void initState(BuildContext context) {}

  void fetchData(BuildContext context) {
    _fetchVenue(context);
    _fetchReviews(context);
    _fetchVenueImages(context);
    _fetchMenuImages(context);
  }

  void initTabBarController(TickerProvider vsync) {
    tabBarController = TabController(vsync: vsync, length: 3, initialIndex: 0)
      ..addListener(notifyListeners);
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController?.dispose();
  }

  Future<void> _fetchVenue(BuildContext context) async {
    Venue? venue = await venueApi.getVenue(venueId);

    if (venue != null) {
      if (venue.description.isNullOrEmpty) {
        venue.description = 'No description available';
      }
      loadedVenue = venue;

      venueType =
          await venueApi.getVenueType(venue.typeId) ?? 'No type available';

      // TODO: Fetch lifetime reservations count once decided how to implement it after dashboard
      notifyListeners();
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Failed to load venue data. Please try again later.',
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _fetchReviews(BuildContext context) async {
    List<Rating> ratings = await venueApi.getAllVenueRatings(venueId);

    reviews.addAll(ratings);
    notifyListeners();
  }

  Future<void> _fetchVenueImages(BuildContext context) async {
    List<Uint8List>? images = await venueApi.getVenueImages(venueId);

    venueImages = images;
    notifyListeners();
  }

  Future<void> _fetchMenuImages(BuildContext context) async {
    List<Uint8List> images = await venueApi.getMenuImages(venueId);

    menuImages = images;
    notifyListeners();
  }

  Future<void> addVenueImages() async {
    await imagePicker(false);
  }

  Future<void> addMenuImages() async {
    await imagePicker(false);
  }
}
