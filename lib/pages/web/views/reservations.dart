import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_table/flutter_advanced_table.dart';
import 'package:flutter_advanced_table/params.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/data/reservation_details.dart';
import 'package:table_reserver/components/web/modals/create_reservation_modal.dart';
import 'package:table_reserver/components/web/modals/delete_modal.dart';
import 'package:table_reserver/components/web/modals/edit_reservation_modal.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/models/web/modals/create_reservation_model.dart';
import 'package:table_reserver/models/web/views/reservations_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class WebReservations extends StatefulWidget {
  const WebReservations({super.key});

  @override
  State<WebReservations> createState() => _WebReservationsState();
}

class _WebReservationsState extends State<WebReservations>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ValueNotifier<bool> isLoadingTable = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReservationsModel()
        ..fetchReservations()
        ..fetchOwnedVenues(),
      child: Consumer<ReservationsModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                top: true,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SideNav(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child:
                            Material(
                              color: Theme.of(context).colorScheme.onSurface,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHeading(context, model),
                                    Expanded(
                                      child: _buildTable(context, model),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(
                              model
                                  .animationsMap['containerOnPageLoadAnimation']!,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row _buildHeading(BuildContext context, ReservationsModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Reservations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'View and edit or delete your reservations in this scrollable table.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        FFButtonWidget(
          onPressed: () async {
            final shouldRefresh = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: ChangeNotifierProvider(
                        create: (_) =>
                            CreateReservationModel()..fetchOwnedVenues(),
                        child: Consumer<CreateReservationModel>(
                          builder: (context, model, _) {
                            return CreateReservationModal(model: model);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
            if (shouldRefresh == true) {
              model.fetchReservations();
            }
          },
          text: 'Create a Reservation',
          icon: const Icon(CupertinoIcons.add_circled, size: 24),
          options: FFButtonOptions(
            height: 40,
            iconColor: Theme.of(context).colorScheme.primary,
            color: WebTheme.successColor,
            textStyle: const TextStyle(fontSize: 16, color: WebTheme.offWhite),
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  dynamic _buildTable(BuildContext context, ReservationsModel model) {
    List<int> reservationIds = model.reservations
        .map((reservation) => reservation.id)
        .toList();

    if (model.reservations.isEmpty && !model.isLoadingTable.value) {
      return Center(
        child: Text(
          'No reservations found.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return AdvancedTableWidget(
      headerBuilder: (context, header) {
        return _buildHeader(context, header);
      },
      headerDecoration: const BoxDecoration(
        color: WebTheme.accent1,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      rowElementsBuilder: (context, rowParams) {
        return _buildRows(context, model, rowParams, model.reservations);
      },
      items: model.reservations,
      isLoadingAll: model.isLoadingTable,
      fullLoadingPlaceHolder: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: WebTheme.accent1,
          size: 75,
        ),
      ),
      headerItems: model.tableHeaders,
      actionBuilder: (context, actionParams) {
        final reservationId = reservationIds[actionParams.rowIndex];
        final reservation = model.reservations[actionParams.rowIndex];
        final venueName =
            model.venueNamesById[reservation.venueId] ?? 'Unknown Venue';
        final userName =
            model.userNamesById[reservation.userId] ?? 'Unknown User';

        return _buildActions(
          context,
          reservationId,
          reservation.venueId,
          venueName,
          userName,
        );
      },
      actions: const [
        {"label": "edit and delete"},
      ],
      rowDecorationBuilder: (index, isHovered) {
        return _buildRowDecoration(context, index, isHovered);
      },
    );
  }

  Row _buildActions(
    BuildContext context,
    int reservationId,
    int venueId,
    String venueName,
    String userName,
  ) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            bool? shouldRefresh = await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (_) {
                return EditReservationModal(
                  reservationId: reservationId,
                  venueName: venueName,
                  userName: userName,
                );
              },
            );
            if (shouldRefresh == true) {
              Provider.of<ReservationsModel>(
                context,
                listen: false,
              ).fetchReservations();
            }
          },
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.trash,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            bool? shouldRefresh = await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (_) {
                return DeleteModal(
                  modalType: DeleteModalType.reservation,
                  reservationId: reservationId,
                  venueName: venueName,
                  userName: userName,
                );
              },
            );
            if (shouldRefresh == true) {
              Provider.of<ReservationsModel>(
                context,
                listen: false,
              ).fetchReservations();
            }
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, HeaderBuilder header) {
    return Container(
      width: header.defualtWidth,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          header.value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<SizedBox> _buildRows(
    BuildContext context,
    ReservationsModel model,
    RowBuilderParams rowParams,
    List<ReservationDetails> reservations,
  ) {
    DateFormat dateFormat = DateFormat('dd MMMM, yyyy - HH:mm');
    final reservation = reservations[rowParams.index];
    final venueName =
        model.venueNamesById[reservation.venueId] ?? 'Unknown Venue';
    final userName = model.userNamesById[reservation.userId] ?? 'Unknown User';
    return [
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(
          child: Text(venueName, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(
          child: Text(userName, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(
          child: Text(
            '${reservation.numberOfGuests}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      SizedBox(
        width: rowParams.defualtWidth,
        child: Center(
          child: Text(
            dateFormat.format(reservation.datetime),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    ];
  }

  BoxDecoration _buildRowDecoration(
    BuildContext context,
    int index,
    bool isHover,
  ) {
    final isOdd = index % 2 == 0;
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: isHover
          ? WebTheme.infoColor
          : !isOdd
          ? Colors.transparent
          : Theme.of(context).colorScheme.surface,
    );
  }
}
