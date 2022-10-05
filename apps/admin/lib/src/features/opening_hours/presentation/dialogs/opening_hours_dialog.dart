import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/dialogs/edit_opening_hours_dialog.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/day_of_the_week.dart';

class OpeningHoursDialog extends HookWidget {
  const OpeningHoursDialog({Key? key}) : super(key: key);

  Future<void> editOpeningHoursDialog(BuildContext context) => showDialog(
      context: context, builder: (context) => EditOpeningHoursDialog());

  @override
  Widget build(BuildContext context) {
    return useProvider(openingHoursProvider).when(
      data: (value) {
        late Map<String, OpeningHours> tempMap;

        for (var element in value.docs) {
          tempMap = element.data().map(
                (key, value) => MapEntry(
                  key,
                  OpeningHours(opening: value[0], closing: value[1]),
                ),
              );
        }

        return AlertDialog(
          title: Text('Opening Hours', textAlign: TextAlign.center),
          content: SizedBox(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: tempMap.length,
                  itemBuilder: (context, index) {
                    return DayOfTheWeek(
                      day: sortedWeekDays[index],
                      hours: tempMap[sortedWeekDays[index]] as OpeningHours,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read(editHoursProvider).state =
                        Map.fromEntries(tempMap.entries);
                    editOpeningHoursDialog(context);
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
