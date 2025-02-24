import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/data/venue.dart';
import '../../api/venue_api.dart';
import '../../components/navbar.dart';
import '../../utils/constants.dart';
import '../../utils/routing_utils.dart';

class Search extends StatefulWidget {
  final String? userEmail;
  final Position? userLocation;
  final String? selectedChip;

  const Search({
    Key? key,
    this.userEmail,
    this.userLocation,
    this.selectedChip,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final unfocusNode = FocusNode();

  final int pageIndex = 1;

  List<String> _chipsOptions = [];

  TextEditingController? searchBarController;

  List<Venue> _allVenues = [];
  List<bool>? selectedChips = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  VenueApi venueApi = VenueApi();

  @override
  void initState() {
    super.initState();
    _getChipsChoice();
    _getAllVenues();

    if (widget.selectedChip != null) {
      final index = _chipsOptions.indexOf(widget.selectedChip!);
      selectedChips = List.generate(_chipsOptions.length, (index) => false);
      selectedChips![index] = true;
    }

    if (selectedChips != null) {
      _filterVenues(selectedChips);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  void _filterVenues(List<bool>? selectedChips) async {
    if (selectedChips == null) {
      return;
    }

    final selectedTypes = <VenueType>[];
    for (var i = 0; i < selectedChips.length; i++) {
      if (selectedChips[i]) {
        selectedTypes.add(VenueType.values[i]);
      }
    }

    if (selectedTypes.isEmpty) {
      _getAllVenues();
      return;
    }

    List<Venue> filteredVenues = await venueApi.getVenuesByType(selectedTypes);

    safeSetState(() {
      _allVenues = filteredVenues;
    });
  }

  void _getChipsChoice() {
    List<String> options =
        VenueType.values.map((type) => type.toString()).toList();
    setState(() {
      _chipsOptions = options;
      selectedChips = List.generate(options.length, (index) => false);
    });
  }

  void _getAllVenues() => venueApi.getSortedVenues().then((value) => safeSetState(() {
        _allVenues = value;
      }));

  void _search(String value) {
    if (value.isEmpty) {
      _getAllVenues();
      return;
    }

    List<Venue> filteredVenues = _allVenues
        .where(
            (venue) => venue.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    safeSetState(() {
      _allVenues = filteredVenues;
    });
  }

  Function() _goToVenuePage(Venue venue) =>
      () => Navigator.pushNamed(context, Routes.VENUE, arguments: {
            'venueName': venue.name,
            'location': venue.location,
            'workingHours': venue.workingHours,
            'rating': venue.rating,
            'type': venue.type.toString(),
            'description': venue.description,
            'userEmail': widget.userEmail,
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
                _buildSearchBar(searchBarController),
                Flexible(
                  child: _buildChoiceChips(_chipsOptions),
                ),
                Flexible(
                  child: Padding(
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
                          child: _allVenues.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _allVenues.length,
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      _buildListTitle(_allVenues[index]),
                                      if (index < _allVenues.length - 1)
                                        _buildDivider(),
                                    ]);
                                  })
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('No venues available'),
                                  ),
                                )),
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

  Padding _buildSearchBar(TextEditingController? controller) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(36, 36, 36, 0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
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

  Padding _buildListTitle(Venue venue) => Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          onTap: _goToVenuePage(venue),
          title: Text(
            venue.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            venue.type.toString(),
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

  Padding _buildChoiceChips(List<String> chipsOptions) => Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 12, horizontal: 2),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(chipsOptions.length, (index) {
            return FilterChip(
              label: Text(
                chipsOptions[index],
                style: TextStyle(
                  color: selectedChips![index]
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              elevation: 5,
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              showCheckmark: false,
              selected: selectedChips == null ? false : selectedChips![index],
              onSelected: (bool selected) {
                setState(() {
                  selectedChips?[index] = selected;
                });
                _filterVenues(selectedChips);
              },
            );
          }),
        ),
      );
}
