import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/data/venue.dart';
import '../../api/venue_api.dart';
import '../../components/appbar.dart';
import '../../components/custom_choice_chips.dart';
import '../../components/navbar.dart';
import '../../utils/routing_utils.dart';

class Search extends StatefulWidget {
  final String? email;

  const Search({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final unfocusNode = FocusNode();

  final int pageIndex = 1;

  List<String> _chipsOptions = [];
  FormFieldController<List<String>>? choiceChipsValueController;

  List<String>? get choiceChipsValues => choiceChipsValueController?.value;

  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;

  TextEditingController? searchBarController;

  List<Venue> _allVenues = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getChipsChoice();
    _getAllVenues();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  void _getChipsChoice() {
    List<String> options =
        VenueType.values.map((type) => type.toString()).toList();
    setState(() {
      _chipsOptions = options;
    });
  }

  void _getAllVenues() => getSortedVenues().then((value) => safeSetState(() {
        _allVenues = value;
      }));

  void _search(String value) {
    debugPrint("Searching for: $value");
  }

  Function() _onTap(Venue venue) =>
      () => Navigator.pushNamed(context, '/venue', arguments: {
            'name': venue.name,
            'location': venue.location,
            'workingHours': venue.workingHours,
            'rating': venue.rating,
            'type': venue.type.toString(),
            'description': venue.description,
          });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppbar(title: ''),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchBar(searchBarController),
                Flexible(
                  child: CustomChoiceChips(
                    options: _chipsOptions,
                    initialValues: const [],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
                    child: _allVenues.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _allVenues.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  _buildListTitle(_allVenues[index]),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          currentIndex: pageIndex,
          context: context,
          onTap: (index, context) =>
              onNavbarItemTapped(pageIndex, index, context, widget.email),
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
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        child: ListTile(
          onTap: _onTap(venue),
          title: Text(
            venue.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 20,
          ),
          tileColor: Theme.of(context).colorScheme.surfaceVariant,
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
}
