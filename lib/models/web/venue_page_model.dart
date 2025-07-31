import 'package:TableReserver/api/data/rating.dart';
import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/pages/web/views/venue_page.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:TableReserver/utils/file_picker/file_picker_interface.dart';
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

  Uint8List? headerImage;

  List<String> venueImages = [
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
    'https://images.unsplash.com/photo-1470162656305-6f429ba817bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMnx8dGVhfGVufDB8fHx8MTcwNjU2MTE2OHww&ixlib=rb-4.0.3&q=80&w=400',
  ];

  List<String>? menuImages;

  final List<Rating> reviews = [
    Rating(
      id: 1,
      rating: 4.5,
      username: 'John Doe',
      comment: 'Great place, had a wonderful time!',
    ),
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }

  Future<void> addVenueImages() async {
    await imagePicker(false);
  }

  Future<void> addMenuImages() async {
    await imagePicker(false);
  }
}
