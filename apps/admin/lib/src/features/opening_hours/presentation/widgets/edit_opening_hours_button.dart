import 'package:flutter/material.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursButton extends StatefulWidget {
  const EditOpeningHoursButton({
    Key? key,
    required this.tempMap,
    required this.rowIndex,
  }) : super(key: key);

  final Map<String, dynamic> tempMap;
  final int rowIndex;

  @override
  State<EditOpeningHoursButton> createState() => _EditOpeningHoursButtonState();
}

class _EditOpeningHoursButtonState extends State<EditOpeningHoursButton> {
  Future<void> timePicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => TimePickerDialog(
          initialTime: TimeOfDay.now(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    final todayOpening = widget.tempMap[sortedWeekDays[widget.rowIndex]];
    var weAreOpen = true;

    if (todayOpening[0] == '0' || todayOpening[1] == '0') {
      weAreOpen = false;
    }

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: todayOpening.length,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: !weAreOpen
                ? null
                : () async {
                    timePicker;
                    final newTime = await showTimePicker(
                        context: context, initialTime: currentTime);
                    if (newTime != null) {
                      setState(() {
                        todayOpening[index] =
                            '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
                        widget.tempMap[sortedWeekDays[widget.rowIndex]][index] =
                            todayOpening[index];
                      });
                    }
                  },
            child: Text(todayOpening[index]),
          );
        },
      ),
    );
  }
}
