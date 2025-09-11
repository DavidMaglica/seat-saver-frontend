import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/data/venue.dart';
import 'package:seat_saver/components/mobile/modal_widgets.dart';
import 'package:seat_saver/components/mobile/navbar.dart';
import 'package:seat_saver/models/mobile/views/search_model.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/utils/extensions.dart';
import 'package:seat_saver/utils/routing_utils.dart';

class Search extends StatelessWidget {
  final int? userId;
  final String? locationQuery;
  final SearchModel? modelOverride;

  const Search({
    super.key,
    this.userId,
    this.locationQuery,
    this.modelOverride,
  });

  void _clear(BuildContext context, SearchModel model) {
    Navigator.pop(context);
    model.clearFilters();
  }

  void _applyFilters(BuildContext context,
    SearchModel model,
    List<String> tempSelected,
  ) {
    Navigator.pop(context);
    model.filterVenues(tempSelected);
  }

  void _cancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => modelOverride ?? SearchModel()
        ..init(locationQuery),
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
                  child: Column(
                    children: [
                      _buildSearchBar(context, model),
                      const SizedBox(height: 36),
                      _buildFilterDropdown(context, model),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _buildPaginatedVenues(model),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: NavBar(
                  currentIndex: model.pageIndex,
                  onTap: (index, context) =>
                      onNavbarItemTapped(context, model.pageIndex, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginatedVenues(SearchModel model) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
      child: model.paginatedVenues.isNotEmpty
          ? ListView.builder(
              controller: model.scrollController,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: model.paginatedVenues.length,
              itemBuilder: (context, index) {
                if (index == model.paginatedVenues.length &&
                    model.hasMorePages) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: MobileTheme.accent1,
                        size: 75,
                      ),
                    ),
                  );
                }

                final venue = model.paginatedVenues[index];
                final venueType = model.venueTypeMap[venue.typeId] ?? '';

                return Column(
                  children: [
                    _buildListTitle(
                      context,
                      model,
                      'venueListTile',
                      venue,
                      venueType,
                    ),
                    if (index < model.paginatedVenues.length - 1)
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
    );
  }

  Widget _buildSearchBar(BuildContext context, SearchModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 36),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: TextField(
              key: const Key('searchBar'),
              controller: model.searchBarController,
              decoration: InputDecoration(
                hintText: 'Type to search for venues (by name or city)',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: MobileTheme.accent1),
                ),
              ),
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) => model.search(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTitle(BuildContext context,
    SearchModel model,
    String key,
    Venue venue,
    String? venueType,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        key: Key(key),
        onTap: model.goToVenuePage(context, venue),
        title: Text(venue.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          venueType != null ? venueType.toTitleCase() : 'Loading...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 14,
        ),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      indent: 36,
      endIndent: 36,
      thickness: .5,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildFilterDropdown(BuildContext context, SearchModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        key: const Key('filterDropdown'),
        onTap: () => _showTypeFilter(context, model),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceDim,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdownText(context, model),
              _buildDropdownIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownIcon() {
    return const Icon(CupertinoIcons.chevron_down, size: 16);
  }

  Widget _buildDropdownText(BuildContext context, SearchModel model) {
    return Expanded(
      child: Text(
        model.selectedTypes.isEmpty
            ? 'Filter by type'
            : model.selectedTypes.join(', '),
        style: TextStyle(
          color: model.selectedTypes.isEmpty
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onPrimary,
          fontWeight: model.selectedTypes.isEmpty
              ? FontWeight.w200
              : FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  void _showTypeFilter(BuildContext context, SearchModel model) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        List<String> tempSelected = [...model.selectedTypes];

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              key: const Key('filterModal'),
              height: 456,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
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
                        'clearFiltersModalButton',
                        'Clear filters',
                        () => _clear(context, model),
                        MobileTheme.errorColor,
                      ),
                      buildModalButton(
                        'applyFiltersModalButton',
                        'Apply',
                        () => _applyFilters(context, model, tempSelected),
                        MobileTheme.successColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildModalButton(
                        'cancelModalButton',
                        'Cancel',
                        () => _cancel(context),
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownItem(BuildContext context,
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
              color: Theme.of(context).colorScheme.onPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              key: Key('filterSwitch_$type'),
              value: isSelected,
              onChanged: (bool value) {
                setModalState(() {
                  value ? tempSelected.add(type) : tempSelected.remove(type);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
