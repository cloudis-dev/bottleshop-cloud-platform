import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
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
    useProvider(editedHoursProvider).state;
    final openingHours = useProvider(hoursProvider).state;
    final today = openingHours?.today(rowIndex);

    void newOpeningHours(
        OpeningHoursModel? openingHours, bool? value, int rowIndex) {
      context.read(hoursProvider).state = openingHours?.setDay(
        rowIndex,
        value == false
            ? OpeningHoursEntryModel.closed()
            : OpeningHoursEntryModel.opened(),
      );
    }

    return Checkbox(
      key: ValueKey(rowIndex),
      value: OpeningHoursModel.isOpened(today),
      onChanged: (value) {
        context.read(editedHoursProvider).state = openingHours;
        newOpeningHours(openingHours, value, rowIndex);
      },
    );
  }
}
