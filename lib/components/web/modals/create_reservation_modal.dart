import 'package:TableReserver/components/web/modals/modal_widgets.dart';
import 'package:TableReserver/models/web/create_reservation_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class CreateReservationModal extends StatefulWidget {
  final CreateReservationModel model;

  const CreateReservationModal({super.key, required this.model});

  @override
  State<CreateReservationModal> createState() => _CreateReservationModalState();
}

class _CreateReservationModalState extends State<CreateReservationModal>
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
  void dispose() {
    super.dispose();
  }

  void createReservation(BuildContext context) {
    if (widget.model.isFormValid()) {
      widget.model.createReservation(context);
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
                buildTitle(context, 'Create a Reservation'),
                _buildBody(context),
                buildButtons(
                  context,
                  () => createReservation(context),
                  'Create Reservation',
                ),
              ].divide(const SizedBox(height: 16)),
            ),
          ).animateOnPageLoad(
              widget.model.animationsMap['containerOnPageLoadAnimation']!),
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
                label: 'User Email *',
                controller: widget.model.emailTextController,
                focusNode: widget.model.emailFocusNode,
                errorText: widget.model.emailErrorText,
              )
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInputField(
                context: context,
                label: 'Number of Guests *',
                controller: widget.model.guestsTextController,
                focusNode: widget.model.guestsFocusNode,
                errorText: widget.model.guestsErrorText,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              _buildReservationDateInputField(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '* Required fields',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
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
          borderSide: BorderSide(
            color: WebTheme.infoColor,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: WebTheme.errorColor,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: WebTheme.infoColor,
            width: 1,
          ),
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

  Widget _buildReservationDateInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: widget.model.reservationDateTextController,
        focusNode: widget.model.reservationDateFocusNode,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await _buildDatePicker(context);

          if (pickedDate != null) {
            if (!context.mounted) return;
            TimeOfDay? pickedTime = await _buildTimePicker(context);

            if (pickedTime != null) {
              final combinedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');

              final formattedDateTime = dateFormat.format(combinedDateTime);

              widget.model.reservationDateTextController.text = formattedDateTime;
            }
          }
        },
        decoration: InputDecoration(
          labelText: 'Reservation Date *',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: widget.model.reservationDateErrorText,
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
            borderSide: const BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: WebTheme.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: WebTheme.infoColor,
              width: 1,
            ),
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

  Future<DateTime?> _buildDatePicker(BuildContext context) {
    return showDatePickerDialog(
      context: context,
      height: 420,
      width: 400,
      maxDate: DateTime.now().add(const Duration(days: 365)),
      minDate: DateTime.now(),
      selectedDate: DateTime.now(),
      centerLeadingDate: true,
      slidersColor: Theme.of(context).colorScheme.onPrimary,
      currentDateTextStyle: Theme.of(context).textTheme.bodyLarge,
      currentDateDecoration: BoxDecoration(
        color: WebTheme.transparentColour,
        shape: BoxShape.circle,
        border: Border.all(
          color: WebTheme.infoColor,
          width: 1,
        ),
      ),
      selectedCellTextStyle:
      Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
      selectedCellDecoration: const BoxDecoration(
        color: WebTheme.infoColor,
        shape: BoxShape.circle,
      ),
      enabledCellsTextStyle: Theme.of(context).textTheme.bodyLarge,
      disabledCellsTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color:
        Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.4),
      ),
      leadingDateTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold),
      daysOfTheWeekTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Future<TimeOfDay?> _buildTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
