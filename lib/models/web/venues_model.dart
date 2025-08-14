import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/venues.dart';
import 'package:table_reserver/utils/animations.dart';

class VenuesModel extends FlutterFlowModel<WebVenuesPage> with ChangeNotifier {
  final Map<String, AnimationInfo> animationsMap = Animations.venuesAnimations;

  final ScrollController scrollController = ScrollController();

  final VenueApi venueApi = VenueApi();

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

  Future<void> init() async {
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
    int ownerId = prefsWithCache.getInt('userId')!;
    if (isLoading || !hasMorePages) return;

    isLoading = true;

    PagedResponse<Venue> paged = await venueApi.getVenuesByOwner(
      ownerId,
      page: _currentPage,
      size: _pageSize,
    );

    paginatedVenues.addAll(paged.content);
    hasMorePages = _currentPage < paged.totalPages - 1;
    _currentPage++;

    isLoading = false;
    notifyListeners();
  }
}
