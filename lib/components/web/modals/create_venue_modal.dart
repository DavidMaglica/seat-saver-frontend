import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/modals/create_venue_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

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
                  () => widget.model.createVenue(context),
                  'Create Venue',
                ),
              ].divide(const SizedBox(height: 16)),
            ),
          ).animateOnPageLoad(widget.model.animationsMap['modalOnLoad']!),
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
                key: const Key('venueNameField'),
                context: context,
                label: 'Venue Name *',
                controller: widget.model.nameTextController,
                focusNode: widget.model.nameFocusNode,
                errorText: widget.model.nameErrorText,
              ),
              _buildInputField(
                key: const Key('venueLocationField'),
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
                key: const Key('maxCapacityField'),
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
              _buildWorkingHoursInputField(context, widget.model),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Working Days:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 16),
              _buildWorkingDaysChips(context),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInputField(
                key: const Key('venueDescriptionField'),
                context: context,
                label: 'Venue Description',
                controller: widget.model.descriptionTextController,
                focusNode: widget.model.descriptionFocusNode,
                keyboardType: TextInputType.text,
                isMultiline: true,
              ),
            ].divide(const SizedBox(width: 16)),
          ),
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
    required Key key,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isExpanded = true,
    bool isMultiline = false,
    double? fixedWidth,
  }) {
    final inputField = TextFormField(
      key: key,
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
          key: const Key('venueTypeDropdown'),
          controller: widget.model.dropDownValueController,
          options: widget.model.venueTypeMap.keys
              .map((id) => id.toString())
              .toList(),
          optionLabels: widget.model.venueTypeMap.values
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
          isSearchable: false,
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

  Widget _buildWorkingHoursInputField(
    BuildContext context,
    CreateVenueModel model,
  ) {
    return SizedBox(
      width: 470,
      child: TextFormField(
        key: const Key('workingHoursField'),
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

  Widget _buildWorkingDaysChips(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: List.generate(widget.model.days.length, (index) {
            final day = widget.model.days[index];
            final isSelected = widget.model.selectedWorkingDays.contains(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                key: Key('dayChip_$day'),
                selectedColor: WebTheme.successColor,
                backgroundColor: Theme.of(context).colorScheme.outline,
                labelStyle: isSelected
                    ? Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: WebTheme.offWhite)
                    : Theme.of(context).textTheme.bodyLarge,
                showCheckmark: false,
                elevation: 3,
                label: Text(day),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      widget.model.selectedWorkingDays.add(index);
                    } else {
                      widget.model.selectedWorkingDays.remove(index);
                    }
                  });
                },
              ),
            );
          }),
        ),
        widget.model.workingDaysErrorText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(
                  widget.model.workingDaysErrorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
