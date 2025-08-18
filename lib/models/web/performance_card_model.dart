import 'package:flutter/widgets.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class PerformanceCardModel extends ChangeNotifier {
  final VenueApi venueApi = VenueApi();

  Venue? loadedVenue;

  Future<void> fetchVenueData(BuildContext context, int venueId) async {
    Venue? venue = await venueApi.getVenue(venueId);

    if (venue != null) {
      loadedVenue = venue;
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(
        context,
        'Error while fetching venue. Try again later.',
      );
    }
    notifyListeners();
  }
}
