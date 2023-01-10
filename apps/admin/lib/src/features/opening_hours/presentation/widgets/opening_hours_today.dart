import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursToday extends HookWidget {
  const OpeningHoursToday({Key? key}) : super(key: key);

  double convertTimeToDouble(String getTime) {
    if (getTime != '0') {
      final time = TimeOfDay(
          hour: int.parse(getTime.split(':')[0]),
          minute: int.parse(getTime.split(':')[1]));

      final timeToDouble = time.hour.toDouble() + (time.minute.toDouble() / 60);

      return timeToDouble;
    }
    return 0;
  }

  bool compareTimes(double nowTimeToDouble, String opening, String closing) {
    return nowTimeToDouble >= convertTimeToDouble(opening) &&
        nowTimeToDouble < convertTimeToDouble(closing);
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final currentTime = TimeOfDay.now();
    final nowTimeToDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);
    final weekday = DateFormat('EEEE').format(date);

    return useProvider(openingHoursProvider).when(
      data: (value) {
        final todayOpeningHours = value.toMap()[weekday]!;
        final opening = todayOpeningHours.opening;
        final closing = todayOpeningHours.closing;

        return Text(
          compareTimes(nowTimeToDouble, opening, closing)
              ? 'Open until: $closing'
              : 'Closed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: compareTimes(nowTimeToDouble, opening, closing)
                ? Colors.green
                : Colors.red,
          ),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
