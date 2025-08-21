import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_reserver/themes/web_theme.dart';

class TimerDropdown extends StatelessWidget {
  final int? selectedInterval;
  final ValueChanged<int?> onChanged;

  const TimerDropdown({
    super.key,
    required this.selectedInterval,
    required this.onChanged,
  });

  final List<String> intervals = const ['Off', '15', '30', '60', '90', '120'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Auto refresh every: ",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: intervals
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item == 'Off' ? 'Off' : '$item s',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            value: selectedInterval == null
                ? 'Off'
                : selectedInterval.toString(),
            onChanged: (value) {
              if (value == 'Off') {
                onChanged(null);
              } else {
                onChanged(int.parse(value!));
              }
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 80,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(CupertinoIcons.chevron_down),
              iconSize: 16,
              iconEnabledColor: WebTheme.accent1,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 220,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onSurface,
              ),
              offset: const Offset(10, 0),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            ),
          ),
        ),
      ],
    );
  }
}
