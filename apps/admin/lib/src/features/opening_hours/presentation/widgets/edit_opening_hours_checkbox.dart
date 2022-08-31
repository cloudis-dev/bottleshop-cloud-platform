import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursCheckbox extends HookWidget {
  const EditOpeningHoursCheckbox({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    final openingHoursMap = useProvider(editHoursProvider).state;
    var weAreOpen = false;

    if (openingHoursMap![sortedWeekDays[rowIndex]][0] != '0' ||
        openingHoursMap[sortedWeekDays[rowIndex]][1] != '0') {
      weAreOpen = true;
    }

    return Checkbox(
      key: ValueKey(rowIndex),
      value: weAreOpen,
      onChanged: (value) {
        final newMap = Map.fromEntries(openingHoursMap.entries);

        if (value == false) {
          newMap[sortedWeekDays[rowIndex]][0] = '0';
          newMap[sortedWeekDays[rowIndex]][1] = '0';
        } else {
          newMap[sortedWeekDays[rowIndex]][0] = '88:88';
          newMap[sortedWeekDays[rowIndex]][1] = '88:88';
        }
        context.read(editHoursProvider).state = newMap;
      },
    );
  }
}
