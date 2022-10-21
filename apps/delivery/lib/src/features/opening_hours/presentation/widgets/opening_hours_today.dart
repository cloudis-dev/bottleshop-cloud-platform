import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';

// final testProvider = FutureProvider(
//   (ref) {
//     ref.watch(openingHoursProvider);
//   },
// );

final currentTime = TimeOfDay.now();
final date = DateTime.now();
final currentTimeToDouble =
    currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);
final weekday = DateFormat('EEEE').format(date);

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

  @override
  Widget build(BuildContext context) {
    return useProvider(openingHoursProvider).when(
      data: (value) {
        final snapDoc = value.docs;
        final todayOpeningHours = snapDoc[0][weekday];
        final opening = todayOpeningHours[0];
        final closing = todayOpeningHours[1];

        return Text(
          currentTimeToDouble >= convertTimeToDouble(opening) &&
                  currentTimeToDouble < convertTimeToDouble(closing)
              ? '${context.l10n.openinHoursOpen}: $closing'
              : context.l10n.openingHoursClosed,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: currentTimeToDouble >= convertTimeToDouble(opening) &&
                    currentTimeToDouble < convertTimeToDouble(closing)
                ? Colors.green
                : Colors.red,
          ),
        );
      },
      loading: () => const Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}

class OpeningHours {
  final String opening;
  final String closing;

  OpeningHours({
    required this.opening,
    required this.closing,
  });
}
