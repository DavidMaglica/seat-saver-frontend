import 'package:TableReserver/api/data/paged_response.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/api/venue_api.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class VenuesByTypeModel extends ChangeNotifier {
  final BuildContext context;
  final String type;
  final int? userId;
  final Position? position;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  VenueApi venueApi = VenueApi();

  final ScrollController scrollController = ScrollController();

  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMorePages = true;
  bool isLoading = false;
  List<Venue> venues = [];

  VenuesByTypeModel({
    required this.context,
    required this.type,
    this.userId,
    this.position,
  });

  // TODO: IMPLEMENT VENUE TYPES AND HEADING IMAGES

  Future<void> init() async {
    await _fetchNextPage(type);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 50) {
          if (!isLoading && hasMorePages) {
            _fetchNextPage(type);
          }
        }
      });
    });

    notifyListeners();
  }

  Future<void> _fetchNextPage(String type) async {
    isLoading = true;

    PagedResponse<Venue> paged;
    switch (type) {
      case 'nearby':
        paged = await venueApi.getNearbyVenuesNew(
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < paged.totalPages - 1;
        _currentPage++;
        break;
      case 'new':
        paged = await venueApi.getNewVenuesNew(
          page: _currentPage,
          size: _pageSize,
        );
        _currentPage++;
        hasMorePages = _currentPage < paged.totalPages;
        debugPrint('Current Page: $_currentPage, Total Pages: ${paged.totalPages}');
        break;
      case 'trending':
        paged = await venueApi.getTrendingVenuesNew(
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < paged.totalPages - 1;
        _currentPage++;
        paged.content.removeWhere((venue) => venue.rating < 4.0);
        break;
      case 'suggested':
        paged = await venueApi.getSuggestedVenuesNew(
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < paged.totalPages - 1;
        _currentPage++;
        break;
      default:
        isLoading = false;
        notifyListeners();
        return;
    }
    venues = List.from(venues)..addAll(paged.content);
    isLoading = false;
    notifyListeners();
  }

  void goBack() {
    Navigator.of(context).pushNamed(
      Routes.homepage,
      arguments: {
        'userId': userId,
        'position': position,
      },
    );
  }
}
