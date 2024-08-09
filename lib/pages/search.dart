import 'package:diplomski/components/appbar.dart';
import 'package:diplomski/components/custom_choice_chips.dart';
import 'package:diplomski/components/custom_list_tile.dart';
import 'package:diplomski/components/list_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../components/navbar.dart';
import '../utils/routing_utils.dart';
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

  List<String> chipsOptions = [
    'Italian',
    'Asian',
    'Gluten Free',
    'Coffee',
    'Traditional',
    'Japanese',
    'Middle Eastern',
    'Barbecue',
    'Greek',
    'Cocktails',
    'Vegetarian',
    'Vegan',
    'Fine Dining',
    'Fast Food',
    'Seafood',
    'Mexican',
    'Indian',
    'Chinese',
    'Pizza',
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          appBar: CustomAppbar(context: context),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 24.0, 0.0, 36.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 36.0, 24.0, 0.0),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              child: Align(
                                alignment:
                                    const AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text('Search',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: CustomChoiceChips(
                      options: chipsOptions,
                      initialValues: const [],
                    ),
                  ),
                  const Flexible(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 36.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomListTile(title: 'Restaurant 1'),
                          ListDivider(),
                          CustomListTile(title: 'Coffee Shop 1'),
                          ListDivider(),
                          CustomListTile(title: 'Coffee Shop 2'),
                          ListDivider(),
                          CustomListTile(title: 'Restaurant 2'),
                          ListDivider(),
                          CustomListTile(title: 'Restaurant 3'),
                          ListDivider(),
                          CustomListTile(title: 'Coffee Shop 3')
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
}
