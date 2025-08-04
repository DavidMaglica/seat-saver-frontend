import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/models/web/edit_reservation_model.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class EditReservationModal extends StatefulWidget {
  final int reservationId;

  const EditReservationModal({
    super.key,
    required this.reservationId,
  });

  @override
  State<EditReservationModal> createState() => _EditReservationModalState();
}

class _EditReservationModalState extends State<EditReservationModal>
    with TickerProviderStateMixin {
  late EditReservationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditReservationModel());
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
                buildTitle(context, 'Edit Reservation'),
                _buildBody(context),
                buildButtons(
                    context, () => _model.editReservation(), 'Save Changes'),
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
              _buildVenueNameInputField(context),
              _buildUserInputField(context),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildNumberOfGuestsInputField(context),
              _buildReservationDateInputField(context),
            ].divide(const SizedBox(width: 32)),
          ),
        ].divide(
          const SizedBox(height: 24),
        ),
      ),
    );
  }

  Widget _buildVenueNameInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.venueNameTextController,
        focusNode: _model.venueNameFocusNode,
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

  Widget _buildUserInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.userTextController,
        focusNode: _model.userFocusNode,
        decoration: InputDecoration(
          enabled: false,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: 'User details (email, username)',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
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

  Widget _buildNumberOfGuestsInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.numberOfGuestsTextController,
        focusNode: _model.numberOfGuestsFocusNode,
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildReservationDateInputField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _model.reservationDateTextController,
        focusNode: _model.reservationDateFocusNode,
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

              _model.reservationDateTextController.text = formattedDateTime;
            }
          }
        },
        decoration: InputDecoration(
          labelText: 'Reservation Date',
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
