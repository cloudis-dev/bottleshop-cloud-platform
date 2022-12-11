import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursEntryModel {
  final String opening;
  final String closing;

  OpeningHoursEntryModel({
    required this.opening,
    required this.closing,
  });

  static Map<String, OpeningHoursEntryModel> fromMap(
      QuerySnapshot<Map<String, dynamic>> map) {
    late Map<String, OpeningHoursEntryModel> tempMap;
    for (var element in map.docs) {
      tempMap = element.data().map(
            (key, value) => MapEntry(
              key,
              OpeningHoursEntryModel(opening: value[0], closing: value[1]),
            ),
          );
    }
    return tempMap;
  }

  static Map<String, dynamic> toMap(Map<String, OpeningHoursEntryModel> map) {
    final newMap = map.map((key, value) => MapEntry(
          key,
          [value.opening, value.closing],
        ));
    return newMap;
  }

  bool isOpened() {
    var isOpened = true;
    if (opening == '0' || closing == '0') {
      isOpened = false;
    }
    return isOpened;
  }

  static Future<void> timePicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => TimePickerDialog(
          initialTime: TimeOfDay.now(),
        ),
      );

  static void amendMidnight(
      TimeOfDay? newTime, List<String> tempList, int index) {
    if (newTime != null) {
      tempList[index] = timeToString(newTime);
      if (tempList[index] == '00:00') {
        tempList[index] = '24:00';
      }
    }
  }

  static String timeToString(TimeOfDay newTime) {
    return '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
  }

  static Future<void> pickNewTime(
    BuildContext context,
    List<String> tempList,
    int index,
    int rowIndex,
  ) async {
    final openingHoursMap = useProvider(editedHoursProvider).state;
    final editHoursMap = context.read(editedHoursProvider).state?.toMap();
    final currentTime = TimeOfDay.now();
    final todayOpening = openingHoursMap!.today(rowIndex);
    final tempList = [todayOpening.opening, todayOpening.closing];
    timePicker;
    final newTime =
        await showTimePicker(context: context, initialTime: currentTime);
    final tempMap = Map.fromEntries(editHoursMap!.entries);

    amendMidnight(newTime, tempList, index);
    tempMap[sortedWeekDays[rowIndex]] = OpeningHoursEntryModel(
      opening: tempList[0],
      closing: tempList[1],
    );
    context.read(editedHoursProvider).state =
        OpeningHoursModel.fromMap(tempMap);
  }

  static String showClosingTime(String day, OpeningHoursEntryModel hours) {
    return (hours.opening == '0' || hours.closing == '0')
        ? '$day: Closed'
        : '$day:  ${hours.opening} - ${hours.closing}';
  }
}
