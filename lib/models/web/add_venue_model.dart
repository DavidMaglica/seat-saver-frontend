import 'dart:html';

import 'package:TableReserver/components/web/modals/add_venue_modal.dart';
import 'package:TableReserver/utils/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

enum ImageType { heading, venue, menu }

class AddVenueModel extends FlutterFlowModel<AddVenueModal>
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
  String? descriptionErrorText;

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
      nameErrorText = 'Please enter a name for the venue.';
      isValid = false;
    }
    if (locationTextController.text.isEmpty) {
      locationErrorText = 'Please enter a location for the venue.';
      isValid = false;
    }
    if (maxCapacityTextController.text.isEmpty) {
      maxCapacityErrorText = 'Please enter the maximum capacity for the venue.';
      isValid = false;
    }
    if (dropDownValue == null || dropDownValue!.isEmpty) {
      dropDownErrorText = 'Please select a type for the venue.';
      isValid = false;
    }
    if (workingHoursTextController.text.isEmpty) {
      workingHoursErrorText = 'Please enter the working hours for the venue.';
      isValid = false;
    }
    if (descriptionTextController.text.isEmpty) {
      descriptionErrorText = 'Please enter a description for the venue.';
      isValid = false;
    }

    debugPrint('Form Valid: $isValid');

    notifyListeners();
    return isValid;
  }

  Future<void> addImages(ImageType imageType) async {
    bool isHeaderImage = imageType == ImageType.heading;
    final images = await _setImage(isHeaderImage);
    debugPrint('Images selected: ${images.length}');
    if (images.isNotEmpty) {
      debugPrint('Added Venue Images: ${images.first.length}');
    } else {
      debugPrint('No images selected');
    }
  }

  Future<List<String>> _setImage(bool isHeaderImage) async {
    final completer = Completer<List<String>>();
    FileUploadInputElement uploadInput = FileUploadInputElement()
      ..multiple = !isHeaderImage
      ..accept = 'image/*';
    uploadInput.click();
    uploadInput.addEventListener('change', (e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        completer.completeError('No files selected');
        return;
      }
      Iterable<Future<String>> resultsFutures = files.map((file) {
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen((error) => completer.completeError(error));
        return reader.onLoad.first.then((_) => reader.result as String);
      });

      final results = await Future.wait(resultsFutures);
      if (!completer.isCompleted) {
        completer.complete(results);
      }
    });

    document.body?.append(uploadInput);
    final List<String> images = await completer.future;
    uploadInput.remove();
    return images;
  }
}
