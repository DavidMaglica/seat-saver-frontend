import 'package:flutter/widgets.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';

class PerformanceCardModel extends ChangeNotifier {
  final VenuesApi venuesApi = VenuesApi();

  Venue? loadedVenue;

  Future<void> fetchVenueData(BuildContext context, int? venueId) async {
    if (venueId == null) {
      return;
    }
    Venue? venue = await venuesApi.getVenue(venueId);

    if (venue != null) {
      loadedVenue = venue;
    }
    notifyListeners();
  }
}
