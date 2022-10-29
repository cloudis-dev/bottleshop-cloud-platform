import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/day_of_the_week.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

class OpeningHoursDialog extends HookWidget {
  const OpeningHoursDialog({Key? key}) : super(key: key);

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

        final header = Text(
          context.l10n.openingHours,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        );

        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: header,
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
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.close),
            ),
          ],
        );
      },
      loading: () => const Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
