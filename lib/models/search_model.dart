import 'dart:async';

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

  Timer? _debounce;

  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMorePages = true;
  bool isLoading = false;
  List<Venue> paginatedVenues = [];

  List<int> selectedTypeIds = [];
  String searchQuery = '';

  final ScrollController scrollController = ScrollController();

  final VenueApi venueApi = VenueApi();

  List<String> venueTypeOptions = [];
  List<String> selectedTypes = [];

  Map<int, String> venueTypeMap = {};

  SearchModel({
    required this.context,
    this.selectedVenueType,
  });

  @override
  void dispose() {
    _debounce?.cancel();
    searchBarController.dispose();
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await _loadData();
    await _loadVenueTypes();
    await _fetchNextPage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 50) {
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
    PagedResponse<Venue> venues = await venueApi.getAllVenues(
      _currentPage,
      _pageSize,
      null,
      null,
    );

    venues.content.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _fetchNextPage() async {
    if (isLoading || !hasMorePages) return;

    isLoading = true;

    PagedResponse<Venue> paged = await venueApi.getAllVenues(
      _currentPage,
      _pageSize,
      searchQuery.isEmpty ? null : searchQuery,
      selectedTypeIds.isEmpty ? null : selectedTypeIds,
    );

    paginatedVenues.addAll(paged.content);
    hasMorePages = _currentPage < paged.totalPages - 1;
    _currentPage++;

    isLoading = false;
    notifyListeners();
  }

  void search(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery = value.trim();
      _refreshPagedResults();
    });
  }

  void filterVenues(List<String> selectedTypeLabels) {
    selectedTypes = selectedTypeLabels;

    selectedTypeIds = venueTypeMap.entries
        .where((e) => selectedTypeLabels.contains(e.value))
        .map((e) => e.key)
        .toList();

    _refreshPagedResults();
  }

  void clearFilters() {
    selectedTypes.clear();
    selectedTypeIds.clear();
    searchQuery = '';
    _refreshPagedResults();
  }

  void _refreshPagedResults() {
    paginatedVenues.clear();
    _currentPage = 0;
    hasMorePages = true;
    _fetchNextPage();
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
