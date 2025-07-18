import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/models/web/side_nav_model.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:TableReserver/pages/web/views/homepage.dart';

class HomepageModel extends FlutterFlowModel<WebHomepage> {
  late SideNavModel sideNavModel;

  final Map<String, AnimationInfo> animationsMap =
      Animations.homepageAnimations;

  final List<String> headers = [
    'Name',
    'Location',
    'Working Hours',
    'Max. capacity',
    'Avail. capacity',
    'Rating',
  ];
  final List<Venue> venues = [
    Venue(
      id: 1,
      name: 'Venue 1',
      location: 'Location 1',
      workingHours: '9 AM - 9 PM',
      maximumCapacity: 100,
      availableCapacity: 50,
      rating: 4.5,
      typeId: 1,
    ),
    Venue(
      id: 2,
      name: 'Venue 2',
      location: 'Location 2',
      workingHours: '10 AM - 10 PM',
      maximumCapacity: 200,
      availableCapacity: 150,
      rating: 4.0,
      typeId: 2,
    ),
    Venue(
      id: 3,
      name: 'Venue 3',
      location: 'Location 3',
      workingHours: '8 AM - 8 PM',
      maximumCapacity: 150,
      availableCapacity: 100,
      rating: 3.5,
      typeId: 1,
    ),
    Venue(
      id: 4,
      name: 'Venue 4',
      location: 'Location 4',
      workingHours: '11 AM - 11 PM',
      maximumCapacity: 300,
      availableCapacity: 200,
      rating: 2.5,
      typeId: 3,
    ),
    Venue(
      id: 5,
      name: 'Venue 5',
      location: 'Location 5',
      workingHours: '7 AM - 7 PM',
      maximumCapacity: 80,
      availableCapacity: 30,
      rating: 1.5,
      typeId: 2,
    ),
    Venue(
      id: 6,
      name: 'Venue 6',
      location: 'Location 6',
      workingHours: '9 AM - 5 PM',
      maximumCapacity: 120,
      availableCapacity: 60,
      rating: 3.0,
      typeId: 1,
    ),
    Venue(
      id: 7,
      name: 'Venue 7',
      location: 'Location 7',
      workingHours: '10 AM - 6 PM',
      maximumCapacity: 90,
      availableCapacity: 40,
      rating: 4.2,
      typeId: 3,
    ),
    Venue(
      id: 8,
      name: 'Venue 8',
      location: 'Location 8',
      workingHours: '12 PM - 12 AM',
      maximumCapacity: 250,
      availableCapacity: 180,
      rating: 4.8,
      typeId: 2,
    ),
    Venue(
      id: 9,
      name: 'Venue 9',
      location: 'Location 9',
      workingHours: '6 AM - 6 PM',
      maximumCapacity: 110,
      availableCapacity: 70,
      rating: 3.8,
      typeId: 1,
    ),
    Venue(
      id: 10,
      name: 'Venue 10',
      location: 'Location 10',
      workingHours: '8 AM - 8 PM',
      maximumCapacity: 130,
      availableCapacity: 90,
      rating: 4.1,
      typeId: 3,
    ),
  ];

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }
}
