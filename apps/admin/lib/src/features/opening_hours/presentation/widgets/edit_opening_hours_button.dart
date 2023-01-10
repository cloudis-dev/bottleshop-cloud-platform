import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursButton extends HookWidget {
  const EditOpeningHoursButton({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    useProvider(editedHoursProvider).state;
    final currentTime = TimeOfDay.now();
    final openingHoursMap = useProvider(hoursProvider).state;
    final todayOpening = openingHoursMap!.today(rowIndex);
    final tempMap = Map.fromEntries(openingHoursMap.toMap().entries);
    final tempList = [todayOpening.opening, todayOpening.closing];
    final weAreOpen = OpeningHoursModel.isOpened(todayOpening);
    late Map<String, dynamic>? newMap;

    Future<void> timePicker() => showDialog(
          context: context,
          builder: (context) => TimePickerDialog(initialTime: currentTime),
        );

    Future<void> pickNewTime(int index) async {
      timePicker;
      final newTime =
          await showTimePicker(context: context, initialTime: currentTime);
      OpeningHoursEntryModel.amendMidnight(newTime, tempList, index);
      OpeningHoursEntryModel.replaceOldTime(tempMap, tempList, rowIndex);

      if (newTime == null) {
        newMap = null;
      } else {
        newMap = OpeningHoursEntryModel.toMap(tempMap);
      }
    }

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: tempList.length,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: !weAreOpen
                ? null
                : () {
                    pickNewTime(index).then(
                      (_) {
                        if (newMap == null) {
                          return null;
                        } else {
                          context.read(editedHoursProvider).state =
                              OpeningHoursModel.fromMap(newMap!);
                          return context.read(hoursProvider).state =
                              OpeningHoursModel.fromMap(newMap!);
                        }
                      },
                    );
                  },
            child: Text(tempList[index]),
          );
        },
      ),
    );
  }
}
