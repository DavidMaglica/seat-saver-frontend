import 'package:TableReserver/components/web/modals/modal_widgets.dart';
import 'package:TableReserver/models/web/add_venue_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

class AddVenueModal extends StatefulWidget {
  const AddVenueModal({super.key});

  @override
  State<AddVenueModal> createState() => _AddVenueModalState();
}

class _AddVenueModalState extends State<AddVenueModal>
    with TickerProviderStateMixin {
  late AddVenueModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddVenueModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddVenueModel()..initState(context),
      child: Consumer(
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
                      buildTitle(context, 'Create a Venue'),
                      _buildBody(context),
                      buildButtons(
                        context,
                        () {
                          if (_model.isFormValid()) {
                            _model.createVenue(context);
                          }
                        },
                        'Create Venue',
                      ),
                    ].divide(const SizedBox(height: 16)),
                  ),
                ).animateOnPageLoad(
                    _model.animationsMap['containerOnPageLoadAnimation']!),
              ],
            ),
          );
        },
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageButton(
                context,
                'Add heading image',
                () => _model.addImages(ImageType.heading),
              ),
              _buildImageButton(
                context,
                'Add venue images',
                () => _model.addImages(ImageType.venue),
              ),
              _buildImageButton(
                context,
                'Add menu images',
                () => _model.addImages(ImageType.menu),
              ),
            ],
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildNameInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.nameTextController,
        focusNode: _model.nameFocusNode,
        errorBuilder: (_, __) {
          return _model.nameErrorText != null
              ? Text(
                  _model.nameErrorText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: WebTheme.errorColor,
                      ),
                )
              : const Text('');
        },
        decoration: InputDecoration(
          labelText: 'Venue Name',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: _model.nameErrorText,
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
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: WebTheme.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
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

  Widget _buildImageButton(
    BuildContext context,
    String label,
    Function() onPressed,
  ) {
    return Container(
      width: 200,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: WebTheme.infoColor,
          width: 1,
        ),
      ),
      child: FFButtonWidget(
        text: label,
        onPressed: onPressed,
        options: FFButtonOptions(
          width: 200,
          height: 40,
          color: Theme.of(context).colorScheme.onSurface,
          textStyle: const TextStyle(
            fontSize: 14,
            color: WebTheme.infoColor,
          ),
          borderRadius: BorderRadius.circular(8),
          splashColor: Theme.of(context).colorScheme.onSurface,
          hoverColor: Theme.of(context).colorScheme.onSurface,
        ),
        showLoadingIndicator: false,
      ),
    );
  }
}
