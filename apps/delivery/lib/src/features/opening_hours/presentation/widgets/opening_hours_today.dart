import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';

class OpeningHoursToday extends HookWidget {
  const OpeningHoursToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(openingHoursProvider).when(
      data: (value) {
        final snapDoc = value.docs;
        final todayOpeningHours = snapDoc[0][weekday];
        final closing = todayOpeningHours[1];
        final closingHour = OpeningHoursModel.convertTimeToDouble(closing);
        final openingHour =
            OpeningHoursModel.convertTimeToDouble(todayOpeningHours[0]);

        return Text(
          currentTimeToDouble >= openingHour &&
                  currentTimeToDouble < closingHour
              ? '${context.l10n.openinHoursOpen}: $closing'
              : context.l10n.openingHoursClosed,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: currentTimeToDouble >= openingHour &&
                    currentTimeToDouble < closingHour
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
