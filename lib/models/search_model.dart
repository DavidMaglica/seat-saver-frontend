import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/api/venue_api.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:TableReserver/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchModel extends ChangeNotifier {
  final BuildContext context;
  final int? selectedVenueType;

  final FocusNode unfocusNode = FocusNode();
  final int pageIndex = 1;
  final TextEditingController searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final VenueApi venueApi = VenueApi();

  List<String> venueTypeOptions = [];
  List<String> selectedTypes = [];

  List<Venue> allVenuesMaster = [];
  List<Venue> allVenues = [];
  Map<int, String> venueTypeMap = {};

  SearchModel({
    required this.context,
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
    final venues = await venueApi.getAllVenues();
    venues.sort((a, b) => a.name.compareTo(b.name));

    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
    venueTypeOptions = venueTypeMap.values.toList();

    allVenuesMaster = venues;
    allVenues = List.from(venues);

    final selectedType = venueTypeMap[selectedVenueType];
    if (selectedType != null) {
      selectedTypes.add(selectedType);
      allVenues =
          venues.where((venue) => venue.typeId == selectedVenueType).toList();
    }
  }

  void search(String value) async {
    if (value.isEmpty) {
      if (selectedTypes.isEmpty) {
        allVenues = List.from(allVenuesMaster);
      } else {
        filterVenues(selectedTypes);
      }
      notifyListeners();
      return;
    }

    final lowerQuery = value.toLowerCase();
    var filtered = allVenuesMaster
        .where((venue) => venue.name.toLowerCase().contains(lowerQuery))
        .toList();

    if (selectedTypes.isNotEmpty) {
      List<int> selectedTypeIds = venueTypeMap.entries
          .where((e) => selectedTypes.contains(e.value))
          .map((e) => e.key)
          .toList();

      filtered = filtered
          .where((venue) => selectedTypeIds.contains(venue.typeId))
          .toList();
    }

    allVenues = filtered;
    notifyListeners();
  }

  void filterVenues(List<String> selectedTypeLabels) {
    selectedTypes = selectedTypeLabels;

    if (selectedTypes.isEmpty) {
      allVenues = List.from(allVenuesMaster);
      notifyListeners();
      return;
    }

    final selectedTypeIds = venueTypeMap.entries
        .where((e) => selectedTypeLabels.contains(e.value))
        .map((e) => e.key)
        .toList();

    allVenues = allVenuesMaster
        .where((venue) => selectedTypeIds.contains(venue.typeId))
        .toList();

    notifyListeners();
  }

  void clearFilters() {
    selectedTypes.clear();
    allVenues = List.from(allVenuesMaster);
    notifyListeners();
  }

  Function() goToVenuePage(
    Venue venue,
    int? userId,
    Position? userLocation,
  ) =>
      () => Navigator.pushNamed(
            context,
            Routes.venue,
            arguments: {
              'venueId': venue.id,
              'userId': userId,
              'userLocation': userLocation,
            },
          );
}
