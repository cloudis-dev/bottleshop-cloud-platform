import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_button.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_checkbox.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_day_text.dart';

class EditOpeningHoursDialog extends StatelessWidget {
  const EditOpeningHoursDialog({Key? key, required this.tempMap})
      : super(key: key);

  final Map<String, dynamic> tempMap;

  @override
  Widget build(BuildContext context) {
    final openingHoursDoc = FirebaseFirestore.instance
        .collection('opening_hours')
        .doc('USFRRzUNHuYt4mwmjsAM');

    return SimpleDialog(
      title: Text('Edit Opening Hours', textAlign: TextAlign.center),
      children: [
        SizedBox(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tempMap.length,
            itemBuilder: (context, rowIndex) {
              final todayOpening = tempMap[sortedWeekDays[rowIndex]];
              var weAreOpen = true;

              if (todayOpening[0] == '0' || todayOpening[1] == '0') {
                weAreOpen = false;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditOpeningHoursDayText(rowIndex: rowIndex),
                  EditOpeningHoursButton(
                    tempMap: tempMap,
                    rowIndex: rowIndex,
                  ),
                  EditOpeningHoursCheckbox(
                    tempMap: tempMap,
                    rowIndex: rowIndex,
                    weAreOpen: weAreOpen,
                  )
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                return openingHoursDoc.update(tempMap);
              },
              child: Text('Edit'),
            ),
          ],
        )
      ],
    );
  }
}
