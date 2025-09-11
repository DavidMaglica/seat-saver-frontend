import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:seat_saver/api/data/paged_response.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/api/venue_api.dart';
import 'package:seat_saver/main.dart';
import 'package:seat_saver/pages/web/views/venues.dart';
import 'package:seat_saver/utils/animations.dart';

class VenuesModel extends FlutterFlowModel<WebVenuesPage> with ChangeNotifier {
  final VenuesApi venuesApi;

  VenuesModel({VenuesApi? venuesApi}) : venuesApi = venuesApi ?? VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.venuesAnimations;

  final ScrollController scrollController = ScrollController();

  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMorePages = true;
  bool isLoading = false;
  List<Venue> paginatedVenues = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> loadData() async {
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

  Future<void> _fetchNextPage() async {
    int ownerId = sharedPreferencesCache.getInt('ownerId')!;
    if (isLoading || !hasMorePages) return;

    isLoading = true;

    PagedResponse<Venue> pagedVenues = await venuesApi.getVenuesByOwner(
      ownerId,
      page: _currentPage,
      size: _pageSize,
    );

    paginatedVenues.addAll(pagedVenues.items);
    hasMorePages = _currentPage < pagedVenues.totalPages - 1;
    _currentPage++;

    isLoading = false;
    notifyListeners();
  }
}
