import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/components/web/modals/modal_widgets.dart';
import 'package:seat_saver/models/web/modals/edit_reservation_model.dart';
import 'package:seat_saver/themes/web_theme.dart';

class EditReservationModal extends StatefulWidget {
  final int reservationId;
  final String venueName;
  final String userName;

  const EditReservationModal({
    super.key,
    required this.reservationId,
    required this.venueName,
    required this.userName,
  });

  @override
  State<EditReservationModal> createState() => _EditReservationModalState();
}

class _EditReservationModalState extends State<EditReservationModal>
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
      create: (_) => EditReservationModel()
        ..init(
          context,
          widget.reservationId,
          widget.venueName,
          widget.userName,
        ),
      child: Consumer<EditReservationModel>(
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
                      buildTitle(context, 'Edit Reservation'),
                      _buildBody(context, model),
                      buildButtons(
                        context,
                        () => model.editReservation(context),
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

  Widget _buildBody(BuildContext context, EditReservationModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildVenueNameInputField(context, model),
              _buildUserInputField(context, model),
            ].divide(const SizedBox(width: 32)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildNumberOfGuestsInputField(context, model),
              _buildReservationDateInputField(context, model),
            ].divide(const SizedBox(width: 32)),
          ),
        ].divide(const SizedBox(height: 24)),
      ),
    );
  }

  Widget _buildVenueNameInputField(
    BuildContext context,
    EditReservationModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.venueNameTextController,
        focusNode: model.venueNameFocusNode,
        decoration: InputDecoration(
          enabled: false,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
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
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
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

  Widget _buildUserInputField(
    BuildContext context,
    EditReservationModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.userTextController,
        focusNode: model.userFocusNode,
        decoration: InputDecoration(
          enabled: false,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.5),
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

  Widget _buildNumberOfGuestsInputField(
    BuildContext context,
    EditReservationModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.numberOfGuestsTextController,
        focusNode: model.numberOfGuestsFocusNode,
        decoration: InputDecoration(
          labelText: 'Number of Guests',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.numberOfGuestsErrorText,
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildReservationDateInputField(
    BuildContext context,
    EditReservationModel model,
  ) {
    return Expanded(
      child: TextFormField(
        controller: model.reservationDateTextController,
        focusNode: model.reservationDateFocusNode,
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

              model.reservationDateTextController.text = formattedDateTime;
              model.reservationDate = combinedDateTime;
            }
          }
        },
        decoration: InputDecoration(
          labelText: 'Reservation Date',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.reservationDateErrorText,
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
        border: Border.all(color: WebTheme.infoColor, width: 1),
      ),
      selectedCellTextStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
      selectedCellDecoration: const BoxDecoration(
        color: WebTheme.infoColor,
        shape: BoxShape.circle,
      ),
      enabledCellsTextStyle: Theme.of(context).textTheme.bodyLarge,
      disabledCellsTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.4),
      ),
      leadingDateTextStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      daysOfTheWeekTextStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
