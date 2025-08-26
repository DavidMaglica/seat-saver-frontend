import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/venue.dart';
import 'package:table_reserver/api/data/venue_type.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/web/modals/edit_venue_modal.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class EditVenueModel extends FlutterFlowModel<EditVenueModal>
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

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  List<int> selectedWorkingDays = [];
  String? workingDaysErrorText;

  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();
  String? descriptionErrorText;

  String? updateErrorText;

  VenuesApi venuesApi = VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  Venue? loadedVenue;
  Map<int, String> venueTypeMap = {};

  @override
  void initState(BuildContext context) {}

  void fetchData(BuildContext context, int venueId) async {
    _fetchVenue(context, venueId);
  }

  void _fetchVenue(BuildContext context, int venueId) async {
    List<VenueType> types = await venuesApi.getAllVenueTypes();
    venueTypeMap = {for (var type in types) type.id: type.type.toTitleCase()};

    Venue? venue = await venuesApi.getVenue(venueId);
    if (venue != null) {
      loadedVenue = venue;
      nameTextController.text = venue.name;
      locationTextController.text = venue.location;
      maxCapacityTextController.text = venue.maximumCapacity.toString();
      dropDownValueController.value = venue.typeId.toString();
      workingHoursTextController.text = venue.workingHours;
      selectedWorkingDays = venue.workingDays;
      descriptionTextController.text = venue.description ?? '';
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, 'Could not load venue data.');
      Navigator.of(context).pop();
    }

    notifyListeners();
  }

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
  }

  Future<void> editVenue(BuildContext context) async {
    if (!_validateFields()) {
      notifyListeners();
      return;
    }

    BasicResponse response = await venuesApi.editVenue(
      venueId: loadedVenue!.id,
      name: nameTextController.text.trim(),
      location: locationTextController.text.trim(),
      maximumCapacity: int.parse(maxCapacityTextController.text.trim()),
      typeId: int.parse(dropDownValueController.value!),
      workingDays: selectedWorkingDays,
      workingHours: workingHoursTextController.text.trim(),
      description: descriptionTextController.text.trim().isEmpty
          ? null
          : descriptionTextController.text.trim(),
    );

    if (response.success) {
      if (!context.mounted) return;
      WebToaster.displaySuccess(context, 'Venue updated successfully.');
      Navigator.of(context).pop(true);
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  bool _validateFields() {
    bool isValid = true;

    final String nameValue = nameTextController.text.trim();
    if (nameValue.isEmpty) {
      nameErrorText = 'Please enter the venue name.';
      isValid = false;
    } else {
      nameErrorText = null;
    }

    final String locationValue = locationTextController.text.trim();
    if (locationValue.isEmpty) {
      locationErrorText = 'Please enter the venue location.';
      isValid = false;
    } else {
      locationErrorText = null;
    }

    final String maxCapacityValue = maxCapacityTextController.text.trim();
    if (maxCapacityValue.isEmpty) {
      maxCapacityErrorText = 'Please enter the maximum capacity.';
      isValid = false;
    } else {
      final int? maxCapacity = int.tryParse(maxCapacityValue);
      if (maxCapacity == null || maxCapacity <= 0) {
        maxCapacityErrorText = 'Please enter a valid maximum capacity.';
        isValid = false;
      } else {
        maxCapacityErrorText = null;
      }
    }

    final String? selectedTypeId = dropDownValueController.value;
    if (selectedTypeId == null) {
      dropDownErrorText = 'Please select a venue type.';
      isValid = false;
    } else {
      dropDownErrorText = null;
    }

    final String workingHoursValue = workingHoursTextController.text.trim();
    final RegExp workingHoursRegex = RegExp(
      r'^(?:[01]\d|2[0-3]):[0-5]\d\s*-\s*(?:[01]\d|2[0-3]):[0-5]\d$',
    );
    if (workingHoursValue.isEmpty) {
      workingHoursErrorText = 'Please enter the working hours.';
      isValid = false;
    } else if (!workingHoursRegex.hasMatch(workingHoursValue)) {
      workingHoursErrorText =
          'Please use the format: HH:MM - HH:MM';
      isValid = false;
    } else {
      workingHoursErrorText = null;
    }

    if (selectedWorkingDays.isEmpty) {
      workingDaysErrorText = 'Please select at least one working day.';
      isValid = false;
    } else {
      workingDaysErrorText = null;
    }

    return isValid;
  }
}
