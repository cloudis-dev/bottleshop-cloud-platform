import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

class DayOfTheWeek extends StatelessWidget {
  const DayOfTheWeek({
    Key? key,
    required this.day,
    required this.hours,
  }) : super(key: key);

  final String day;
  final OpeningHours hours;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final today = DateFormat('EEEE').format(date);

    return Center(
      child: Text(
        (hours.opening == '0' || hours.closing == '0')
            ? '${AppLocalizations.of(context).greeting("Koos")}: ${context.l10n.openingHoursClosed}'
            : '$day:  ${hours.opening} - ${hours.closing}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          height: 2,
          fontSize: day == today ? 16.5 : 15,
          color: day == today ? Theme.of(context).colorScheme.secondary : null,
        ),
      ),
    );
  }
}
