import 'package:bottleshop_admin/src/features/open_hours/data/models/open_hours_model.dart';
import 'package:bottleshop_admin/src/features/open_hours/data/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class ChangeDate extends HookWidget {
  late ValueNotifier<DateTime> selectedTimeFrom;
  late ValueNotifier<DateTime> selectedTimeTo;
  late ValueNotifier<bool> saveState;
  late ValueNotifier<bool> buttonState;
  late ValueNotifier<bool> isClosed;
  DateTime title;
  OpenHourModel val;

  ChangeDate({super.key, required this.val}) : title = val.dateFrom;

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ?? Container());
        });

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  Future<void> _selectTimeFrom(BuildContext context) async {
    final picked = await showDateTimePicker(context: context, initialDate: selectedTimeFrom.value);
    if (picked != null && picked != selectedTimeFrom) {
      selectedTimeFrom.value = picked;
      if (selectedTimeTo.value.hour < selectedTimeFrom.value.hour ||
          selectedTimeTo.value.difference(selectedTimeFrom.value).inDays < 0 ||
          (selectedTimeTo.value.hour == selectedTimeFrom.value.hour &&
              selectedTimeTo.value.minute <= selectedTimeFrom.value.minute))
        buttonState.value = false;
      else
        buttonState.value = true;
      saveState.value = false;
    }
  }

  Future<void> _selectTimeTo(BuildContext context) async {
    final picked = await showDateTimePicker(context: context, initialDate: selectedTimeTo.value);
    if (picked != null && picked != selectedTimeTo) {
      selectedTimeTo.value = picked;
      if (selectedTimeTo.value.hour < selectedTimeFrom.value.hour ||
          selectedTimeTo.value.difference(selectedTimeFrom.value).inDays < 0 ||
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
    selectedTimeFrom = useState(val.dateFrom);
    selectedTimeTo = useState(val.dateTo);
    isClosed = useState(val.isClosed);
    buttonState = useState(true);
    saveState = useState(false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${title.day}.${title.month}'),//'${selectedTimeFrom.value.day}.${selectedTimeFrom.value.month}'),
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
                      hintText: 'Vyberte datum',
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd HH:mm')
                          .format(selectedTimeFrom.value),
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
                      DateFormat('yyyy-MM-dd HH:mm')
                          .format(selectedTimeTo.value),
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
                              selectedTimeFrom.value,
                              selectedTimeTo.value);
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
               SizedBox(width: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    final batch = FirebaseFirestore.instance.batch();
                    await openHoursDb.removeItem(val.type, batch: batch);
                    await batch.commit();
                  },
                  icon: Icon(
                    Icons.delete,
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
