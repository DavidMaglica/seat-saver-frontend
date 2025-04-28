import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/data/venue.dart';
import '../../api/venue_api.dart';
import '../../components/navbar.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/routing_utils.dart';

class Search extends StatefulWidget {
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
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final unfocusNode = FocusNode();
  final int pageIndex = 1;

  List<String> _venueTypeOptions = [];
  List<String> _selectedTypes = [];
  List<Venue> _allVenues = [];
  late final TextEditingController searchBarController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final VenueApi venueApi = VenueApi();

  Map<int, String> _venueTypeMap = {};

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadVenues() async {
    final venueTypes = await venueApi.getAllVenueTypes();
    final venues = await venueApi.getAllVenuesFromApi();
    venues.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _venueTypeMap = {
        for (var type in venueTypes) type.id: type.type.toTitleCase(),
      };
      _venueTypeOptions = _venueTypeMap.values.toList();
      _allVenues = venues;

      final selectedType = _venueTypeMap[widget.selectedVenueType];
      if (selectedType != null) {
        _selectedTypes.add(selectedType);
        _allVenues = venues
            .where((venue) => venue.typeId == widget.selectedVenueType)
            .toList();
      }
    });
  }

  Future<void> _getAllVenues() async {
    final venues = await venueApi.getAllVenuesFromApi();
    venues.sort((a, b) => a.name.compareTo(b.name));

    safeSetState(() => _allVenues = venues);
  }

  void _search(String value) {
    if (value.isEmpty) {
      _getAllVenues();
      return;
    }

    final filtered = _allVenues
        .where(
            (venue) => venue.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    safeSetState(() => _allVenues = filtered);
  }

  void _filterVenues(List<String> selectedTypeLabels) {
    if (selectedTypeLabels.isEmpty) {
      _getAllVenues();
      return;
    }

    final selectedTypeIds = _venueTypeMap.entries
        .where((e) => selectedTypeLabels.contains(e.value))
        .map((e) => e.key)
        .toList();

    final filteredVenues = _allVenues
        .where((venue) => selectedTypeIds.contains(venue.typeId))
        .toList();

    safeSetState(() => _allVenues = filteredVenues);
  }

  Function() _goToVenuePage(Venue venue) =>
      () => Navigator.pushNamed(context, Routes.VENUE, arguments: {
            'venueId': venue.id,
            'userEmail': widget.userEmail,
            'userLocation': widget.userLocation,
          });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchBar(),
                _buildFilterDropdown(),
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
                      padding:
                          const EdgeInsetsDirectional.symmetric(vertical: 12),
                      child: _allVenues.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _allVenues.length,
                              itemBuilder: (context, index) {
                                Venue venue = _allVenues[index];
                                String venueType =
                                    _venueTypeMap[venue.typeId] ?? 'Loading...';

                                return Column(
                                  children: [
                                    _buildListTitle(venue, venueType),
                                    if (index < _allVenues.length - 1)
                                      _buildDivider(),
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
          currentIndex: pageIndex,
          context: context,
          onTap: (index, context) => onNavbarItemTapped(
              pageIndex, index, context, widget.userEmail, widget.userLocation),
        ),
      ),
    );
  }

  Padding _buildSearchBar() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(36, 36, 36, 0),
                child: TextField(
                  controller: searchBarController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.5)),
                    prefixIcon: const Icon(CupertinoIcons.search),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) => _search(value),
                ),
              ),
            ),
          ],
        ),
      );

  Padding _buildListTitle(Venue venue, String? venueType) => Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          onTap: _goToVenuePage(venue),
          title: Text(
            venue.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            venueType != null ? venueType.toTitleCase() : 'Loading...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(.6),
                ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 14,
          ),
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  Padding _buildDivider() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: Divider(
          indent: 36,
          endIndent: 36,
          thickness: .5,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );

  Widget _buildFilterDropdown() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
          onTap: _showTypeFilter,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDropdownText(),
                    _buildDropdownIcon(),
                  ]))));

  Icon _buildDropdownIcon() =>
      const Icon(CupertinoIcons.chevron_down, size: 16);

  Expanded _buildDropdownText() => Expanded(
        child: Text(
          _selectedTypes.isEmpty ? 'Filter by type' : _selectedTypes.join(', '),
          style: TextStyle(
            color: _selectedTypes.isEmpty
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary,
            fontWeight:
                _selectedTypes.isEmpty ? FontWeight.w200 : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );

  void _showTypeFilter() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        List<String> tempSelected = [..._selectedTypes];

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
                        children: _venueTypeOptions.map((type) {
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
                        setState(() {
                          _selectedTypes = tempSelected;
                        });
                        _filterVenues(_selectedTypes);
                      }),
                      _buildBorderedButton('Clear', AppThemes.errorColor, () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedTypes.clear();
                        });
                        _getAllVenues();
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

  Expanded _buildBorderedButton(
          String text, Color colour, VoidCallback action) =>
      Expanded(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

  Container _buildDropdownItem(
    String type,
    bool isSelected,
    StateSetter setModalState,
    List<String> tempSelected,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimary),
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
