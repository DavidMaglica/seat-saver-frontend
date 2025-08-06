import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/edit_venue_model.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class EditVenueModal extends StatefulWidget {
  final int venueId;

  const EditVenueModal({
    super.key,
    required this.venueId,
  });

  @override
  State<EditVenueModal> createState() => _EditVenueModalState();
}

class _EditVenueModalState extends State<EditVenueModal>
    with TickerProviderStateMixin {
  late EditVenueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditVenueModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle(context, 'Edit Venue'),
                _buildBody(context),
                buildButtons(context, () => _model.editVenue(), 'Save Changes'),
              ].divide(const SizedBox(height: 16)),
            ),
          ).animateOnPageLoad(
              _model.animationsMap['containerOnPageLoadAnimation']!),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildNameInputField(context),
              _buildLocationInputField(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildMaxCapacityInputField(context),
              _buildTypeDropdown(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildWorkingHoursInputField(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildDescriptionInputField(context),
            ].divide(
              const SizedBox(width: 16),
            ),
          ),
        ].divide(
          const SizedBox(height: 24),
        ),
      ),
    );
  }

  Widget _buildNameInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.nameTextController,
        focusNode: _model.nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Name',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildLocationInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.locationTextController,
        focusNode: _model.locationFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Location (City, Street)',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildMaxCapacityInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.maxCapacityTextController,
        focusNode: _model.maxCapacityFocusNode,
        decoration: InputDecoration(
          labelText: 'Maximum Capacity',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildTypeDropdown(BuildContext context) {
    return FlutterFlowDropDown<String>(
      controller: _model.dropDownValueController,
      options: _model.venueTypes,
      optionLabels: _model.venueTypes.map((type) => '   $type').toList(),
      onChanged: (val) => safeSetState(() => _model.dropDownValue = val),
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
      borderColor: Theme.of(context).colorScheme.onPrimary,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      hidesUnderline: true,
      isOverButton: false,
      isSearchable: true,
      isMultiSelect: false,
    );
  }

  Widget _buildWorkingHoursInputField(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 470,
          child: TextFormField(
            controller: _model.workingHoursTextController,
            focusNode: _model.workingHoursFocusNode,
            decoration: InputDecoration(
              labelText: 'Working Hours (hh:mm - hh:mm)',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: WebTheme.infoColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.descriptionTextController,
        focusNode: _model.descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Venue Description',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
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
