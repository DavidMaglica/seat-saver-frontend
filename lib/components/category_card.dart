import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'models/category_card_model.dart';

export 'models/category_card_model.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late CategoryCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
        child: SizedBox(
          width: 140,
          child: Stack(
            alignment: const AlignmentDirectional(0, 0),
            children: [
              Hero(
                tag: 'categoryCardImage${randomDouble(0, 100)}',
                transitionOnUserGestures: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxQYXN0YXxlbnwwfHx8fDE3MTk1MTg2MDB8MA&ixlib=rb-4.0.3&q=80&w=1080',
                    width: 128,
                    height: 128,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: 64,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text('Italian',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
