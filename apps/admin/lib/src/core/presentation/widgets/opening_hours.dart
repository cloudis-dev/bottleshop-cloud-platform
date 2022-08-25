import 'package:bottleshop_admin/src/core/presentation/widgets/day_of_the_week.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final openingHoursProvider = FutureProvider(
    (ref) => FirebaseFirestore.instance.collection('opening_hours').get());

class OpeningHours extends StatelessWidget {
  const OpeningHours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final temp = useProvider(openingHoursProvider);
    temp.when(
      data: (value) {},
      loading: () {},
      error: (error, stackTrace) {},
    );

    final currentTime = TimeOfDay.now();
    final date = DateTime.now();
    final day = DateFormat('E d.MMM.yyyy').format(date);
    // final getDoc =

    final nowTimeToDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);
    final weekday = date.weekday;

    final sortedWeekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    String getTodayDayName(int day) {
      late String weekdayToString;

      switch (day) {
        case 1:
          weekdayToString = 'Monday';
          break;
        case 2:
          weekdayToString = 'Tuesday';
          break;
        case 3:
          weekdayToString = 'Wednesday';
          break;
        case 4:
          weekdayToString = 'Thursday';
          break;
        case 5:
          weekdayToString = 'Friday';
          break;
        case 6:
          weekdayToString = 'Saturday';
          break;
        case 7:
          weekdayToString = 'Sunday';
          break;
      }
      return weekdayToString;
    }

    double convertHourToDouble(String getTime) {
      if (getTime != '0') {
        final time = TimeOfDay(
            hour: int.parse(getTime.split(':')[0]),
            minute: int.parse(getTime.split(':')[1]));

        final timeToDouble =
            time.hour.toDouble() + (time.minute.toDouble() / 60);

        return timeToDouble;
      }
      return 0;
    }

    Future<void> timePicker() => showDialog(
          context: context,
          builder: (context) => TimePickerDialog(
            initialTime: TimeOfDay.now(),
          ),
        );

    Future<void> editOpeningHours() async {
      final getData =
          await FirebaseFirestore.instance.collection('opening_hours').get();
      late Map<String, dynamic> getMap;

      for (var element in getData.docs) {
        getMap = element.data();
      }

      return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Edit Opening Hours', textAlign: TextAlign.center),
          children: [
            SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: getMap.length,
                itemBuilder: (context, rowIndex) {
                  final todayOpening = getMap[sortedWeekDays[rowIndex]];

                  var weAreClosed = true;

                  if (todayOpening[0] == '0' || todayOpening[1] == '0') {
                    weAreClosed = false;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: Text(
                          '${sortedWeekDays[rowIndex].substring(0, 3)}.: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: todayOpening.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: !weAreClosed
                                  ? null
                                  : () async {
                                      timePicker;
                                      final newTime = await showTimePicker(
                                          context: context,
                                          initialTime: currentTime);
                                      if (newTime != null) {
                                        todayOpening[index] =
                                            '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
                                        getMap[sortedWeekDays[rowIndex]]
                                            [index] = todayOpening[index];
                                      }
                                    },
                              child: Text(todayOpening[index]),
                            );
                          },
                        ),
                      ),
                      Checkbox(
                        key: ValueKey(rowIndex),
                        value: weAreClosed,
                        onChanged: (value) {
                          if (value == false) {
                            todayOpening[0] = '0';
                            todayOpening[1] = '0';
                          } else {
                            todayOpening[0] = '88:88';
                            todayOpening[1] = '88:88';
                          }
                          weAreClosed = value!;
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('opening_hours')
                        .doc('USFRRzUNHuYt4mwmjsAM')
                        .update(getMap);
                    // Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.of(context).pop();
                    // sumbitNewHours(getMap);
                    // print(getMap);
                  },
                  child: Text('Edit'),
                ),
              ],
            )
          ],
        ),
      );
    }

    Future<void> openingHours() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Opening Hours', textAlign: TextAlign.center),
            content: FutureBuilder(
                future: getDoc,
                builder: (context, dynamic snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final docData = snapshot.data!.docs;

                    return SizedBox(
                      width: double.minPositive,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: sortedWeekDays.length,
                            itemBuilder: (context, index) {
                              return DayOfTheWeek(
                                day: sortedWeekDays[index],
                                hours: docData[0][sortedWeekDays[index]],
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: editOpeningHours,
                            // EditOpeningHours,
                            child: Text('Edit opening hours'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text('Failed to receive data!');
                  }
                }),
          ),
        );

    return Container(
      color: null,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: openingHours,
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
              FutureBuilder(
                future: getDoc,
                builder: (context, dynamic snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final snapDoc = snapshot.data!.docs;
                    final todayOpeningHours =
                        snapDoc[0][getTodayDayName(weekday)];
                    final opening = todayOpeningHours[0];
                    final closing = todayOpeningHours[1];

                    return Text(
                      nowTimeToDouble >= convertHourToDouble(opening) &&
                              nowTimeToDouble < convertHourToDouble(closing)
                          ? 'Otvorene do: $closing'
                          : 'Zatvorene',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: nowTimeToDouble >=
                                    convertHourToDouble(opening) &&
                                nowTimeToDouble < convertHourToDouble(closing)
                            ? Colors.green
                            : Colors.red,
                      ),
                    );
                  } else {
                    return Text('Failed to receive data!');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
