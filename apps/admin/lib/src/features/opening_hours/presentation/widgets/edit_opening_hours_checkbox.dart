import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
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

    if (openingHoursMap![sortedWeekDays[rowIndex]]!.opening != '0' ||
        openingHoursMap[sortedWeekDays[rowIndex]]!.closing != '0') {
      weAreOpen = true;
    }

    return Checkbox(
      key: ValueKey(rowIndex),
      value: weAreOpen,
      onChanged: (value) {
        final newMap = Map.fromEntries(openingHoursMap.entries);

        if (value == false) {
          newMap[sortedWeekDays[rowIndex]] =
              OpeningHours(opening: '0', closing: '0');
        } else {
          newMap[sortedWeekDays[rowIndex]] =
              OpeningHours(opening: '88:88', closing: '88:88');
        }
        context.read(editHoursProvider).state = newMap;
      },
    );
  }
}
