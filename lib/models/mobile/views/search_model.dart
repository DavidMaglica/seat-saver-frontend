import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class SearchModel extends ChangeNotifier {
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

  final VenuesApi venuesApi;

  List<String> venueTypeOptions = [];
  List<String> selectedTypes = [];

  Map<int, String> venueTypeMap = {};

  SearchModel({this.selectedVenueType, VenuesApi? venuesApi})
    : venuesApi = venuesApi ?? VenuesApi();

  @override
  void dispose() {
    _debounce?.cancel();
    searchBarController.dispose();
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> init(String? locationQuery) async {
    await _loadVenueTypes();
    await _fetchNextPage(locationQuery);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 50) {
          if (!isLoading && hasMorePages) {
            _fetchNextPage(locationQuery);
          }
        }
      });
    });

    notifyListeners();
  }

  Future<void> _loadVenueTypes() async {
    final venueTypes = await venuesApi.getAllVenueTypes();
    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
    venueTypeOptions = venueTypeMap.values.toList();
  }

  Future<void> _fetchNextPage(String? locationQuery) async {
    if (isLoading || !hasMorePages) return;

    isLoading = true;

    if (locationQuery.isNotNullAndNotEmpty) {
      searchQuery = locationQuery!;
      searchBarController.text = locationQuery;
    }

    PagedResponse<Venue> pagedVenues = await venuesApi.getAllVenues(
      _currentPage,
      _pageSize,
      searchQuery.isEmpty ? null : searchQuery,
      selectedTypeIds.isEmpty ? null : selectedTypeIds,
    );

    paginatedVenues.addAll(pagedVenues.items);
    hasMorePages = _currentPage < pagedVenues.totalPages - 1;
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
    _fetchNextPage(null);
  }

  Function() goToVenuePage(BuildContext context, Venue venue) {
    return () {
      Navigator.of(context).push(
        MobileFadeInRoute(
          page: VenuePage(venueId: venue.id),
          routeName: Routes.venue,
          arguments: {'venueId': venue.id},
        ),
      );
    };
  }
}
