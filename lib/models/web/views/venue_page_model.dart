import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/rating.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/reservation_api.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/file_data.dart';
import 'package:table_reserver/utils/file_picker/file_picker_interface.dart';
import 'package:table_reserver/utils/venue_image_cache/venue_image_cache_interface.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class VenuePageModel extends FlutterFlowModel<WebVenuePage>
    with ChangeNotifier {
  final int venueId;
  final bool? shouldOpenReviewsTab;
  final bool? shouldOpenImagesTab;

  VenuePageModel({
    required this.venueId,
    this.shouldOpenReviewsTab,
    this.shouldOpenImagesTab,
  });

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

  final VenuesApi venuesApi = VenuesApi();
  final ReservationsApi reservationsApi = ReservationsApi();

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

  double get venueRating => loadedVenue.rating;

  String venueType = '';
  int lifetimeReservations = 0;

  final int averageRating = 0;
  final List<Rating> reviews = [];

  bool isVenueImagesLoading = true;
  bool isMenuImagesLoading = true;
  List<Uint8List> venueImages = [];
  List<Uint8List> menuImages = [];

  @override
  void initState(BuildContext context) {}

  void init(BuildContext context, TickerProvider vsync) {
    initTabBarController(context, vsync);
    if (shouldOpenReviewsTab == true) {
      _fetchReviews(context);
    }
    if (shouldOpenImagesTab == true) {
      _fetchVenueImages(context);
      _fetchMenuImages(context);
    }
    fetchData(context);
  }

  void fetchData(BuildContext context) {
    fetchVenue(context);
    _fetchHeaderImage(context);
  }

  void initTabBarController(BuildContext context, TickerProvider vsync) {
    tabBarController = TabController(
      vsync: vsync,
      length: 3,
      initialIndex: shouldOpenReviewsTab == true
          ? 1
          : shouldOpenImagesTab == true
          ? 2
          : 0,
    )..addListener(notifyListeners);

    tabBarController?.addListener(() {
      final index = tabBarController!.index;

      switch (index) {
        case 0:
          break;
        case 1:
          fetchVenue(context);
          _fetchReviews(context);
          break;
        case 2:
          isVenueImagesLoading = true;
          isMenuImagesLoading = true;
          _fetchVenueImages(context);
          _fetchMenuImages(context);
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController?.dispose();
  }

  Future<void> fetchVenue(BuildContext context) async {
    int ownerId = prefsWithCache.getInt('ownerId')!;
    Venue? venue = await venuesApi.getVenue(venueId);

    if (venue != null) {
      if (venue.description.isNullOrEmpty) {
        venue.description = 'Description has not been provided.';
      }
      loadedVenue = venue;

      String? venueType = await venuesApi.getVenueType(venue.typeId);
      if (venueType != null) {
        this.venueType = venueType.toTitleCase();
      } else {
        this.venueType = 'Unknown';
      }

      lifetimeReservations = await reservationsApi.getReservationCount(
        ownerId,
        venueId: venue.id,
      );
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

  Future<void> _fetchHeaderImage(BuildContext context) async {
    final Uint8List? cachedImage = VenueImageCache.getImage(venueId);
    if (cachedImage != null) {
      headerImage = cachedImage;
      notifyListeners();
      return;
    }

    Uint8List? image = await venuesApi.getVenueHeaderImage(venueId);

    if (image != null) {
      headerImage = image;
      notifyListeners();
    }
  }

  Future<void> _fetchReviews(BuildContext context) async {
    List<Rating> ratings = await venuesApi.getAllVenueRatings(venueId);

    if (reviews.isNotEmpty) {
      reviews.clear();
    }
    reviews.addAll(ratings);
    notifyListeners();
  }

  Future<void> _fetchVenueImages(BuildContext context) async {
    List<Uint8List>? images = await venuesApi.getVenueImages(venueId);

    venueImages = images;
    isVenueImagesLoading = false;
    notifyListeners();
  }

  Future<void> _fetchMenuImages(BuildContext context) async {
    List<Uint8List> images = await venuesApi.getMenuImages(venueId);

    menuImages = images;
    isMenuImagesLoading = false;
    notifyListeners();
  }

  Future<void> addVenueImage(BuildContext context) async {
    try {
      final FileData? file = await imagePicker();

      if (file == null) {
        if (!context.mounted) return;
        WebToaster.displayError(context, 'No image selected.');
        return;
      }

      final response = await venuesApi.uploadVenueImage(
        venueId,
        file.imageBytes,
        file.filename,
      );

      if (!context.mounted) return;
      if (response.success) {
        WebToaster.displaySuccess(context, response.message);
        _fetchVenueImages(context);
      } else {
        WebToaster.displayError(context, response.message);
      }
    } catch (e) {
      if (!context.mounted) return;
      WebToaster.displayError(context, '$e');
    }
  }

  Future<void> addMenuImages(BuildContext context) async {
    try {
      final FileData? file = await imagePicker();

      if (file == null) {
        if (!context.mounted) return;
        WebToaster.displayError(context, 'No image selected.');
        return;
      }

      final response = await venuesApi.uploadMenuImage(
        venueId,
        file.imageBytes,
        file.filename,
      );

      if (!context.mounted) return;
      if (response.success) {
        WebToaster.displaySuccess(context, response.message);
        _fetchMenuImages(context);
      } else {
        WebToaster.displayError(context, response.message);
      }
    } catch (e) {
      if (!context.mounted) return;
      WebToaster.displayError(context, '$e');
    }
  }
}
