import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/dialogs/edit_opening_hours_dialog.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/day_of_the_week.dart';

class OpeningHoursDialog extends HookWidget {
  const OpeningHoursDialog({Key? key}) : super(key: key);

  Future<void> editOpeningHoursDialog(
          BuildContext context, Map<String, OpeningHoursEntryModel> newHours) =>
      showDialog(
        context: context,
        builder: (context) => EditOpeningHoursDialog(newHours: newHours),
      );

  @override
  Widget build(BuildContext context) {
    return useProvider(openingHoursProvider).when(
      data: (value) {
        final providedMap = value.toMap();
        return AlertDialog(
          title: Text('Opening Hours', textAlign: TextAlign.center),
          content: SizedBox(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: providedMap.length,
                  itemBuilder: (context, index) {
                    return DayOfTheWeek(
                      day: sortedWeekDays[index],
                      hours: providedMap[sortedWeekDays[index]],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    editOpeningHoursDialog(context, providedMap);
                  },
                  child: Text('Edit opening hours'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
