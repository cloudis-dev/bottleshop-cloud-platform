import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursToday extends HookWidget {
  const OpeningHoursToday({Key? key}) : super(key: key);

  double convertHourToDouble(String getTime) {
    if (getTime != '0') {
      final time = TimeOfDay(
          hour: int.parse(getTime.split(':')[0]),
          minute: int.parse(getTime.split(':')[1]));

      final timeToDouble = time.hour.toDouble() + (time.minute.toDouble() / 60);

      return timeToDouble;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    final date = DateTime.now();
    final nowTimeToDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);
    final weekday = DateFormat('EEEE').format(date);

    return useProvider(openingHoursProvider).when(
      data: (value) {
        final snapDoc = value.docs;
        final todayOpeningHours = snapDoc[0][weekday];
        final opening = todayOpeningHours[0];
        final closing = todayOpeningHours[1];
        return Text(
          nowTimeToDouble >= convertHourToDouble(opening) &&
                  nowTimeToDouble < convertHourToDouble(closing)
              ? 'Otvorene do: $closing'
              : 'Zatvorene',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: nowTimeToDouble >= convertHourToDouble(opening) &&
                    nowTimeToDouble < convertHourToDouble(closing)
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
