import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../api/data/venue.dart';
import '../../components/navbar.dart';
import '../../models/search_model.dart';
import '../../themes/theme.dart';
import '../../utils/extensions.dart';
import '../../utils/routing_utils.dart';

class Search extends StatelessWidget {
  final String? userEmail;
  final Position? userLocation;
  final int? selectedVenueType;

  const Search({
    Key? key,
    this.userEmail,
    this.userLocation,
    this.selectedVenueType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SearchModel(
              context: context,
              userEmail: userEmail,
              userLocation: userLocation,
            )..init(),
        child: Consumer<SearchModel>(
          builder: (context, model, _) {
            return GestureDetector(
              onTap: () => model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
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
                                  blurRadius: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.6),
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
                                        String venueType =
                                            model.venueTypeMap[venue.typeId] ??
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
                                        padding: EdgeInsets.all(16.0),
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
                  context: context,
                  onTap: (index, context) => onNavbarItemTapped(
                      context, model.pageIndex, index, userEmail, userLocation),
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
                  hintText: 'Search',
                  hintStyle: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      color:
                          Theme.of(ctx).colorScheme.onPrimary.withOpacity(0.5)),
                  prefixIcon: const Icon(CupertinoIcons.search),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(ctx).colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                  ),
                ),
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
        onTap: model.goToVenuePage(venue),
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
                    children: [
                      _buildBorderedButton('Apply', AppThemes.successColor, () {
                        Navigator.pop(context);

                        model.selectedTypes = tempSelected;

                        model.filterVenues(model.selectedTypes);
                      }),
                      _buildBorderedButton('Clear', AppThemes.errorColor, () {
                        Navigator.pop(context);

                        model.selectedTypes.clear();

                        model.getAllVenues();
                      })
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildBorderedButton(
                        'Cancel',
                        Theme.of(context).colorScheme.onPrimary,
                        () {
                          Navigator.of(context).pop();
                        },
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

  Widget _buildBorderedButton(String text, Color colour, VoidCallback action) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colour,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
              onPressed: action,
              child: Text(
                text,
                style: TextStyle(
                  color: colour,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )),
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
                color: Theme.of(ctx).colorScheme.onPrimary),
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
