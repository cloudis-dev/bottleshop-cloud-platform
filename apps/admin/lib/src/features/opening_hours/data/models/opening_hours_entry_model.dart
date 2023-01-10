import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursEntryModel {
  final String opening;
  final String closing;

  OpeningHoursEntryModel({
    required this.opening,
    required this.closing,
  });

  OpeningHoursEntryModel.closed()
      : opening = '0',
        closing = '0';

  OpeningHoursEntryModel.opened()
      : opening = '88:88',
        closing = '88:88';

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

  static String showClosingTime(String day, OpeningHoursEntryModel hours) {
    return (hours.opening == '0' || hours.closing == '0')
        ? '$day: Closed'
        : '$day:  ${hours.opening} - ${hours.closing}';
  }

  static void replaceOldTime(Map<String, OpeningHoursEntryModel> tempMap,
      List<String> tempList, int rowIndex) {
    tempMap[sortedWeekDays[rowIndex]] = OpeningHoursEntryModel(
      opening: tempList[0],
      closing: tempList[1],
    );
  }
}
