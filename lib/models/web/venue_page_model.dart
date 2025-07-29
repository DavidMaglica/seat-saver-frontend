import 'package:TableReserver/api/data/rating.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/pages/web/views/venue_page.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class VenuePageModel extends FlutterFlowModel<WebVenuePage> {
  TabController? tabBarController;

  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  PageController pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 1.0,
  );

  int get pageViewCurrentIndex =>
      pageViewController.hasClients && pageViewController.page != null
          ? pageViewController.page!.round()
          : 0;

  final Map<String, AnimationInfo> animationsMap =
      Animations.venuePageAnimations;

  final Venue loadedVenue = Venue(
    id: 1,
    name: "La Mai",
    location: "Poreč, Croatia",
    workingHours: "09:00 AM - 11:00 PM",
    maximumCapacity: 100,
    availableCapacity: 100,
    rating: 4.5,
    typeId: 1,
    description:
        "A beach is a narrow, gently sloping strip of land that lies along the edge of an ocean, lake, or river. Materials such as sand, pebbles, rocks, and seashell fragments cover beaches.",
  );

  final Uint8List headerImage = Uint8List.fromList(
    List.generate(100, (index) => index % 256),
  );

  final List<String> venueImages = [
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
  ];

  final List<String> menuImages = [
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
  ];

  final List<Rating> reviews = [
    Rating(
      id: 1,
      rating: 4.5,
      username: 'John Doe',
      comment: 'Great place, had a wonderful time!',
    ),
    Rating(
      id: 2,
      rating: 3.0,
      username: 'Jane Smith',
      comment: 'Average experience, could be better.',
    ),
    Rating(
      id: 3,
      rating: 5.0,
      username: 'Alice Johnson',
      comment: 'Absolutely loved it! Will come back again.',
    ),
    Rating(
      id: 4,
      rating: 2.5,
      username: 'Bob Brown',
      comment: 'Not what I expected, service was slow.',
    ),
    Rating(
      id: 5,
      rating: 4.0,
      username: 'Charlie White',
      comment: 'Good food, nice ambiance, will recommend to friends.',
    ),
    Rating(
      id: 6,
      rating: 3.5,
      username: 'Diana Green',
      comment: 'Decent place, but a bit crowded.',
    ),
    Rating(
      id: 7,
      rating: 4.8,
      username: 'Ethan Blue',
      comment: 'Fantastic experience, loved the live music!',
    ),
    Rating(
      id: 8,
      rating: 2.0,
      username: 'Fiona Yellow',
      comment: 'Disappointing, food was cold and service was poor.',
    ),
    Rating(
      id: 9,
      rating: 4.2,
      username: 'George Purple',
      comment: 'Great atmosphere, friendly staff.',
    ),
    Rating(
      id: 10,
      rating: 3.8,
      username: 'Hannah Orange',
      comment: 'Nice place, but a bit overpriced.',
    ),
    Rating(
      id: 11,
      rating: 4.6,
      username: 'Ian Pink',
      comment: 'Loved the cocktails, will definitely return!',
    ),
    Rating(
      id: 12,
      rating: 3.2,
      username: 'Julia Gray',
      comment: 'Okay experience, nothing special.',
    ),
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }

  Future<void> addVenueImages() async {}

  Future<void> addMenuImages() async {}
}
