import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/modals/edit_venue_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class EditVenueModal extends StatefulWidget {
  final int venueId;

  const EditVenueModal({super.key, required this.venueId});

  @override
  State<EditVenueModal> createState() => _EditVenueModalState();
}

class _EditVenueModalState extends State<EditVenueModal>
    with TickerProviderStateMixin {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditVenueModel()..fetchData(context, widget.venueId),
      child: Consumer<EditVenueModel>(
        builder: (context, model, _) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 1000),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(context, 'Edit Venue'),
                      _buildBody(context, model),
                      buildButtons(
                        context,
                        () => model.editVenue(context),
                        'Save Changes',
                      ),
                    ].divide(const SizedBox(height: 16)),
                  ),
                ).animateOnPageLoad(model.animationsMap['modalOnLoad']!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditVenueModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildNameInputField(context, model),
              _buildLocationInputField(context, model),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildMaxCapacityInputField(context, model),
              _buildTypeDropdown(context, model),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildWorkingHoursInputField(context, model),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildDescriptionInputField(context, model),
            ].divide(const SizedBox(width: 16)),
          ),
        ].divide(const SizedBox(height: 24)),
      ),
    );
  }

  Widget _buildNameInputField(BuildContext context, EditVenueModel model) {
    return Expanded(
      child: TextFormField(
        controller: model.nameTextController,
        focusNode: model.nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Name',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.nameErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildLocationInputField(BuildContext context, EditVenueModel model) {
    return Expanded(
      child: TextFormField(
        controller: model.locationTextController,
        focusNode: model.locationFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Location (City, Street)',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.locationErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildMaxCapacityInputField(
    BuildContext context,
    EditVenueModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.maxCapacityTextController,
        focusNode: model.maxCapacityFocusNode,
        decoration: InputDecoration(
          labelText: 'Maximum Capacity',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.maxCapacityErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.number,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context, EditVenueModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterFlowDropDown<String>(
          controller: model.dropDownValueController,
          options: model.venueTypeMap.keys.map((id) => id.toString()).toList(),
          optionLabels: model.venueTypeMap.values
              .map((type) => '   $type')
              .toList(),
          onChanged: (val) => safeSetState(() => model.dropDownValue = val),
          width: 470,
          height: 64,
          searchHintTextStyle: Theme.of(context).textTheme.bodyMedium,
          searchTextStyle: Theme.of(context).textTheme.bodyMedium,
          textStyle: Theme.of(context).textTheme.bodyLarge!,
          hintText: 'Type',
          searchHintText: 'Search...',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          elevation: 3,
          borderColor: model.dropDownErrorText != null
              ? WebTheme.errorColor
              : Theme.of(context).colorScheme.onPrimary,
          borderWidth: 1,
          borderRadius: 8,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          hidesUnderline: true,
          isOverButton: false,
          isSearchable: true,
          isMultiSelect: false,
        ),
        if (model.dropDownErrorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 4),
            child: Text(
              model.dropDownErrorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWorkingHoursInputField(
    BuildContext context,
    EditVenueModel model,
  ) {
    return SizedBox(
      width: 470,
      child: TextFormField(
        controller: model.workingHoursTextController,
        focusNode: model.workingHoursFocusNode,
        decoration: InputDecoration(
          labelText: 'Working Hours (hh:mm - hh:mm)',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.workingHoursErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildDescriptionInputField(
    BuildContext context,
    EditVenueModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.descriptionTextController,
        focusNode: model.descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Description',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.descriptionErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.errorColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: null,
        minLines: 1,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
