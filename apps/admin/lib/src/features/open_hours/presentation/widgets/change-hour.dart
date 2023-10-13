import 'package:bottleshop_admin/src/features/open_hours/data/models/open_hours_model.dart';
import 'package:bottleshop_admin/src/features/open_hours/data/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangeHour extends HookWidget {
  final ValueNotifier<TimeOfDay> selectedTimeFrom;
  final ValueNotifier<TimeOfDay> selectedTimeTo;
  final saveState = useState(false);
  final buttonState = useState(true);
  final ValueNotifier<bool> isClosed;
  OpenHourModel val;

  ChangeHour({super.key, required this.val})
      : selectedTimeFrom = useState(TimeOfDay.fromDateTime(val.dateFrom)),
        selectedTimeTo = useState(TimeOfDay.fromDateTime(val.dateTo)),
        isClosed = useState(val.isClosed);

  Future<void> _selectTimeFrom(BuildContext context) async {
    final picked = await showTimePicker(
        context: context,
        initialTime: selectedTimeFrom.value,
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? Container());
        });
    if (picked != null && picked != selectedTimeFrom) {
      selectedTimeFrom.value = picked;
      if (selectedTimeTo.value.hour < selectedTimeFrom.value.hour ||
          (selectedTimeTo.value.hour == selectedTimeFrom.value.hour &&
              selectedTimeTo.value.minute <= selectedTimeFrom.value.minute))
        buttonState.value = false;
      else
        buttonState.value = true;
      saveState.value = false;
    }
  }

  Future<void> _selectTimeTo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTimeTo.value,
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? Container());
        });
    if (picked != null && picked != selectedTimeTo) {
      selectedTimeTo.value = picked;
      if (selectedTimeTo.value.hour < selectedTimeFrom.value.hour ||
          (selectedTimeTo.value.hour == selectedTimeFrom.value.hour &&
              selectedTimeTo.value.minute <= selectedTimeFrom.value.minute))
        buttonState.value = false;
      else
        buttonState.value = true;
      saveState.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val.type),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isClosed.value
                      ? null
                      : () {
                          _selectTimeFrom(context);
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Otvara sa',
                      hintText: 'Vyberte cas',
                    ),
                    child: Text(
                      '${selectedTimeFrom.value.hour}:${selectedTimeFrom.value.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isClosed.value ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: isClosed.value
                      ? null
                      : () {
                          _selectTimeTo(context);
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Zatvara sa',
                      hintText: 'Vyberte cas',
                    ),
                    child: Text(
                      '${selectedTimeTo.value.hour}:${selectedTimeTo.value.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isClosed.value ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Checkbox(
                  value: isClosed.value,
                  onChanged: (value) {
                    isClosed.value = value!;
                    saveState.value = false;
                  }),
              Text('Zatvorene'),
              SizedBox(width: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: buttonState.value ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: buttonState.value && !saveState.value
                      ? () async {
                          val = val.updateDateTimes(
                              val.dateFrom.copyWith(
                                  hour: selectedTimeFrom.value.hour,
                                  minute: selectedTimeFrom.value.minute),
                              val.dateTo.copyWith(
                                  hour: selectedTimeTo.value.hour,
                                  minute: selectedTimeTo.value.minute));
                          final batch = FirebaseFirestore.instance.batch();
                          await openHoursDb.updateData(
                              val.type,
                              {
                                'dateFrom': val.dateFrom,
                                'dateTo': val.dateTo,
                                'isClosed': isClosed.value
                              },
                              batch: batch);
                          await batch.commit();
                          saveState.value = true;
                        }
                      : null,
                  icon: Icon(
                    saveState.value ? Icons.check : Icons.save,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
