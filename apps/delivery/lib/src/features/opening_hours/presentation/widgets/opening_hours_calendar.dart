import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:delivery/src/features/opening_hours/presentation/dialogs/opening_hours_dialog.dart';
import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

class OpeningHoursCalendar extends StatelessWidget {
  const OpeningHoursCalendar({Key? key}) : super(key: key);

  Future<void> openingHoursDialog(BuildContext context) => showDialog(
      context: context, builder: (context) => const OpeningHoursDialog());

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final day = DateFormat('E. d.MMM.yyyy').format(date);

    return Container(
      color: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const OpeningHoursToday(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
