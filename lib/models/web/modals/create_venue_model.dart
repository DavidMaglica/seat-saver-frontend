import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/venue_type.dart';
import 'package:table_reserver/api/venue_api.dart';
import 'package:table_reserver/components/web/modals/create_venue_modal.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/pages/web/views/venue_page.dart';
import 'package:table_reserver/utils/animations.dart';
import 'package:table_reserver/utils/extensions.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/web_toaster.dart';

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

  final VenuesApi venuesApi = VenuesApi();

  final Map<String, AnimationInfo> animationsMap = Animations.modalAnimations;

  Map<int, String> venueTypeMap = {};

  @override
  void initState(BuildContext context) {}

  void init() async {
    List<VenueType> types = await venuesApi.getAllVenueTypes();
    venueTypeMap = {for (var type in types) type.id: type.type.toTitleCase()};
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

    dropDownValueController.dispose();
  }

  Future<void> createVenue(BuildContext context) async {
    final int ownerId = prefsWithCache.getInt('ownerId')!;
    if (!isFormValid()) {
      notifyListeners();
      return;
    }
    final String name = nameTextController.text.trim();
    final String location = locationTextController.text.trim();
    final int maxCapacity = int.tryParse(
      maxCapacityTextController.text.trim(),
    )!;
    final int typeId = int.parse(dropDownValueController.value!);
    final String workingHours = workingHoursTextController.text.trim();
    final List<int> workingDays = selectedWorkingDays;
    final String description = descriptionTextController.text.trim();

    final BasicResponse<int> response = await venuesApi.createVenue(
      ownerId: ownerId,
      name: name,
      location: location,
      maximumCapacity: maxCapacity,
      typeId: typeId,
      workingDays: workingDays,
      workingHours: workingHours,
      description: description,
    );

    final venueId = response.data;

    if (response.success) {
      if (!context.mounted) return;

      nameTextController.clear();
      locationTextController.clear();
      maxCapacityTextController.clear();
      dropDownValueController.value = null;
      workingHoursTextController.clear();
      descriptionTextController.clear();

      Navigator.of(context).push(
        FadeInRoute(
          page: WebVenuePage(
            venueId: venueId!,
            shouldReturnToHomepage: true,
            shouldOpenImagesTab: true,
          ),
          routeName: '${Routes.webVenue}?venueId=$venueId',
        ),
      );
    } else {
      if (!context.mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  bool isFormValid() {
    bool isValid = true;

    final String nameValue = nameTextController.text.trim();
    if (nameValue.isEmpty) {
      nameErrorText = 'Please enter the name of your venue.';
      isValid = false;
    } else {
      nameErrorText = null;
    }

    final String locationValue = locationTextController.text.trim();
    if (locationValue.isEmpty) {
      locationErrorText = 'Please enter the location of your venue.';
      isValid = false;
    } else {
      locationErrorText = null;
    }

    final String maxCapacityValue = maxCapacityTextController.text.trim();
    if (maxCapacityValue.isEmpty) {
      maxCapacityErrorText = 'Please enter the maximum capacity of your venue.';
      isValid = false;
    } else {
      final int? maxCapacity = int.tryParse(maxCapacityValue);
      if (maxCapacity == null || maxCapacity <= 0) {
        maxCapacityErrorText = 'Please enter a valid maximum capacity.';
        isValid = false;
      } else {
        maxCapacityErrorText = null;
      }

      final String? selectedTypeId = dropDownValueController.value;
      if (selectedTypeId == null || selectedTypeId.isEmpty) {
        dropDownErrorText = 'Please select the type of your venue.';
        isValid = false;
      } else {
        dropDownErrorText = null;
      }
    }

    final String workingHoursValue = workingHoursTextController.text.trim();
    final RegExp workingHoursRegex = RegExp(
      r'^(?:[01]\d|2[0-3]):[0-5]\d\s*-\s*(?:[01]\d|2[0-3]):[0-5]\d$',
    );
    if (workingHoursTextController.text.isEmpty) {
      workingHoursErrorText = 'Please enter the working hours of your venue.';
      isValid = false;
    } else if (!workingHoursRegex.hasMatch(workingHoursValue)) {
      workingHoursErrorText =
          'Please use the format: HH:MM - HH:MM (e.g., 09:00 - 17:00)';
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

    notifyListeners();
    return isValid;
  }
}
