import 'package:TableReserver/api/data/venue.dart';
import 'package:TableReserver/components/modal_widgets.dart';
import 'package:TableReserver/components/navbar.dart';
import 'package:TableReserver/models/search_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/extensions.dart';
import 'package:TableReserver/utils/routing_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  final int? userId;
  final Position? userLocation;

  const Search({
    Key? key,
    this.userId,
    this.userLocation,
  }) : super(key: key);

  void _clear(BuildContext ctx, SearchModel model) {
    Navigator.pop(ctx);
    model.clearFilters();
  }

  void _applyFilters(
      BuildContext ctx, SearchModel model, List<String> tempSelected) {
    Navigator.pop(ctx);
    model.filterVenues(tempSelected);
  }

  void _cancel(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SearchModel(
              context: context,
            )..init(),
        child: Consumer<SearchModel>(
          builder: (context, model, _) {
            var brightness = Theme.of(context).brightness;
            return GestureDetector(
              onTap: () => model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: Scaffold(
                  key: model.scaffoldKey,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSearchBar(context, model),
                          _buildFilterDropdown(context, model),
                          Padding(
                            padding: const EdgeInsetsDirectional.all(12),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 4,
                                    color: Theme.of(context).colorScheme.outline,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 12),
                                child: model.allVenues.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: model.allVenues.length,
                                        itemBuilder: (context, index) {
                                          Venue venue = model.allVenues[index];
                                          String venueType = model
                                                  .venueTypeMap[venue.typeId] ??
                                              'Loading...';

                                          return Column(
                                            children: [
                                              _buildListTitle(
                                                context,
                                                model,
                                                venue,
                                                venueType,
                                              ),
                                              if (index <
                                                  model.allVenues.length - 1)
                                                _buildDivider(context),
                                            ],
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text('No venues available'),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: NavBar(
                    currentIndex: model.pageIndex,
                    onTap: (index, context) => onNavbarItemTapped(
                      context,
                      model.pageIndex,
                      index,
                      userId,
                      userLocation,
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildSearchBar(BuildContext ctx, SearchModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(36, 36, 36, 0),
              child: TextField(
                controller: model.searchBarController,
                decoration: InputDecoration(
                  hintText: 'Type to search for venues',
                  hintStyle: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      color:
                          Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.5)),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Theme.of(ctx).colorScheme.onPrimary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(ctx).colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppThemes.accent1,
                    ),
                  ),
                ),
                cursorColor: Theme.of(ctx).colorScheme.onPrimary,
                style: Theme.of(ctx).textTheme.bodyLarge,
                onChanged: (value) => model.search(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTitle(
    BuildContext ctx,
    SearchModel model,
    Venue venue,
    String? venueType,
  ) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: model.goToVenuePage(venue, userId, userLocation),
        title: Text(
          venue.name,
          style: Theme.of(ctx).textTheme.titleMedium,
        ),
        subtitle: Text(
          venueType != null ? venueType.toTitleCase() : 'Loading...',
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                color: Theme.of(ctx).colorScheme.onPrimary.withOpacity(.6),
              ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(ctx).colorScheme.onPrimary,
          size: 14,
        ),
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Divider(
        indent: 36,
        endIndent: 36,
        thickness: .5,
        color: Theme.of(ctx).colorScheme.onBackground,
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext ctx, SearchModel model) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
            onTap: () => _showTypeFilter(ctx, model),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDropdownText(ctx, model),
                      _buildDropdownIcon(),
                    ]))));
  }

  Icon _buildDropdownIcon() =>
      const Icon(CupertinoIcons.chevron_down, size: 16);

  Widget _buildDropdownText(BuildContext ctx, SearchModel model) {
    return Expanded(
      child: Text(
        model.selectedTypes.isEmpty
            ? 'Filter by type'
            : model.selectedTypes.join(', '),
        style: TextStyle(
          color: model.selectedTypes.isEmpty
              ? Theme.of(ctx).colorScheme.onSecondary
              : Theme.of(ctx).colorScheme.onPrimary,
          fontWeight:
              model.selectedTypes.isEmpty ? FontWeight.w200 : FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  void _showTypeFilter(BuildContext ctx, SearchModel model) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (context) {
        List<String> tempSelected = [...model.selectedTypes];

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 456,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: CupertinoScrollbar(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: model.venueTypeOptions.map((type) {
                          final isSelected = tempSelected.contains(type);
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                isSelected
                                    ? tempSelected.remove(type)
                                    : tempSelected.add(type);
                              });
                            },
                            child: _buildDropdownItem(
                              context,
                              type,
                              isSelected,
                              setModalState,
                              tempSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildModalButton(
                        'Clear filters',
                        () => _clear(context, model),
                        AppThemes.errorColor,
                      ),
                      buildModalButton(
                        'Apply',
                        () => _applyFilters(context, model, tempSelected),
                        AppThemes.successColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildModalButton(
                        'Cancel',
                        () => _cancel(context),
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownItem(
    BuildContext ctx,
    String type,
    bool isSelected,
    StateSetter setModalState,
    List<String> tempSelected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Theme.of(ctx).colorScheme.onPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: isSelected,
              onChanged: (bool value) {
                setModalState(() {
                  value ? tempSelected.add(type) : tempSelected.remove(type);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
