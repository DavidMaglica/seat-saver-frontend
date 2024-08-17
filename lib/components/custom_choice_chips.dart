import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class CustomChoiceChips extends StatefulWidget {
  final List<String> options;
  final Function(List<String>?)? onChanged;
  final List<String>? initialValues;

  const CustomChoiceChips({
    Key? key,
    required this.options,
    this.onChanged,
    this.initialValues,
  }) : super(key: key);

  @override
  _CustomChoiceChipsState createState() => _CustomChoiceChipsState();
}

class _CustomChoiceChipsState extends State<CustomChoiceChips> {
  late List<String>? selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialValues ?? [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterFlowChoiceChips(
            options: widget.options.map((option) => ChipData(option)).toList(),
            onChanged: (val) {
              setState(() {
                selectedValues = val;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(selectedValues);
              }
            },
            selectedChipStyle: ChipStyle(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: Theme.of(context).textTheme.headlineMedium,
              elevation: 4,
              borderRadius: BorderRadius.circular(16),
            ),
            unselectedChipStyle: ChipStyle(
              backgroundColor: Theme.of(context).colorScheme.surface,
              textStyle: Theme.of(context).textTheme.headlineSmall,
              elevation: 1,
              borderRadius: BorderRadius.circular(16),
            ),
            chipSpacing: 8,
            rowSpacing: 12,
            multiselect: true,
            initialized: selectedValues!.isNotEmpty,
            alignment: WrapAlignment.spaceEvenly,
            controller: FormFieldController<List<String>>(
              selectedValues,
            ),
          ),
        ],
      ),
    );
  }
}
