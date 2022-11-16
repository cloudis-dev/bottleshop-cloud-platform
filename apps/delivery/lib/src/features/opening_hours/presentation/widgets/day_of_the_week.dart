import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:delivery/src/features/opening_hours/presentation/providers/providers.dart';

class DayOfTheWeek extends StatelessWidget {
  const DayOfTheWeek({
    Key? key,
    required this.day,
    required this.hours,
  }) : super(key: key);

  final int day;
  final OpeningHoursModel hours;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final dayName = sortedWeekDays[day];
    final today = DateFormat('EEEE').format(date);
    final days = [
      context.l10n.monday,
      context.l10n.tuesday,
      context.l10n.wednesday,
      context.l10n.thursday,
      context.l10n.friday,
      context.l10n.saturday,
      context.l10n.sunday
    ];
    final pickedDay = days.elementAt(day);

    return Center(
      child: Text(
        (hours.opening == '0' || hours.closing == '0')
            ? '$pickedDay: ${context.l10n.openingHoursClosed}'
            : '$pickedDay: ${hours.opening} - ${hours.closing}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          height: 2,
          fontSize: dayName == today ? 16.5 : 15,
          color:
              dayName == today ? Theme.of(context).colorScheme.secondary : null,
        ),
      ),
    );
  }
}
