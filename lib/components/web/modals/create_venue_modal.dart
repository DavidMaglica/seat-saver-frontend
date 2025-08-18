import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/modals/create_venue_model.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class CreateVenueModal extends StatefulWidget {
  final CreateVenueModel model;

  const CreateVenueModal({super.key, required this.model});

  @override
  State<CreateVenueModal> createState() => _CreateVenueModalState();
}

class _CreateVenueModalState extends State<CreateVenueModal>
    with TickerProviderStateMixin {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  void createVenue(BuildContext context) {
    if (widget.model.isFormValid()) {
      widget.model.createVenue(context);
    }
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
            constraints: const BoxConstraints(maxWidth: 1000),
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
                  () => createVenue(context),
                  'Create Venue',
                ),
              ].divide(const SizedBox(height: 16)),
            ),
          ).animateOnPageLoad(
            widget.model.animationsMap['containerOnPageLoadAnimation']!,
          ),
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
              _buildInputField(
                context: context,
                label: 'Venue Name *',
                controller: widget.model.nameTextController,
                focusNode: widget.model.nameFocusNode,
                errorText: widget.model.nameErrorText,
              ),
              _buildInputField(
                context: context,
                label: 'Venue Location (City, Street) *',
                controller: widget.model.locationTextController,
                focusNode: widget.model.locationFocusNode,
                errorText: widget.model.locationErrorText,
              ),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInputField(
                context: context,
                label: 'Maximum Capacity *',
                controller: widget.model.maxCapacityTextController,
                focusNode: widget.model.maxCapacityFocusNode,
                errorText: widget.model.maxCapacityErrorText,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTypeDropdown(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildWorkingHoursPicker(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInputField(
                context: context,
                label: 'Venue Description',
                controller: widget.model.descriptionTextController,
                focusNode: widget.model.descriptionFocusNode,
                keyboardType: TextInputType.text,
                isMultiline: true,
              ),
            ].divide(const SizedBox(width: 16)),
          ),
          _buildImageButtons(context),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '* Required fields',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isExpanded = true,
    bool isMultiline = false,
    double? fixedWidth,
  }) {
    final inputField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: isMultiline ? null : 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        errorText: errorText,
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
    );

    if (fixedWidth != null) {
      return SizedBox(width: fixedWidth, child: inputField);
    }

    return isExpanded ? Expanded(child: inputField) : inputField;
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterFlowDropDown<String>(
          controller: widget.model.dropDownValueController,
          options: widget.model.venueTypes,
          optionLabels: widget.model.venueTypes
              .map((type) => '   $type')
              .toList(),
          onChanged: (val) =>
              safeSetState(() => widget.model.dropDownValue = val),
          width: 470,
          height: 64,
          searchHintTextStyle: Theme.of(context).textTheme.bodyMedium,
          searchTextStyle: Theme.of(context).textTheme.bodyMedium,
          textStyle: Theme.of(context).textTheme.bodyLarge!,
          hintText: 'Type *',
          searchHintText: 'Search...',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          elevation: 3,
          borderColor: widget.model.dropDownErrorText != null
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
        if (widget.model.dropDownErrorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              widget.model.dropDownErrorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWorkingHoursPicker(BuildContext context) {
    return SizedBox(
      width: 470,
      child: TextFormField(
        controller: widget.model.workingHoursTextController,
        focusNode: widget.model.workingHoursFocusNode,
        readOnly: true,
        onTap: () async {
          TimeOfDay? startTime = await _buildTimePicker(context);

          if (startTime == null) return;

          if (!context.mounted) return;
          TimeOfDay? endTime = await _buildTimePicker(
            context,
            initialTime: TimeOfDay(
              hour: startTime.hour + 1,
              minute: startTime.minute,
            ),
          );

          if (endTime == null) return;

          if (!context.mounted) return;
          final String formattedStart = startTime.format(context);
          final String formattedEnd = endTime.format(context);

          widget.model.workingHoursTextController.text =
              '$formattedStart - $formattedEnd';
          widget.model.workingHoursErrorText = null;
        },
        decoration: InputDecoration(
          labelText: 'Working Hours (hh:mm - HH:MM) *',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: widget.model.workingHoursErrorText,
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
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildImageButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImageButton(
          context,
          'Add heading image',
          () => widget.model.addImages(),
        ),
        _buildImageButton(
          context,
          'Add venue images',
          () => widget.model.addImages(),
        ),
        _buildImageButton(
          context,
          'Add menu images',
          () => widget.model.addImages(),
        ),
      ],
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: FFButtonWidget(
        text: label,
        onPressed: onPressed,
        options: FFButtonOptions(
          width: 200,
          height: 40,
          color: Theme.of(context).colorScheme.onPrimary,
          textStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(8),
          splashColor: Theme.of(context).colorScheme.onPrimary,
          hoverColor: Theme.of(context).colorScheme.onPrimary,
        ),
        showLoadingIndicator: false,
      ),
    );
  }

  Future<TimeOfDay?> _buildTimePicker(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onPrimary,
              hourMinuteColor: Theme.of(context).colorScheme.surface,
              dialHandColor: WebTheme.infoColor,
              dialTextColor: Theme.of(context).colorScheme.onPrimary,
              dialBackgroundColor: Theme.of(context).colorScheme.surface,
              entryModeIconColor: Theme.of(context).colorScheme.onPrimary,
              dayPeriodTextColor: Theme.of(context).colorScheme.onPrimary,
              dayPeriodColor: WebTheme.infoColor,
              cancelButtonStyle: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll<Color>(
                  WebTheme.errorColor,
                ),
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  Theme.of(context).textTheme.bodyLarge!,
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.surface,
                ),
                elevation: const WidgetStatePropertyAll<double>(3.0),
              ),
              confirmButtonStyle: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll<Color>(
                  WebTheme.successColor,
                ),
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  Theme.of(context).textTheme.bodyLarge!,
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.surface,
                ),
                elevation: const WidgetStatePropertyAll<double>(3.0),
              ),
            ),
            textTheme: Theme.of(context).textTheme,
          ),
          child: child!,
        );
      },
    );
  }
}
