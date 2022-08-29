import 'package:flutter/material.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursCheckbox extends StatefulWidget {
   EditOpeningHoursCheckbox({
    Key? key,
    required this.rowIndex,
    required this.weAreOpen,
    required this.tempMap,
  }) : super(key: key);

  final int rowIndex;
  bool weAreOpen;
  final Map<String, dynamic> tempMap;

  @override
  State<EditOpeningHoursCheckbox> createState() =>
      _EditOpeningHoursCheckboxState();
}

class _EditOpeningHoursCheckboxState extends State<EditOpeningHoursCheckbox> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.weAreOpen;
    });

    final todayOpening = widget.tempMap[sortedWeekDays[widget.rowIndex]];

    return Checkbox(
      key: ValueKey(widget.rowIndex),
      value: widget.weAreOpen,
      onChanged: (value) {
        if (value == false) {
          todayOpening[0] = '0';
          todayOpening[1] = '0';
        } else {
          todayOpening[0] = '88:88';
          todayOpening[1] = '88:88';
        }
        setState(() {
          widget.weAreOpen = value!;
        });
      },
    );
  }
}
