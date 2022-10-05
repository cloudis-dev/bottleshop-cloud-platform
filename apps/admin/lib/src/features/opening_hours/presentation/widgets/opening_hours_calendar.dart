import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/dialogs/opening_hours_dialog.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

class OpeningHoursCalendar extends StatelessWidget {
  const OpeningHoursCalendar({Key? key}) : super(key: key);

  Future<void> openingHoursDialog(BuildContext context) =>
      showDialog(context: context, builder: (context) => OpeningHoursDialog());

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final day = DateFormat('E. d.MMM.yyyy').format(date);

    return Container(
      color: null,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => openingHoursDialog(context),
            borderRadius: BorderRadius.circular(5),
            child: Icon(
              Icons.calendar_month,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Text(
                day,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              OpeningHoursToday(),
            ],
          ),
        ],
      ),
    );
  }
}
