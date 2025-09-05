import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_reserver/api/data/paged_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/pages/mobile/views/homepage.dart';
import 'package:table_reserver/pages/mobile/views/venue_page.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';

class VenuesByTypeModel extends ChangeNotifier {
  final String type;
  final Position? userLocation;

  VenuesApi venuesApi;

  VenuesByTypeModel({
    required this.type,
    this.userLocation,
    VenuesApi? venuesApi,
  }) : venuesApi = venuesApi ?? VenuesApi();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController scrollController = ScrollController();

  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMorePages = true;
  bool isLoading = false;
  List<Venue> venues = [];

  Map<int, String> venueTypeMap = {};

  Future<void> init() async {
    await _fetchNextPage(type);
    await _loadVenueTypes();

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

  Future<void> _loadVenueTypes() async {
    final venueTypes = await venuesApi.getAllVenueTypes();
    venueTypeMap = {
      for (var type in venueTypes) type.id: type.type.toTitleCase(),
    };
  }

  Future<void> _fetchNextPage(String type) async {
    isLoading = true;

    PagedResponse<Venue> pagedVenues;
    switch (type) {
      case 'nearby':
        pagedVenues = await venuesApi.getNearbyVenues(
          userLocation?.latitude,
          userLocation?.longitude,
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < pagedVenues.totalPages - 1;
        _currentPage++;
        break;
      case 'new':
        pagedVenues = await venuesApi.getNewVenues(
          page: _currentPage,
          size: _pageSize,
        );
        _currentPage++;
        hasMorePages = _currentPage < pagedVenues.totalPages;
        break;
      case 'trending':
        pagedVenues = await venuesApi.getTrendingVenues(
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < pagedVenues.totalPages - 1;
        _currentPage++;
        break;
      case 'suggested':
        pagedVenues = await venuesApi.getSuggestedVenues(
          page: _currentPage,
          size: _pageSize,
        );
        hasMorePages = _currentPage < pagedVenues.totalPages - 1;
        _currentPage++;
        break;
      default:
        isLoading = false;
        notifyListeners();
        return;
    }
    venues = List.from(venues)..addAll(pagedVenues.items);
    isLoading = false;
    notifyListeners();
  }

  void goToVenuePage(BuildContext context, int venueId) {
    Navigator.of(context).push(
      MobileFadeInRoute(
        page: VenuePage(venueId: venueId),
        routeName: Routes.venue,
        arguments: {'venueId': venueId},
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.of(context).push(
      MobileFadeInRoute(page: const Homepage(), routeName: Routes.homepage),
    );
  }
}
