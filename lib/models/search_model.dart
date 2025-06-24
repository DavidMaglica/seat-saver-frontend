import 'package:TableReserver/api/data/paged_response.dart';
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

  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMorePages = true;
  bool isLoading = false;
  List<Venue> paginatedVenues = [];

  final ScrollController scrollController = ScrollController();

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

  // TODO: IMPLEMENT SEARCH AND FILTERS

  Future<void> init() async {
    await _loadData();
    await _loadVenueTypes();
    await _fetchNextPage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
          if (!isLoading && hasMorePages) {
            _fetchNextPage();
          }
        }
      });
    });

    notifyListeners();
  }

  Future<void> _loadVenueTypes() async {
    final venueTypes = await venueApi.getAllVenueTypes();
    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
    venueTypeOptions = venueTypeMap.values.toList();
  }

  Future<void> _loadData() async {
    PagedResponse<Venue> venues =
        await venueApi.getAllVenues(_currentPage, _pageSize);

    venues.content.sort((a, b) => a.name.compareTo(b.name));

    allVenuesMaster = venues.content;
    allVenues = List.from(venues.content);

    final selectedType = venueTypeMap[selectedVenueType];
    if (selectedType != null) {
      selectedTypes.add(selectedType);
      allVenues = venues.content
          .where((venue) => venue.typeId == selectedVenueType)
          .toList();
    }
  }

  Future<void> _fetchNextPage() async {
    isLoading = true;

    PagedResponse<Venue> paged = await venueApi.getAllVenues(
      _currentPage,
      _pageSize,
    );

    paginatedVenues = List.from(paginatedVenues)..addAll(paged.content);
    hasMorePages = _currentPage < paged.totalPages;
    _currentPage++;

    isLoading = false;
    notifyListeners();
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
