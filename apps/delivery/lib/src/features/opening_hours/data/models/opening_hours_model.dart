import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';

final date = DateTime.now();
final currentTime = TimeOfDay.now();
final weekday = DateFormat('EEEE').format(date);
final currentTimeToDouble =
    currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);

class OpeningHoursModel {
  final String opening;
  final String closing;

  OpeningHoursModel({
    required this.opening,
    required this.closing,
  });

  static Map<String, OpeningHoursModel> fromMap(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    late final Map<String, OpeningHoursModel> tempMap;
    for (var element in docs) {
      tempMap = element.data().map(
            (key, value) => MapEntry(
              key,
              OpeningHoursModel(opening: value[0], closing: value[1]),
            ),
          );
    }
    return tempMap;
  }

  static double convertTimeToDouble(String getTime) {
    if (getTime != '0') {
      final time = TimeOfDay(
          hour: int.parse(getTime.split(':')[0]),
          minute: int.parse(getTime.split(':')[1]));

      final timeToDouble = time.hour.toDouble() + (time.minute.toDouble() / 60);

      return timeToDouble;
    }
    return 0;
  }

  static Future<bool> closingSoon(BuildContext context) async {
    late final bool closing;
    final closingHour =
        await context.read(openingHoursRepProvider).closingHour();

    final closingHourToDouble =
        OpeningHoursModel.convertTimeToDouble(closingHour);

    if (currentTimeToDouble < closingHourToDouble &&
        currentTimeToDouble >= closingHourToDouble - 1.0) {
      closing = true;
    } else {
      closing = false;
    }
    return closing;
  }
}
