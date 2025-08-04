import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/components/web/modals/edit_venue_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class EditVenueModel extends FlutterFlowModel<EditVenueModal> {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameTextController = TextEditingController();

  FocusNode locationFocusNode = FocusNode();
  TextEditingController locationTextController = TextEditingController();

  FocusNode maxCapacityFocusNode = FocusNode();
  TextEditingController maxCapacityTextController = TextEditingController();

  String? dropDownValue;
  FormFieldController<String> dropDownValueController = FormFieldController<String>(null);

  FocusNode workingHoursFocusNode = FocusNode();
  TextEditingController workingHoursTextController = TextEditingController();

  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  Venue? loadedVenue;
  List<String> venueTypes = [
    'Restaurant',
    'Cafe',
    'Bar',
    'Club',
    'Event Hall',
  ];

  @override
  void initState(BuildContext context) {
    loadedVenue = Venue(
      id: 1,
      name: 'Lamai',
      location: 'Llota',
      workingHours: '09:00 - 21:00',
      maximumCapacity: 100,
      availableCapacity: 100,
      rating: 4.0,
      typeId: 1,
      description: 'A brief description of the venue.',
    );
    if (loadedVenue != null) {
      nameTextController.text = loadedVenue!.name;
      locationTextController.text = loadedVenue!.location;
      maxCapacityTextController.text = loadedVenue!.maximumCapacity.toString();
      dropDownValue = loadedVenue!.typeId.toString();
      workingHoursTextController.text = loadedVenue!.workingHours;
      descriptionTextController.text = loadedVenue!.description ?? '';
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameTextController.dispose();

    locationFocusNode.dispose();
    locationTextController.dispose();

    maxCapacityFocusNode.dispose();
    maxCapacityTextController.dispose();

    workingHoursFocusNode.dispose();
    workingHoursTextController.dispose();

    descriptionFocusNode.dispose();
    descriptionTextController.dispose();
  }

  Future<void> editVenue() async {
    debugPrint('Editing venue with ID: ${loadedVenue?.id}');
    debugPrint('New Name: ${nameTextController.text}');
    debugPrint('New Location: ${locationTextController.text}');
    debugPrint('New Max Capacity: ${maxCapacityTextController.text}');
    debugPrint('New Type ID: $dropDownValue');
    debugPrint('New Working Hours: ${workingHoursTextController.text}');
    debugPrint('New Description: ${descriptionTextController.text}');
  }
}
