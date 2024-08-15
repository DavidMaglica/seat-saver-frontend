import 'package:diplomski/api/data/venue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/appbar.dart';
import '../../components/custom_choice_chips.dart';
import '../../components/navbar.dart';
import '../../utils/routing_utils.dart';
import 'models/search_model.dart';

export 'models/search_model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final int pageIndex = 1;
  late SearchModel _model;
  List<String> _chipsOptions = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());
    _getChipsChoice();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _getChipsChoice() {
    List<String> options =
        VenueType.values.map((type) => type.toString()).toList();
    setState(() {
      _chipsOptions = options;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void onChanged(String value) {
    debugPrint("Searching for: $value");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
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
                  _buildSearchBar(_model.searchBarController),
                  Flexible(
                    child: CustomChoiceChips(
                      options: _chipsOptions,
                      initialValues: const [],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildListTitle('Restaurant 1'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 1'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 2'),
                          _buildDivider(),
                          _buildListTitle('Restaurant 2'),
                          _buildDivider(),
                          _buildListTitle('Restaurant 3'),
                          _buildDivider(),
                          _buildListTitle('Coffee Shop 3')
                        ],
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
                onNavbarItemTapped(pageIndex, index, context),
          )),
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
                  onChanged: (value) => onChanged(value),
                ),
              ),
            ),
          ],
        ),
      );

  Padding _buildListTitle(String title) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        child: ListTile(
          title: Text(
            title,
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
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
        child: Divider(
          indent: 36,
          endIndent: 36,
          thickness: .5,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
}
