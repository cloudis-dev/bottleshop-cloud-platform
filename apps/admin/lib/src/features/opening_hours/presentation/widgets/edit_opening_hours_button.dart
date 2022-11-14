import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursButton extends HookWidget {
  const EditOpeningHoursButton({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  Future<void> timePicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => TimePickerDialog(
          initialTime: TimeOfDay.now(),
        ),
      );

  String timeToString(TimeOfDay newTime) {
    return '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final openingHoursMap = useProvider(editHoursProvider).state;
    final editHoursMap = context.read(editHoursProvider).state;
    final currentTime = TimeOfDay.now();
    final todayOpening = openingHoursMap![sortedWeekDays[rowIndex]];
    final tempList = [todayOpening!.opening, todayOpening.closing];
    final weAreOpen =
        OpeningHoursModel.isOpened(todayOpening.opening, todayOpening.closing);

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
                : () async {
                    timePicker;
                    final newTime = await showTimePicker(
                        context: context, initialTime: currentTime);
                    final tempMap = Map.fromEntries(editHoursMap!.entries);
                    if (newTime != null) {
                      tempList[index] = timeToString(newTime);
                      if (tempList[index] == '00:00') {
                        tempList[index] = '24:00';
                      }
                    }
                    tempMap[sortedWeekDays[rowIndex]] = OpeningHoursModel(
                        opening: tempList[0], closing: tempList[1]);
                    context.read(editHoursProvider).state = tempMap;
                  },
            child: Text(tempList[index]),
          );
        },
      ),
    );
  }
}
