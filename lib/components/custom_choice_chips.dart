import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart'; // Adjust the import path as necessary

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 36.0),
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
              elevation: 4.0,
              borderRadius: BorderRadius.circular(16.0),
            ),
            unselectedChipStyle: ChipStyle(
              backgroundColor: Theme.of(context).colorScheme.surface,
              textStyle: Theme.of(context).textTheme.headlineSmall,
              elevation: 0.0,
              borderRadius: BorderRadius.circular(16.0),
            ),
            chipSpacing: 8.0,
            rowSpacing: 12.0,
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
