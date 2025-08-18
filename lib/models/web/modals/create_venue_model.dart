import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/components/web/modals/create_venue_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/file_picker/file_picker_interface.dart';

class CreateVenueModel extends FlutterFlowModel<CreateVenueModal>
    with ChangeNotifier {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameTextController = TextEditingController();
  String? nameErrorText;

  FocusNode locationFocusNode = FocusNode();
  TextEditingController locationTextController = TextEditingController();
  String? locationErrorText;

  FocusNode maxCapacityFocusNode = FocusNode();
  TextEditingController maxCapacityTextController = TextEditingController();
  String? maxCapacityErrorText;

  String? dropDownValue;
  FormFieldController<String> dropDownValueController =
      FormFieldController<String>(null);
  String? dropDownErrorText;

  FocusNode workingHoursFocusNode = FocusNode();
  TextEditingController workingHoursTextController = TextEditingController();
  String? workingHoursErrorText;

  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  List<String> venueTypes = [
    'Restaurant',
    'Cafe',
    'Bar',
    'Club',
    'Event Hall',
    'Other',
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
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

    dropDownValueController.dispose();
  }

  Future<void> createVenue(BuildContext context) async {
    debugPrint('Adding new venue');
    debugPrint('New Name: ${nameTextController.text}');
    debugPrint('New Location: ${locationTextController.text}');
    debugPrint('New Max Capacity: ${maxCapacityTextController.text}');
    debugPrint('New Type ID: $dropDownValue');
    debugPrint('New Working Hours: ${workingHoursTextController.text}');
    debugPrint('New Description: ${descriptionTextController.text}');
  }

  bool isFormValid() {
    bool isValid = true;

    if (nameTextController.text.isEmpty) {
      nameErrorText = 'Please enter the name of your venue.';
      isValid = false;
    } else {
      nameErrorText = null;
    }

    if (locationTextController.text.isEmpty) {
      locationErrorText = 'Please enter the location of your venue.';
      isValid = false;
    } else {
      locationErrorText = null;
    }

    if (maxCapacityTextController.text.isEmpty) {
      maxCapacityErrorText = 'Please enter the maximum capacity of your venue.';
      isValid = false;
    } else {
      maxCapacityErrorText = null;
    }

    if (dropDownValue == null || dropDownValue!.isEmpty) {
      dropDownErrorText = 'Please select the type of your venue.';
      isValid = false;
    } else {
      dropDownErrorText = null;
    }

    if (workingHoursTextController.text.isEmpty) {
      workingHoursErrorText = 'Please enter the working hours of your venue.';
      isValid = false;
    } else {
      workingHoursErrorText = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> addImages() async {
    await imagePicker();
  }
}
