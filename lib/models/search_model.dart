import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../api/data/venue.dart';
import '../api/venue_api.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class SearchModel extends ChangeNotifier {
  final BuildContext context;
  final String? userEmail;
  final Position? userLocation;
  final int? selectedVenueType;

  final FocusNode unfocusNode = FocusNode();
  final int pageIndex = 1;
  final TextEditingController searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final VenueApi venueApi = VenueApi();

  List<String> venueTypeOptions = [];
  List<String> selectedTypes = [];
  List<Venue> allVenues = [];
  Map<int, String> venueTypeMap = {};

  SearchModel({
    required this.context,
    required this.userEmail,
    required this.userLocation,
    this.selectedVenueType,
  });

  @override
  void dispose() {
    searchBarController.dispose();
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await _loadData();

    notifyListeners();
  }

  Future<void> _loadData() async {
    final venueTypes = await venueApi.getAllVenueTypes();
    final venues = await venueApi.getAllVenuesFromApi();
    venues.sort((a, b) => a.name.compareTo(b.name));

    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
    venueTypeOptions = venueTypeMap.values.toList();
    allVenues = venues;

    final selectedType = venueTypeMap[selectedVenueType];
    if (selectedType != null) {
      selectedTypes.add(selectedType);
      allVenues =
          venues.where((venue) => venue.typeId == selectedVenueType).toList();
    }
  }

  Future<void> getAllVenues() async {
    final venues = await venueApi.getAllVenuesFromApi();
    venues.sort((a, b) => a.name.compareTo(b.name));
    allVenues = venues;
    notifyListeners();
  }

  void search(String value) async {
    if (value.isEmpty) {
      await getAllVenues();
      return;
    }

    final filtered = allVenues
        .where(
            (venue) => venue.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    allVenues = filtered;
    notifyListeners();
  }

  void filterVenues(List<String> selectedTypeLabels) async {
    if (selectedTypeLabels.isEmpty) {
      await getAllVenues();
      return;
    }

    final selectedTypeIds = venueTypeMap.entries
        .where((e) => selectedTypeLabels.contains(e.value))
        .map((e) => e.key)
        .toList();

    final venues = await venueApi.getAllVenuesFromApi();
    allVenues = venues
        .where((venue) => selectedTypeIds.contains(venue.typeId))
        .toList();

    notifyListeners();
  }

  Function() goToVenuePage(Venue venue) =>
          () => Navigator.pushNamed(context, Routes.venue, arguments: {
        'venueId': venue.id,
        'userEmail': userEmail,
        'userLocation': userLocation,
      });

}
